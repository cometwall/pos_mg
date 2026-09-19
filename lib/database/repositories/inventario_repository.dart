import 'package:drift/drift.dart';

import '../app_database.dart';

class InventarioRepository {
  InventarioRepository(this._db);

  final AppDatabase _db;

  /// Stock actual del producto, leído del saldo materializado (nunca
  /// recalculando el historial completo). Si el producto nunca tuvo
  /// movimientos no existe fila en `inventario_saldo` y el stock es 0.
  Future<int> consultarSaldo(int productoId) async {
    final fila = await (_db.select(
      _db.inventarioSaldo,
    )..where((s) => s.productoId.equals(productoId))).getSingleOrNull();
    return fila?.cantidadActual ?? 0;
  }

  /// Inserta un ajuste manual de inventario. [cantidad] es el delta con
  /// signo (positivo suma stock, negativo lo resta). Un ajuste que
  /// dejara el saldo negativo lo rechaza la base (CHECK de
  /// inventario_saldo.cantidad_actual >= 0), sin dejar el movimiento
  /// insertado a medias.
  Future<int> registrarAjuste({
    required int productoId,
    required int cantidad,
    required int usuarioId,
  }) {
    return _db.into(_db.movimientoInventario).insert(
      MovimientoInventarioCompanion.insert(
        productoId: productoId,
        tipo: 'AJUSTE',
        cantidad: cantidad,
        referenciaTipo: const Value('AJUSTE_MANUAL'),
        usuarioId: usuarioId,
      ),
    );
  }

  /// Historial de movimientos del producto, más reciente primero.
  Future<List<MovimientoInventarioData>> listarMovimientos(int productoId) {
    return (_db.select(_db.movimientoInventario)
          ..where((m) => m.productoId.equals(productoId))
          ..orderBy([
            (m) => OrderingTerm.desc(m.fecha),
            (m) => OrderingTerm.desc(m.id),
          ]))
        .get();
  }
}
