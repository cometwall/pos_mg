import 'package:drift/drift.dart';

import '../app_database.dart';
import 'cuentas_queries.dart';
import 'envase_repository.dart';
import 'pago_repository.dart';

class ItemVenta {
  const ItemVenta({
    required this.productoId,
    required this.cantidad,
    required this.precioUnitarioCentavos,
    required this.costoUnitarioCentavos,
    int? subtotalCentavos,
  }) : _subtotalCentavosOverride = subtotalCentavos;

  final int productoId;
  final int cantidad;
  final int precioUnitarioCentavos;
  final int costoUnitarioCentavos;

  /// Para productos por pieza, el subtotal es `cantidad * precioUnitario`
  /// (comportamiento por defecto). Para productos por peso, `cantidad`
  /// son gramos y `precioUnitarioCentavos` es solo el precio de catálogo
  /// por kilogramo con fines de referencia — multiplicarlos directamente
  /// daría un subtotal 1000x mayor, así que el llamador debe pasar el
  /// subtotal ya calculado correctamente (ver `core/quantity.dart`).
  final int? _subtotalCentavosOverride;

  int get subtotalCentavos => _subtotalCentavosOverride ?? cantidad * precioUnitarioCentavos;
}

class Cobro {
  const Cobro({required this.metodo, required this.montoCentavos, this.ivaCentavos = 0});

  final MetodoPago metodo;
  final int montoCentavos;
  final int ivaCentavos;
}

class StockInsuficienteException implements Exception {
  StockInsuficienteException({
    required this.productoId,
    required this.solicitado,
    required this.disponible,
  });

  final int productoId;
  final int solicitado;
  final int disponible;

  @override
  String toString() =>
      'Stock insuficiente para el producto $productoId: '
      'se pidieron $solicitado y hay $disponible disponibles';
}

class PagoIncompletoException implements Exception {
  PagoIncompletoException({required this.esperado, required this.recibido});

  final int esperado;
  final int recibido;

  @override
  String toString() =>
      'La suma de los cobros ($recibido) no cubre el total de la venta ($esperado)';
}

class VentaNoEncontradaException implements Exception {
  VentaNoEncontradaException(this.ventaId);

  final int ventaId;

  @override
  String toString() => 'No existe una venta con id $ventaId';
}

class VentaNoCancelableException implements Exception {
  VentaNoCancelableException(this.ventaId, this.estadoActual);

  final int ventaId;
  final String estadoActual;

  @override
  String toString() =>
      'La venta $ventaId no se puede cancelar (estado actual: $estadoActual)';
}

/// Cubre tanto `cancelarVenta` como `DevolucionRepository.registrarDevolucion`
/// (decisión de producto: el reembolso de un pago con tarjeta se resuelve
/// manualmente fuera del sistema, nunca automáticamente).
class ReembolsoTarjetaNoSoportadoException implements Exception {
  ReembolsoTarjetaNoSoportadoException(this.ventaId);

  final int ventaId;

  @override
  String toString() =>
      'La venta $ventaId tiene un pago con tarjeta: el reembolso de esa parte '
      'debe resolverse manualmente fuera del sistema';
}

class TerminalCajaNoCoincideException implements Exception {
  TerminalCajaNoCoincideException();

  @override
  String toString() =>
      'La sesión de caja indicada no pertenece al terminal de la venta, o no está abierta';
}

class VentaRepository {
  VentaRepository(this._db);

  final AppDatabase _db;
  late final CuentasQueries _cuentas = CuentasQueries(_db);

  /// Registra una venta básica sin pago: cabecera, una línea de
  /// `detalle_venta` por ítem y su respectivo movimiento de inventario
  /// (tipo VENTA, en negativo). Para el flujo de cobro completo usa
  /// [registrarVentaConPago].
  Future<int> registrarVenta({
    required int terminalId,
    required String folio,
    required int usuarioId,
    required List<ItemVenta> items,
    int? clienteId,
  }) {
    return _db.transaction(
      () => _crearVenta(
        terminalId: terminalId,
        folio: folio,
        usuarioId: usuarioId,
        items: items,
        clienteId: clienteId,
      ),
    );
  }

