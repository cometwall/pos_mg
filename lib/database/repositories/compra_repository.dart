import 'package:drift/drift.dart';

import '../app_database.dart';

class CompraNoEncontradaException implements Exception {
  CompraNoEncontradaException(this.compraId);

  final int compraId;

  @override
  String toString() => 'No existe una compra con id $compraId';
}

class CompraNoCancelableException implements Exception {
  CompraNoCancelableException(this.compraId, this.estadoActual);

  final int compraId;
  final String estadoActual;

  @override
  String toString() =>
      'La compra $compraId no se puede cancelar (estado actual: $estadoActual)';
}

class StockInsuficienteParaCancelarException implements Exception {
  StockInsuficienteParaCancelarException({
    required this.productoId,
    required this.aRevertir,
    required this.disponible,
  });

  final int productoId;
  final int aRevertir;
  final int disponible;

  @override
  String toString() =>
      'No se puede cancelar: el producto $productoId necesita revertir $aRevertir '
      'unidades pero solo hay $disponible en stock (ya se vendió parte de esta compra)';
}

class ItemCompra {
  const ItemCompra({
    required this.productoId,
    required this.cantidad,
    required this.costoUnitarioCentavos,
    int? subtotalCentavos,
  }) : _subtotalCentavosOverride = subtotalCentavos;

  final int productoId;
  final int cantidad;
  final int costoUnitarioCentavos;

  /// Para productos por pieza, el subtotal es `cantidad * costoUnitario`
  /// (comportamiento por defecto). Para productos por peso, `cantidad`
  /// son gramos y `costoUnitarioCentavos` es solo el costo de referencia
  /// por kilogramo — igual que en `ItemVenta`, el llamador debe pasar el
  /// subtotal ya calculado correctamente (ver `core/quantity.dart`).
  final int? _subtotalCentavosOverride;

  int get subtotalCentavos => _subtotalCentavosOverride ?? cantidad * costoUnitarioCentavos;
}

class CompraRepository {
  CompraRepository(this._db);

  final AppDatabase _db;

  /// Registra una compra completa: la cabecera con el total ya
  /// calculado, una línea de `detalle_compra` por ítem y su respectivo
  /// movimiento de inventario (tipo COMPRA, que alimenta
  /// `inventario_saldo` vía el trigger correspondiente). Todo ocurre en
  /// una sola transacción: si cualquier línea falla (por ejemplo un
  /// producto inexistente), no queda nada de la compra registrado.
  Future<int> registrarCompra({
    required int terminalId,
    required String folio,
    required int proveedorId,
    required int usuarioId,
    required List<ItemCompra> items,
    int? cajaSesionId,
  }) {
    if (items.isEmpty) {
      throw ArgumentError.value(items, 'items', 'Una compra necesita al menos un producto');
    }

    final totalCentavos = items.fold<int>(0, (acc, item) => acc + item.subtotalCentavos);

    return _db.transaction(() async {
      final compraId = await _db.into(_db.compra).insert(
        CompraCompanion.insert(
          terminalId: terminalId,
          folio: folio,
          proveedorId: proveedorId,
          usuarioId: usuarioId,
          cajaSesionId: Value(cajaSesionId),
          totalCentavos: Value(totalCentavos),
        ),
      );

      for (final item in items) {
        await _db.into(_db.detalleCompra).insert(
          DetalleCompraCompanion.insert(
            compraId: compraId,
            productoId: item.productoId,
            cantidad: item.cantidad,
            costoUnitarioCentavos: item.costoUnitarioCentavos,
            subtotalCentavos: item.subtotalCentavos,
          ),
        );

        await _db.into(_db.movimientoInventario).insert(
          MovimientoInventarioCompanion.insert(
            productoId: item.productoId,
            tipo: 'COMPRA',
            cantidad: item.cantidad,
            referenciaTipo: const Value('COMPRA'),
            referenciaId: Value(compraId),
            usuarioId: usuarioId,
          ),
        );
      }

      return compraId;
    });
  }

  /// Historial de compras, más recientes primero.
  Stream<List<CompraData>> observarCompras() {
    return (_db.select(_db.compra)..orderBy([
          (c) => OrderingTerm.desc(c.fecha),
          (c) => OrderingTerm.desc(c.id),
        ]))
        .watch();
  }

  Future<List<DetalleCompraData>> listarDetalle(int compraId) {
    return (_db.select(
      _db.detalleCompra,
    )..where((d) => d.compraId.equals(compraId))).get();
  }

  /// Cancela una compra COMPLETADA revirtiendo el 100% de cada línea
  /// (no existe `devolucion` de compra, así que no hay "cantidad
  /// activa" que calcular: todo lo comprado se revierte). Se valida
  /// primero que quede stock suficiente de cada producto — si ya se
  /// vendió parte de lo comprado, la cancelación se rechaza con un
  /// mensaje explicable en vez de dejar que el CHECK de
  /// `inventario_saldo` la rechace con un error genérico.
  Future<void> cancelarCompra({required int compraId, required int usuarioId}) {
    return _db.transaction(() async {
      final compra = await (_db.select(
        _db.compra,
      )..where((c) => c.id.equals(compraId))).getSingleOrNull();
      if (compra == null) throw CompraNoEncontradaException(compraId);
      if (compra.estado != 'COMPLETADA') {
        throw CompraNoCancelableException(compraId, compra.estado);
      }

      final detalles = await listarDetalle(compraId);

      for (final detalle in detalles) {
        final saldo = await (_db.select(
          _db.inventarioSaldo,
        )..where((s) => s.productoId.equals(detalle.productoId))).getSingleOrNull();
        final disponible = saldo?.cantidadActual ?? 0;
        if (detalle.cantidad > disponible) {
          throw StockInsuficienteParaCancelarException(
            productoId: detalle.productoId,
            aRevertir: detalle.cantidad,
            disponible: disponible,
          );
        }
      }

      await (_db.update(
        _db.compra,
      )..where((c) => c.id.equals(compraId))).write(
        const CompraCompanion(estado: Value('CANCELADA')),
      );

      for (final detalle in detalles) {
        await _db.into(_db.movimientoInventario).insert(
          MovimientoInventarioCompanion.insert(
            productoId: detalle.productoId,
            tipo: 'CANCELACION',
            cantidad: -detalle.cantidad,
            referenciaTipo: const Value('CANCELACION_COMPRA'),
            referenciaId: Value(compraId),
            usuarioId: usuarioId,
          ),
        );
      }
    });
  }
}
