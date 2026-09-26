import 'package:drift/drift.dart';

import '../app_database.dart';
import 'cuentas_queries.dart';

/// Espeja el CHECK (tipo IN ('DEPOSITO_COBRADO','RECIBIDO','ENTREGADO','PRESTADO'))
/// de la tabla `operacion_envase`.
enum TipoOperacionEnvase {
  depositoCobrado,
  prestado,
  entregado,
  recibido;

  String get valorDb => switch (this) {
    TipoOperacionEnvase.depositoCobrado => 'DEPOSITO_COBRADO',
    TipoOperacionEnvase.prestado => 'PRESTADO',
    TipoOperacionEnvase.entregado => 'ENTREGADO',
    TipoOperacionEnvase.recibido => 'RECIBIDO',
  };
}

/// Un ítem de envase dentro de una venta (lo consume
/// `VentaRepository.registrarVentaConPago`).
class OperacionEnvaseVenta {
  const OperacionEnvaseVenta({
    required this.tipoEnvaseId,
    required this.tipo,
    required this.cantidad,
    this.montoUnitarioCentavos,
  });

  final int tipoEnvaseId;
  final TipoOperacionEnvase tipo;
  final int cantidad;

  /// Obligatorio (y >= 0) solo si [tipo] es [TipoOperacionEnvase.depositoCobrado].
  final int? montoUnitarioCentavos;
}

/// Se lanza tanto para el préstamo (Tipo C) como para el depósito cobrado
/// (Tipo A): ambos dejan un pendiente ligado a la venta (envase por
/// devolver, o depósito por devolver) que hoy solo es recuperable desde
/// la ficha del cliente — sin cliente asociado, ese pendiente queda sin
/// forma de liquidarse desde la app.
class EnvaseSinClienteException implements Exception {
  EnvaseSinClienteException();

  @override
  String toString() =>
      'Prestar un envase o cobrar un depósito de envase requiere asociar la venta a un cliente';
}

class DepositoSinMontoException implements Exception {
  DepositoSinMontoException();

  @override
  String toString() => 'Cobrar un depósito de envase requiere el monto unitario';
}

class CantidadExcedePendienteEnvaseException implements Exception {
  CantidadExcedePendienteEnvaseException({
    required this.solicitada,
    required this.pendiente,
  });

  final int solicitada;
  final int pendiente;

  @override
  String toString() =>
      'Se pidió liquidar $solicitada pero solo hay $pendiente pendiente en esa venta';
}

class StockEnvaseInsuficienteException implements Exception {
  StockEnvaseInsuficienteException({
    required this.tipoEnvaseId,
    required this.solicitado,
    required this.disponible,
  });

  final int tipoEnvaseId;
  final int solicitado;
  final int disponible;

  @override
  String toString() =>
      'Stock insuficiente del envase $tipoEnvaseId: '
      'se pidieron $solicitado y hay $disponible disponibles';
}

class VentaOriginalNoCompletadaException implements Exception {
  VentaOriginalNoCompletadaException(this.ventaId);

  final int ventaId;

  @override
  String toString() =>
      'La venta $ventaId no está COMPLETADA: no se puede liquidar envase contra ella';
}

class EnvaseRepository {
  EnvaseRepository(this._db);

  final AppDatabase _db;
  late final CuentasQueries _cuentas = CuentasQueries(_db);

