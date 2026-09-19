import 'package:drift/drift.dart';

import '../app_database.dart';

class CajaRepository {
  CajaRepository(this._db);

  final AppDatabase _db;

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
}