  /// La "transacción completa": venta + sus pagos (efectivo y/o
  /// tarjeta) + el movimiento de caja del efectivo recibido + las
  /// operaciones de envase (depósito, préstamo, intercambio), todo en
  /// una sola transacción atómica. [cobros] debe sumar exactamente el
  /// total de la venta — un pago parcial se maneja después como abono
  /// a la cuenta del cliente, no aquí. Si algún cobro es en efectivo o
  /// hay un depósito de envase cobrado, [cajaSesionId] es obligatorio y
  /// debe ser una sesión ABIERTA del mismo terminal (lo exigen los
  /// triggers de la base). Prestar un envase (Tipo C) exige [clienteId].
  Future<int> registrarVentaConPago({
    required int terminalId,
    required String folio,
    required int usuarioId,
    required List<ItemVenta> items,
    required List<Cobro> cobros,
    int? clienteId,
    int? cajaSesionId,
    List<OperacionEnvaseVenta> operacionesEnvase = const [],
  }) async {
    final totalCobrado = cobros.fold<int>(0, (acc, c) => acc + c.montoCentavos);
    final subtotalCentavos = items.fold<int>(0, (acc, item) => acc + item.subtotalCentavos);
    if (totalCobrado != subtotalCentavos) {
      throw PagoIncompletoException(esperado: subtotalCentavos, recibido: totalCobrado);
    }
    if (cobros.any((c) => c.metodo == MetodoPago.efectivo) && cajaSesionId == null) {
      throw ArgumentError.value(
        cajaSesionId,
        'cajaSesionId',
        'Se requiere una sesión de caja abierta para cobrar en efectivo',
      );
    }
    if (operacionesEnvase.any((o) => o.tipo == TipoOperacionEnvase.prestado) &&
        clienteId == null) {
      throw EnvasePrestadoSinClienteException();
    }
    final tieneDeposito = operacionesEnvase.any(
      (o) => o.tipo == TipoOperacionEnvase.depositoCobrado,
    );
    if (tieneDeposito) {
      if (cajaSesionId == null) {
        throw ArgumentError.value(
          cajaSesionId,
          'cajaSesionId',
          'Se requiere una sesión de caja abierta para cobrar depósito de envase',
        );
      }
      final faltaMonto = operacionesEnvase.any(
        (o) => o.tipo == TipoOperacionEnvase.depositoCobrado && o.montoUnitarioCentavos == null,
      );
      if (faltaMonto) {
        throw DepositoSinMontoException();
      }
    }

    return _db.transaction(() async {
      final ventaId = await _crearVenta(
        terminalId: terminalId,
        folio: folio,
        usuarioId: usuarioId,
        items: items,
        clienteId: clienteId,
      );

      for (final cobro in cobros) {
        await _db.into(_db.pago).insert(
          PagoCompanion.insert(
            ventaId: ventaId,
            metodo: cobro.metodo.valorDb,
            montoCentavos: cobro.montoCentavos,
            ivaCentavos: Value(cobro.ivaCentavos),
          ),
        );

        if (cobro.metodo == MetodoPago.efectivo) {
          await _db.into(_db.movimientoCaja).insert(
            MovimientoCajaCompanion.insert(
              cajaSesionId: cajaSesionId!,
              tipo: 'VENTA_EFECTIVO',
              montoCentavos: cobro.montoCentavos,
              referenciaTipo: const Value('VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );
        }
      }

      if (operacionesEnvase.isNotEmpty) {
        await _registrarOperacionesEnvase(
          ventaId: ventaId,
          clienteId: clienteId,
          usuarioId: usuarioId,
          operaciones: operacionesEnvase,
          cajaSesionId: cajaSesionId,
        );
      }

      return ventaId;
    });
  }

  /// Cancela una venta COMPLETADA llevando cada cuenta (inventario,
  /// depósitos, préstamos de envase, deuda monetaria) a cero desde su
  /// estado NETO PENDIENTE — no revierte ciegamente el documento
  /// original: si ya hubo devoluciones parciales, solo se revierte lo
  /// que seguía activo. Rechaza la operación si la venta tuvo algún
  /// pago con tarjeta (ver [ReembolsoTarjetaNoSoportadoException]).
  Future<void> cancelarVenta({
    required int ventaId,
    required int usuarioId,
    int? cajaSesionId,
  }) {
    return _db.transaction(() async {
      final venta = await (_db.select(
        _db.venta,
      )..where((v) => v.id.equals(ventaId))).getSingleOrNull();
      if (venta == null) throw VentaNoEncontradaException(ventaId);
      if (venta.estado != 'COMPLETADA') {
        throw VentaNoCancelableException(ventaId, venta.estado);
      }

      final pagoTarjeta = await (_db.select(_db.pago)..where(
        (p) => p.ventaId.equals(ventaId) & p.metodo.equals('TARJETA'),
      )).getSingleOrNull();
      if (pagoTarjeta != null) {
        throw ReembolsoTarjetaNoSoportadoException(ventaId);
      }

      // --- Solo lecturas: nada se escribe todavía ---
      final detalles = await (_db.select(
        _db.detalleVenta,
      )..where((d) => d.ventaId.equals(ventaId))).get();

      final lineasActivas = <(int productoId, int cantidadActiva, int precioUnitario)>[];
      var montoActivoTotal = 0;
      for (final detalle in detalles) {
        final activa = await _cuentas.cantidadActivaDetalle(detalle.id);
        if (activa > 0) {
          lineasActivas.add((detalle.productoId, activa, detalle.precioUnitarioCentavos));
          montoActivoTotal += activa * detalle.precioUnitarioCentavos;
        }
      }

      final depositosPendientes = <int, int>{};
      for (final tipoEnvaseId in await _cuentas.tiposEnvaseConDepositoEnVenta(ventaId)) {
        final pendiente = await _cuentas.depositoPendienteVenta(ventaId, tipoEnvaseId);
        if (pendiente > 0) depositosPendientes[tipoEnvaseId] = pendiente;
      }

      final prestamosPendientes = <int, int>{};
      for (final tipoEnvaseId in await _cuentas.tiposEnvaseConPrestamoEnVenta(ventaId)) {
        final pendiente = await _cuentas.envasePendienteVenta(ventaId, tipoEnvaseId);
        if (pendiente > 0) prestamosPendientes[tipoEnvaseId] = pendiente;
      }

      final deudaPendiente = await _cuentas.deudaPendienteVenta(ventaId);

      // --- Escritura: primero el estado (único campo editable) ---
      await (_db.update(
        _db.venta,
      )..where((v) => v.id.equals(ventaId))).write(
        const VentaCompanion(estado: Value('CANCELADA')),
      );

      // --- Ahora las filas de reversión, ya con estado CANCELADA ---
      for (final (productoId, cantidadActiva, _) in lineasActivas) {
        await _db.into(_db.movimientoInventario).insert(
          MovimientoInventarioCompanion.insert(
            productoId: productoId,
            tipo: 'CANCELACION',
            cantidad: cantidadActiva,
            referenciaTipo: const Value('CANCELACION_VENTA'),
            referenciaId: Value(ventaId),
            usuarioId: usuarioId,
          ),
        );
      }

      final depositoMontoUnitario = <int, int>{};
      for (final entry in depositosPendientes.entries) {
        final original = await _db.customSelect(
          '''
          SELECT monto_unitario_centavos FROM cuenta_deposito_envase_mov
          WHERE venta_id = ? AND tipo_envase_id = ? AND tipo = 'COBRADO'
          LIMIT 1
          ''',
          variables: [Variable.withInt(ventaId), Variable.withInt(entry.key)],
          readsFrom: {_db.cuentaDepositoEnvaseMov},
        ).getSingle();
        final montoUnitario = original.read<int>('monto_unitario_centavos');
        depositoMontoUnitario[entry.key] = montoUnitario;

        await _db.into(_db.cuentaDepositoEnvaseMov).insert(
          CuentaDepositoEnvaseMovCompanion.insert(
            ventaId: ventaId,
            tipoEnvaseId: entry.key,
            tipo: 'CANCELACION',
            cantidad: entry.value,
            montoUnitarioCentavos: montoUnitario,
            referenciaTipo: const Value('CANCELACION_VENTA'),
            referenciaId: Value(ventaId),
            usuarioId: usuarioId,
          ),
        );
        await _db.into(_db.envaseInventarioMov).insert(
          EnvaseInventarioMovCompanion.insert(
            tipoEnvaseId: entry.key,
            tipo: 'CANCELACION',
            cantidad: entry.value,
            referenciaTipo: const Value('CANCELACION_VENTA'),
            referenciaId: Value(ventaId),
            usuarioId: usuarioId,
          ),
        );
      }

      for (final entry in prestamosPendientes.entries) {
        final prestamo = await (_db.select(_db.cuentaEnvaseMov)..where(
          (c) =>
              c.ventaId.equals(ventaId) &
              c.tipoEnvaseId.equals(entry.key) &
              c.tipo.equals('PRESTAMO'),
        )).getSingle();

        await _db.into(_db.cuentaEnvaseMov).insert(
          CuentaEnvaseMovCompanion.insert(
            clienteId: prestamo.clienteId,
            ventaId: Value(ventaId),
            tipoEnvaseId: entry.key,
            tipo: 'CANCELACION',
            cantidad: entry.value,
            referenciaTipo: const Value('CANCELACION_VENTA'),
            referenciaId: Value(ventaId),
            usuarioId: usuarioId,
          ),
        );
        await _db.into(_db.envaseInventarioMov).insert(
          EnvaseInventarioMovCompanion.insert(
            tipoEnvaseId: entry.key,
            tipo: 'CANCELACION',
            cantidad: entry.value,
            referenciaTipo: const Value('CANCELACION_VENTA'),
            referenciaId: Value(ventaId),
            usuarioId: usuarioId,
          ),
        );
      }

      if (deudaPendiente > 0) {
        await _db.into(_db.cuentaMonetariaMov).insert(
          CuentaMonetariaMovCompanion.insert(
            clienteId: venta.clienteId!,
            ventaId: Value(ventaId),
            tipo: 'CANCELACION',
            montoCentavos: deudaPendiente,
            referenciaTipo: const Value('CANCELACION_VENTA'),
            referenciaId: Value(ventaId),
            usuarioId: usuarioId,
          ),
        );
      }

      final montoDepositoTotal = depositosPendientes.entries.fold<int>(
        0,
        (acc, entry) => acc + entry.value * depositoMontoUnitario[entry.key]!,
      );

      if (montoActivoTotal > 0 || montoDepositoTotal > 0) {
        if (cajaSesionId == null) {
          throw ArgumentError.value(
            cajaSesionId,
            'cajaSesionId',
            'Se requiere una sesión de caja abierta para reembolsar la cancelación',
          );
        }
        final sesion = await (_db.select(
          _db.cajaSesion,
        )..where((s) => s.id.equals(cajaSesionId))).getSingleOrNull();
        if (sesion == null || sesion.terminalId != venta.terminalId) {
          throw TerminalCajaNoCoincideException();
        }

        if (montoActivoTotal > 0) {
          await _db.into(_db.movimientoCaja).insert(
            MovimientoCajaCompanion.insert(
              cajaSesionId: cajaSesionId,
              tipo: 'CANCELACION',
              montoCentavos: -montoActivoTotal,
              referenciaTipo: const Value('CANCELACION_VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );
        }

        // El reembolso del depósito de envase se registra aparte del de
        // producto (misma referencia, montos distintos) para que quede
        // trazable por separado, igual que en EnvaseRepository.devolverDeposito.
        if (montoDepositoTotal > 0) {
          await _db.into(_db.movimientoCaja).insert(
            MovimientoCajaCompanion.insert(
              cajaSesionId: cajaSesionId,
              tipo: 'CANCELACION',
              montoCentavos: -montoDepositoTotal,
              referenciaTipo: const Value('CANCELACION_VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );
        }
      }
    });
  }

  /// Valida stock e inserta cabecera + detalle + movimientos de
  /// inventario. Debe llamarse dentro de una transacción ya abierta.
  Future<int> _crearVenta({
    required int terminalId,
    required String folio,
    required int usuarioId,
    required List<ItemVenta> items,
    int? clienteId,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError.value(items, 'items', 'Una venta necesita al menos un producto');
    }

    for (final item in items) {
      final saldo = await (_db.select(
        _db.inventarioSaldo,
      )..where((s) => s.productoId.equals(item.productoId))).getSingleOrNull();
      final disponible = saldo?.cantidadActual ?? 0;
      if (item.cantidad > disponible) {
        throw StockInsuficienteException(
          productoId: item.productoId,
          solicitado: item.cantidad,
          disponible: disponible,
        );
      }
    }

    final subtotalCentavos = items.fold<int>(0, (acc, item) => acc + item.subtotalCentavos);

    final ventaId = await _db.into(_db.venta).insert(
      VentaCompanion.insert(
        terminalId: terminalId,
        folio: folio,
        usuarioId: usuarioId,
        clienteId: Value(clienteId),
        subtotalCentavos: Value(subtotalCentavos),
        totalCentavos: Value(subtotalCentavos),
      ),
    );

    for (final item in items) {
      await _db.into(_db.detalleVenta).insert(
        DetalleVentaCompanion.insert(
          ventaId: ventaId,
          productoId: item.productoId,
          cantidad: item.cantidad,
          precioUnitarioCentavos: item.precioUnitarioCentavos,
          costoUnitarioCentavos: item.costoUnitarioCentavos,
          subtotalCentavos: item.subtotalCentavos,
        ),
      );

      await _db.into(_db.movimientoInventario).insert(
        MovimientoInventarioCompanion.insert(
          productoId: item.productoId,
          tipo: 'VENTA',
          cantidad: -item.cantidad,
          referenciaTipo: const Value('VENTA'),
          referenciaId: Value(ventaId),
          usuarioId: usuarioId,
        ),
      );
    }

    return ventaId;
  }

  /// Inserta `operacion_envase` por cada ítem, más las filas de cuenta /
  /// inventario físico / caja que le correspondan según su tipo. Debe
  /// llamarse dentro de una transacción ya abierta (ver
  /// [registrarVentaConPago]).
  Future<void> _registrarOperacionesEnvase({
    required int ventaId,
    required int? clienteId,
    required int usuarioId,
    required List<OperacionEnvaseVenta> operaciones,
    required int? cajaSesionId,
  }) async {
    for (final op in operaciones) {
      final esSalidaFisica =
          op.tipo == TipoOperacionEnvase.depositoCobrado ||
          op.tipo == TipoOperacionEnvase.prestado ||
          op.tipo == TipoOperacionEnvase.entregado;

      if (esSalidaFisica) {
        final saldoFisico = await _cuentas.saldoFisicoEnvase(op.tipoEnvaseId);
        if (op.cantidad > saldoFisico) {
          throw StockEnvaseInsuficienteException(
            tipoEnvaseId: op.tipoEnvaseId,
            solicitado: op.cantidad,
            disponible: saldoFisico,
          );
        }
      }

      await _db.into(_db.operacionEnvase).insert(
        OperacionEnvaseCompanion.insert(
          ventaId: ventaId,
          tipoEnvaseId: op.tipoEnvaseId,
          tipo: op.tipo.valorDb,
          cantidad: op.cantidad,
          montoUnitarioCentavos: Value(op.montoUnitarioCentavos),
        ),
      );

      switch (op.tipo) {
        case TipoOperacionEnvase.depositoCobrado:
          await _db.into(_db.cuentaDepositoEnvaseMov).insert(
            CuentaDepositoEnvaseMovCompanion.insert(
              ventaId: ventaId,
              tipoEnvaseId: op.tipoEnvaseId,
              tipo: 'COBRADO',
              cantidad: op.cantidad,
              montoUnitarioCentavos: op.montoUnitarioCentavos!,
              referenciaTipo: const Value('VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );
          await _db.into(_db.envaseInventarioMov).insert(
            EnvaseInventarioMovCompanion.insert(
              tipoEnvaseId: op.tipoEnvaseId,
              tipo: 'SALIDA_PRESTAMO',
              cantidad: -op.cantidad,
              referenciaTipo: const Value('VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );
          await _db.into(_db.movimientoCaja).insert(
            MovimientoCajaCompanion.insert(
              cajaSesionId: cajaSesionId!,
              tipo: 'ENTRADA',
              montoCentavos: op.cantidad * op.montoUnitarioCentavos!,
              referenciaTipo: const Value('VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );

        case TipoOperacionEnvase.prestado:
          await _db.into(_db.cuentaEnvaseMov).insert(
            CuentaEnvaseMovCompanion.insert(
              clienteId: clienteId!,
              ventaId: Value(ventaId),
              tipoEnvaseId: op.tipoEnvaseId,
              tipo: 'PRESTAMO',
              cantidad: op.cantidad,
              referenciaTipo: const Value('VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );
          await _db.into(_db.envaseInventarioMov).insert(
            EnvaseInventarioMovCompanion.insert(
              tipoEnvaseId: op.tipoEnvaseId,
              tipo: 'SALIDA_PRESTAMO',
              cantidad: -op.cantidad,
              referenciaTipo: const Value('VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );

        case TipoOperacionEnvase.entregado:
          await _db.into(_db.envaseInventarioMov).insert(
            EnvaseInventarioMovCompanion.insert(
              tipoEnvaseId: op.tipoEnvaseId,
              tipo: 'SALIDA_PRESTAMO',
              cantidad: -op.cantidad,
              referenciaTipo: const Value('VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );

        case TipoOperacionEnvase.recibido:
          await _db.into(_db.envaseInventarioMov).insert(
            EnvaseInventarioMovCompanion.insert(
              tipoEnvaseId: op.tipoEnvaseId,
              tipo: 'ENTRADA_DEVOLUCION',
              cantidad: op.cantidad,
              referenciaTipo: const Value('VENTA'),
              referenciaId: Value(ventaId),
              usuarioId: usuarioId,
            ),
          );
      }
    }
  }

  Future<List<DetalleVentaData>> listarDetalle(int ventaId) {
    return (_db.select(
      _db.detalleVenta,
    )..where((d) => d.ventaId.equals(ventaId))).get();
  }

  /// Historial de ventas, más recientes primero, como stream: se
  /// refresca solo cuando cambia la tabla (nueva venta, cancelación).
  Stream<List<VentaData>> observarVentas() {
    return (_db.select(_db.venta)..orderBy([
          (v) => OrderingTerm.desc(v.fecha),
          (v) => OrderingTerm.desc(v.id),
        ]))
        .watch();
  }

  Future<VentaData?> obtenerPorId(int ventaId) {
    return (_db.select(
      _db.venta,
    )..where((v) => v.id.equals(ventaId))).getSingleOrNull();
  }
}
