import 'package:drift/drift.dart';

import '../app_database.dart';

class SesionCajaNoEncontradaException implements Exception {
  SesionCajaNoEncontradaException(this.cajaSesionId);

  final int cajaSesionId;

  @override
  String toString() => 'No existe una sesión de caja con id $cajaSesionId';
}

class SesionCajaNoAbiertaException implements Exception {
  SesionCajaNoAbiertaException(this.cajaSesionId);

  final int cajaSesionId;

  @override
  String toString() => 'La sesión de caja $cajaSesionId no está ABIERTA';
}

/// Espeja los tipos de `movimiento_caja` que el cajero puede registrar a
/// mano (entradas/retiros de efectivo sin relación a una venta).
enum TipoMovimientoManual {
  entrada,
  retiro;

  String get valorDb => switch (this) {
    TipoMovimientoManual.entrada => 'ENTRADA',
    TipoMovimientoManual.retiro => 'RETIRO',
  };
}

class CajaRepository {
  CajaRepository(this._db);

  final AppDatabase _db;

  /// Igual que consultar el estado de `caja_sesion` para el terminal,
  /// pero como stream: se recalcula solo cuando cambia la tabla (p. ej.
  /// al abrir o cerrar una sesión), sin que la UI tenga que refrescar
  /// manualmente.
  Stream<CajaSesionData?> observarSesionAbierta(int terminalId) {
    return (_db.select(_db.cajaSesion)..where(
      (s) => s.terminalId.equals(terminalId) & s.estado.equals('ABIERTA'),
    )).watchSingleOrNull();
  }

  /// Versión reactiva de [efectivoEsperado]: se recalcula cada vez que
  /// hay un nuevo `movimiento_caja` en la sesión.
  Stream<int> observarEfectivoEsperado(int cajaSesionId) {
    final movimientos = (_db.select(
      _db.movimientoCaja,
    )..where((m) => m.cajaSesionId.equals(cajaSesionId))).watch();
    return movimientos.asyncMap((lista) async {
      final sesion = await (_db.select(
        _db.cajaSesion,
      )..where((s) => s.id.equals(cajaSesionId))).getSingle();
      final suma = lista.fold<int>(0, (acc, m) => acc + m.montoCentavos);
      return sesion.efectivoInicialCentavos + suma;
    });
  }

  /// Versión reactiva de [listarMovimientos].
  Stream<List<MovimientoCajaData>> observarMovimientos(int cajaSesionId) {
    return (_db.select(_db.movimientoCaja)
          ..where((m) => m.cajaSesionId.equals(cajaSesionId))
          ..orderBy([
            (m) => OrderingTerm.desc(m.fecha),
            (m) => OrderingTerm.desc(m.id),
          ]))
        .watch();
  }

  /// Entrada o retiro de efectivo sin relación a una venta (p. ej. fondeo
  /// inicial adicional, retiro para depósito bancario). [montoCentavos]
  /// siempre se pasa positivo; el signo aplicado en `movimiento_caja` lo
  /// decide [tipo] (entrada = positivo, retiro = negativo). El trigger
  /// `trg_movimiento_caja_sesion_abierta` ya rechaza esto si la sesión no
  /// está ABIERTA.
  Future<int> registrarMovimientoManual({
    required int cajaSesionId,
    required TipoMovimientoManual tipo,
    required int montoCentavos,
    required String motivo,
    required int usuarioId,
  }) {
    if (montoCentavos <= 0) {
      throw ArgumentError.value(
        montoCentavos,
        'montoCentavos',
        'Debe ser mayor que 0',
      );
    }
    final signo = tipo == TipoMovimientoManual.entrada ? 1 : -1;
    return _db.into(_db.movimientoCaja).insert(
      MovimientoCajaCompanion.insert(
        cajaSesionId: cajaSesionId,
        tipo: tipo.valorDb,
        montoCentavos: signo * montoCentavos,
        motivo: Value(motivo),
        referenciaTipo: const Value('MANUAL'),
        usuarioId: usuarioId,
      ),
    );
  }