  /// Cliente trae de vuelta el envase vacío de [ventaOriginalId] y se le
  /// devuelve el depósito (Tipo A). El monto unitario a devolver es el
  /// mismo con el que se cobró originalmente en esa venta (snapshot
  /// histórico), no el precio actual del catálogo.
  Future<void> devolverDeposito({
    required int ventaOriginalId,
    required int tipoEnvaseId,
    required int cantidad,
    required int usuarioId,
    required int cajaSesionId,
  }) async {
    if (cantidad <= 0) {
      throw ArgumentError.value(cantidad, 'cantidad', 'Debe ser mayor que 0');
    }

    return _db.transaction(() async {
      await _validarVentaCompletada(ventaOriginalId);

      final pendiente = await _cuentas.depositoPendienteVenta(
        ventaOriginalId,
        tipoEnvaseId,
      );
      if (cantidad > pendiente) {
        throw CantidadExcedePendienteEnvaseException(
          solicitada: cantidad,
          pendiente: pendiente,
        );
      }

      final original = await _db.customSelect(
        '''
        SELECT monto_unitario_centavos FROM cuenta_deposito_envase_mov
        WHERE venta_id = ? AND tipo_envase_id = ? AND tipo = 'COBRADO'
        LIMIT 1
        ''',
        variables: [
          Variable.withInt(ventaOriginalId),
          Variable.withInt(tipoEnvaseId),
        ],
        readsFrom: {_db.cuentaDepositoEnvaseMov},
      ).getSingle();
      final montoUnitario = original.read<int>('monto_unitario_centavos');

      await _db.into(_db.cuentaDepositoEnvaseMov).insert(
        CuentaDepositoEnvaseMovCompanion.insert(
          ventaId: ventaOriginalId,
          tipoEnvaseId: tipoEnvaseId,
          tipo: 'DEVUELTO',
          cantidad: cantidad,
          montoUnitarioCentavos: montoUnitario,
          referenciaTipo: const Value('VENTA'),
          referenciaId: Value(ventaOriginalId),
          usuarioId: usuarioId,
        ),
      );

      await _db.into(_db.envaseInventarioMov).insert(
        EnvaseInventarioMovCompanion.insert(
          tipoEnvaseId: tipoEnvaseId,
          tipo: 'ENTRADA_DEVOLUCION',
          cantidad: cantidad,
          referenciaTipo: const Value('VENTA'),
          referenciaId: Value(ventaOriginalId),
          usuarioId: usuarioId,
        ),
      );

      await _db.into(_db.movimientoCaja).insert(
        MovimientoCajaCompanion.insert(
          cajaSesionId: cajaSesionId,
          tipo: 'DEVOLUCION',
          montoCentavos: -(cantidad * montoUnitario),
          referenciaTipo: const Value('VENTA'),
          referenciaId: Value(ventaOriginalId),
          usuarioId: usuarioId,
        ),
      );
    });
  }

  /// Cliente devuelve físicamente un envase que tenía prestado (Tipo C,
  /// sin depósito) de [ventaOriginalId], sin pagar nada.
  Future<void> devolverEnvasePrestado({
    required int ventaOriginalId,
    required int clienteId,
    required int tipoEnvaseId,
    required int cantidad,
    required int usuarioId,
  }) async {
    if (cantidad <= 0) {
      throw ArgumentError.value(cantidad, 'cantidad', 'Debe ser mayor que 0');
    }

    return _db.transaction(() async {
      await _validarVentaCompletada(ventaOriginalId);

      final pendiente = await _cuentas.envasePendienteVenta(
        ventaOriginalId,
        tipoEnvaseId,
      );
      if (cantidad > pendiente) {
        throw CantidadExcedePendienteEnvaseException(
          solicitada: cantidad,
          pendiente: pendiente,
        );
      }

      await _db.into(_db.cuentaEnvaseMov).insert(
        CuentaEnvaseMovCompanion.insert(
          clienteId: clienteId,
          ventaId: Value(ventaOriginalId),
          tipoEnvaseId: tipoEnvaseId,
          tipo: 'DEVOLUCION',
          cantidad: cantidad,
          referenciaTipo: const Value('VENTA'),
          referenciaId: Value(ventaOriginalId),
          usuarioId: usuarioId,
        ),
      );

      await _db.into(_db.envaseInventarioMov).insert(
        EnvaseInventarioMovCompanion.insert(
          tipoEnvaseId: tipoEnvaseId,
          tipo: 'ENTRADA_DEVOLUCION',
          cantidad: cantidad,
          referenciaTipo: const Value('VENTA'),
          referenciaId: Value(ventaOriginalId),
          usuarioId: usuarioId,
        ),
      );
    });
  }

