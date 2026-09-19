import 'package:drift/drift.dart';

import '../app_database.dart';
import 'pago_repository.dart';

class ItemVenta {
  const ItemVenta({
    required this.productoId,
    required this.cantidad,
    required this.precioUnitarioCentavos,
    required this.costoUnitarioCentavos,
  });

  final int productoId;
  final int cantidad;
  final int precioUnitarioCentavos;
  final int costoUnitarioCentavos;

  int get subtotalCentavos => cantidad * precioUnitarioCentavos;
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

class VentaRepository {
  VentaRepository(this._db);

  final AppDatabase _db;

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
  /// tarjeta) + el movimiento de caja del efectivo recibido, todo en
  /// una sola transacción atómica. [cobros] debe sumar exactamente el
  /// total de la venta — un pago parcial se maneja después como abono
  /// a la cuenta del cliente, no aquí. Si algún cobro es en efectivo,
  /// [cajaSesionId] es obligatorio y debe ser una sesión ABIERTA del
  /// mismo terminal (lo exigen los triggers de la base).
  Future<int> registrarVentaConPago({
    required int terminalId,
    required String folio,
    required int usuarioId,
    required List<ItemVenta> items,
    required List<Cobro> cobros,
    int? clienteId,
    int? cajaSesionId,
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

      return ventaId;
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

  Future<List<DetalleVentaData>> listarDetalle(int ventaId) {
    return (_db.select(
      _db.detalleVenta,
    )..where((d) => d.ventaId.equals(ventaId))).get();
  }
}