  /// Abre una sesión de caja para el terminal. El índice único
  /// `idx_caja_unica_abierta` (una sola sesión ABIERTA por terminal)
  /// hace que una segunda apertura sobre el mismo terminal falle sola,
  /// sin necesidad de validarlo aquí.
  Future<int> abrirSesion({
    required int terminalId,
    required int usuarioAperturaId,
    required int efectivoInicialCentavos,
  }) {
    return _db.into(_db.cajaSesion).insert(
      CajaSesionCompanion.insert(
        terminalId: terminalId,
        usuarioAperturaId: usuarioAperturaId,
        efectivoInicialCentavos: efectivoInicialCentavos,
      ),
    );
  }

  /// `efectivo_esperado_centavos` según la fórmula documentada en el
  /// esquema: inicial + suma de todos los movimientos de esa sesión.
  Future<int> efectivoEsperado(int cajaSesionId) async {
    final sesion = await (_db.select(
      _db.cajaSesion,
    )..where((s) => s.id.equals(cajaSesionId))).getSingle();

    final sumaMovimientos = _db.movimientoCaja.montoCentavos.sum();
    final query = _db.selectOnly(_db.movimientoCaja)
      ..addColumns([sumaMovimientos])
      ..where(_db.movimientoCaja.cajaSesionId.equals(cajaSesionId));
    final fila = await query.getSingle();

    return sesion.efectivoInicialCentavos + (fila.read(sumaMovimientos) ?? 0);
  }

  Future<List<MovimientoCajaData>> listarMovimientos(int cajaSesionId) {
    return (_db.select(_db.movimientoCaja)
          ..where((m) => m.cajaSesionId.equals(cajaSesionId))
          ..orderBy([
            (m) => OrderingTerm.desc(m.fecha),
            (m) => OrderingTerm.desc(m.id),
          ]))
        .get();
  }

  /// Cierra una sesión ABIERTA: calcula `efectivo_esperado_centavos` (vía
  /// [efectivoEsperado]), guarda lo que el usuario contó físicamente y la
  /// diferencia entre ambos, y marca `estado='CERRADA'` — todos los
  /// campos de cierre se escriben juntos en el mismo UPDATE, tal como
  /// exige el CHECK compuesto de `caja_sesion`.
  Future<void> cerrarSesion({
    required int cajaSesionId,
    required int usuarioCierreId,
    required int efectivoContadoCentavos,
  }) {
    return _db.transaction(() async {
      final sesion = await (_db.select(
        _db.cajaSesion,
      )..where((s) => s.id.equals(cajaSesionId))).getSingleOrNull();
      if (sesion == null) throw SesionCajaNoEncontradaException(cajaSesionId);
      if (sesion.estado != 'ABIERTA') {
        throw SesionCajaNoAbiertaException(cajaSesionId);
      }

      final esperado = await efectivoEsperado(cajaSesionId);
      final diferencia = efectivoContadoCentavos - esperado;

      final ahora = await _db
          .customSelect("SELECT datetime('now') AS ahora")
          .getSingle();

      final filasActualizadas =
          await (_db.update(_db.cajaSesion)..where(
            (s) => s.id.equals(cajaSesionId) & s.estado.equals('ABIERTA'),
          )).write(
            CajaSesionCompanion(
              usuarioCierreId: Value(usuarioCierreId),
              fechaCierre: Value(ahora.read<String>('ahora')),
              efectivoEsperadoCentavos: Value(esperado),
              efectivoContadoCentavos: Value(efectivoContadoCentavos),
              diferenciaCentavos: Value(diferencia),
              estado: const Value('CERRADA'),
            ),
          );

      if (filasActualizadas == 0) {
        throw SesionCajaNoAbiertaException(cajaSesionId);
      }
    });
  }
}
