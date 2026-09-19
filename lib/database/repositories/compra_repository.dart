import 'package:drift/drift.dart';

import '../app_database.dart';

class ItemCompra {
  const ItemCompra({
    required this.productoId,
    required this.cantidad,
    required this.costoUnitarioCentavos,
  });

  final int productoId;
  final int cantidad;
  final int costoUnitarioCentavos;

  int get subtotalCentavos => cantidad * costoUnitarioCentavos;
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

  Future<List<DetalleCompraData>> listarDetalle(int compraId) {
    return (_db.select(
      _db.detalleCompra,
    )..where((d) => d.compraId.equals(compraId))).get();
  }
}
