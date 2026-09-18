import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Base de datos de MI TIENDA. El esquema (tablas, índices y triggers)
/// vive en `schema.drift` — este archivo solo abre la conexión y
/// controla la migración inicial.
@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Reconstruye `inventario_saldo` desde cero a partir de
  /// `movimiento_inventario`. Procedimiento administrativo: úsalo solo
  /// si [reconciliarInventario] detectó discrepancias. Si el historial
  /// tuviera un saldo neto negativo para algún producto, el CHECK
  /// (cantidad_actual >= 0) hará fallar la reconstrucción — es la señal
  /// correcta de que hay que investigar el historial antes de confiar
  /// en el saldo materializado.
  Future<void> reconstruirInventarioSaldo() {
    return transaction(() async {
      await customStatement('INSERT INTO saldo_guard (activo) VALUES (1)');
      await customStatement('DELETE FROM inventario_saldo');
      await customStatement('''
        INSERT INTO inventario_saldo (producto_id, cantidad_actual, actualizado_en)
        SELECT producto_id, SUM(cantidad), datetime('now')
        FROM movimiento_inventario
        GROUP BY producto_id
      ''');
      await customStatement('DELETE FROM saldo_guard');
    });
  }

  /// Verificación de salud, solo lectura: devuelve una fila por cada
  /// producto donde `inventario_saldo` no coincide con la suma real de
  /// `movimiento_inventario`. En un sistema sano no debe devolver filas.
  Future<List<QueryRow>> reconciliarInventario() {
    return customSelect('''
      SELECT p.id, p.nombre,
             COALESCE(s.cantidad_actual, 0) AS saldo_materializado,
             COALESCE((SELECT SUM(m.cantidad) FROM movimiento_inventario m
                        WHERE m.producto_id = p.id), 0) AS saldo_calculado
      FROM producto p
      LEFT JOIN inventario_saldo s ON s.producto_id = p.id
      WHERE COALESCE(s.cantidad_actual, 0) !=
            COALESCE((SELECT SUM(m.cantidad) FROM movimiento_inventario m
                       WHERE m.producto_id = p.id), 0)
    ''').get();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'pos_mg');
}
