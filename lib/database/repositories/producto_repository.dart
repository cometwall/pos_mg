import 'package:drift/drift.dart';

import '../app_database.dart';

/// Espeja el CHECK (unidad IN ('pieza','peso')) de la tabla `producto`.
enum UnidadProducto {
  pieza,
  peso;

  String get valorDb => name;

  static UnidadProducto desdeDb(String valor) => UnidadProducto.values.byName(valor);
}

class ProductoRepository {
  ProductoRepository(this._db);

  final AppDatabase _db;

  Future<int> crear({
    required String nombre,
    required String codigoInterno,
    required UnidadProducto unidad,
    required int precioVentaCentavos,
    String? codigoBarras,
    int? categoriaId,
    int? tipoEnvaseId,
    int? costoReferenciaCentavos,
  }) {
    return _db.into(_db.producto).insert(
      ProductoCompanion.insert(
        nombre: nombre,
        codigoInterno: codigoInterno,
        unidad: unidad.valorDb,
        precioVentaCentavos: precioVentaCentavos,
        codigoBarras: Value(codigoBarras),
        categoriaId: Value(categoriaId),
        tipoEnvaseId: Value(tipoEnvaseId),
        costoReferenciaCentavos: Value(costoReferenciaCentavos),
      ),
    );
  }

  Future<ProductoData?> obtenerPorId(int id) {
    return (_db.select(
      _db.producto,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Future<List<ProductoData>> listarActivos() {
    return (_db.select(_db.producto)
          ..where((p) => p.activo.equals(1))
          ..orderBy([(p) => OrderingTerm.asc(p.nombre)]))
        .get();
  }

  /// Coincide por nombre parcial, o por código de barras / código interno
  /// exacto (para lectura de escáner). Con texto vacío devuelve los activos.
  Future<List<ProductoData>> buscar(String texto) {
    final query = texto.trim();
    if (query.isEmpty) return listarActivos();

    final patron = '%$query%';
    return (_db.select(_db.producto)
          ..where(
            (p) =>
                p.activo.equals(1) &
                (p.nombre.like(patron) |
                    p.codigoBarras.equals(query) |
                    p.codigoInterno.equals(query)),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.nombre)]))
        .get();
  }
}