  /// Cliente paga en efectivo en vez de devolver el envase prestado de
  /// [ventaOriginalId] (reposición). No hay movimiento físico: el envase
  /// ya salió del inventario en el momento del préstamo y no vuelve.
  Future<void> pagarEnvasePrestado({
    required int ventaOriginalId,
    required int clienteId,
    required int tipoEnvaseId,
    required int cantidad,
    required int montoCentavos,
    required int usuarioId,
    required int cajaSesionId,
  }) async {
    if (cantidad <= 0) {
      throw ArgumentError.value(cantidad, 'cantidad', 'Debe ser mayor que 0');
    }

    return _db.transaction(() async {
      await _validarVentaCompletada(ventaOriginalId);

      final pendiente = await _cuentas.envasePendienteVenta(
        ventaOriginalId,
        tipoEnvaseId,
      );
      if (cantidad > pendiente) {
        throw CantidadExcedePendienteEnvaseException(
          solicitada: cantidad,
          pendiente: pendiente,
        );
      }

      await _db.into(_db.cuentaEnvaseMov).insert(
        CuentaEnvaseMovCompanion.insert(
          clienteId: clienteId,
          ventaId: Value(ventaOriginalId),
          tipoEnvaseId: tipoEnvaseId,
          tipo: 'PAGO',
          cantidad: cantidad,
          montoCentavos: Value(montoCentavos),
          referenciaTipo: const Value('VENTA'),
          referenciaId: Value(ventaOriginalId),
          usuarioId: usuarioId,
        ),
      );

      await _db.into(_db.movimientoCaja).insert(
        MovimientoCajaCompanion.insert(
          cajaSesionId: cajaSesionId,
          tipo: 'PAGO_ENVASE',
          montoCentavos: montoCentavos,
          referenciaTipo: const Value('PAGO_ENVASE_CLIENTE'),
          usuarioId: usuarioId,
        ),
      );
    });
  }

  /// Compra de envases sueltos directamente a un cliente (recompra), sin
  /// relación a ningún préstamo ni venta previa.
  Future<void> comprarEnvaseACliente({
    required int tipoEnvaseId,
    required int cantidad,
    required int montoCentavos,
    required int usuarioId,
    required int cajaSesionId,
  }) {
    if (cantidad <= 0) {
      throw ArgumentError.value(cantidad, 'cantidad', 'Debe ser mayor que 0');
    }

    return _db.transaction(() async {
      await _db.into(_db.envaseInventarioMov).insert(
        EnvaseInventarioMovCompanion.insert(
          tipoEnvaseId: tipoEnvaseId,
          tipo: 'COMPRA_ENVASE_CLIENTE',
          cantidad: cantidad,
          usuarioId: usuarioId,
        ),
      );

      await _db.into(_db.movimientoCaja).insert(
        MovimientoCajaCompanion.insert(
          cajaSesionId: cajaSesionId,
          tipo: 'COMPRA_ENVASE_CLIENTE',
          montoCentavos: -montoCentavos,
          referenciaTipo: const Value('COMPRA_ENVASE_CLIENTE'),
          usuarioId: usuarioId,
        ),
      );
    });
  }

  /// Compra de envases vacíos a un proveedor. Movimiento independiente,
  /// sin ligar a ninguna `compra` (esa tabla solo maneja `producto_id`) —
  /// mismo patrón que `InventarioRepository.registrarAjuste`.
  Future<int> registrarCompraAProveedor({
    required int tipoEnvaseId,
    required int cantidad,
    required int usuarioId,
  }) {
    if (cantidad <= 0) {
      throw ArgumentError.value(cantidad, 'cantidad', 'Debe ser mayor que 0');
    }

    return _db.into(_db.envaseInventarioMov).insert(
      EnvaseInventarioMovCompanion.insert(
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'COMPRA_PROVEEDOR',
        cantidad: cantidad,
        usuarioId: usuarioId,
      ),
    );
  }

  Future<int> saldoFisico(int tipoEnvaseId) => _cuentas.saldoFisicoEnvase(tipoEnvaseId);

  /// Versión reactiva de [saldoFisico] (ver [CuentasQueries.observarSaldoFisicoEnvase]).
  Stream<int> observarSaldoFisico(int tipoEnvaseId) =>
      _cuentas.observarSaldoFisicoEnvase(tipoEnvaseId);

  /// Operaciones de envase (depósito, préstamo, entrega, recepción)
  /// registradas junto con una venta específica.
  Future<List<OperacionEnvaseData>> listarOperaciones(int ventaId) {
    return (_db.select(
      _db.operacionEnvase,
    )..where((o) => o.ventaId.equals(ventaId))).get();
  }

  Future<void> _validarVentaCompletada(int ventaId) async {
    final venta = await (_db.select(
      _db.venta,
    )..where((v) => v.id.equals(ventaId))).getSingleOrNull();
    if (venta == null || venta.estado != 'COMPLETADA') {
      throw VentaOriginalNoCompletadaException(ventaId);
    }
  }
}
