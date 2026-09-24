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

  /// Actualiza los datos de catálogo de un producto (nombre, precio,
  /// códigos, categoría, tipo de envase). A diferencia de las tablas de
  /// hechos, `producto` es una tabla de catálogo normal — sin triggers
  /// que bloqueen UPDATE — así que esto es una edición directa, sin
  /// implicar ningún movimiento de inventario ni afectar ventas ya
  /// registradas (que ya guardaron su propio precio histórico en
  /// `detalle_venta.precio_unitario_centavos`).
  Future<void> actualizar({
    required int id,
    required String nombre,
    required String codigoInterno,
    required UnidadProducto unidad,
    required int precioVentaCentavos,
    String? codigoBarras,
    int? categoriaId,
    int? tipoEnvaseId,
    int? costoReferenciaCentavos,
  }) {
    return (_db.update(_db.producto)..where((p) => p.id.equals(id))).write(
      ProductoCompanion(
        nombre: Value(nombre),
        codigoInterno: Value(codigoInterno),
        unidad: Value(unidad.valorDb),
        precioVentaCentavos: Value(precioVentaCentavos),
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
    return _selectActivos().get();
  }

  /// Coincide por nombre parcial, o por código de barras / código interno
  /// exacto (para lectura de escáner). Con texto vacío devuelve los activos.
  Future<List<ProductoData>> buscar(String texto) {
    return _selectBusqueda(texto).get();
  }

  /// Versión reactiva de [listarActivos]: se refresca sola si se crea,
  /// edita o desactiva cualquier producto.
  Stream<List<ProductoData>> observarActivos() {
    return _selectActivos().watch();
  }

  /// Versión reactiva de [buscar], usada por la búsqueda de Ventas para
  /// que un precio/nombre editado en Productos se refleje de inmediato
  /// sin tener que volver a escribir la búsqueda.
  Stream<List<ProductoData>> observarBusqueda(String texto) {
    return _selectBusqueda(texto).watch();
  }

  Selectable<ProductoData> _selectActivos() {
    return _db.select(_db.producto)
      ..where((p) => p.activo.equals(1))
      ..orderBy([(p) => OrderingTerm.asc(p.nombre)]);
  }

  Selectable<ProductoData> _selectBusqueda(String texto) {
    final query = texto.trim();
    if (query.isEmpty) return _selectActivos();

    final patron = '%$query%';
    return _db.select(_db.producto)
      ..where(
        (p) =>
            p.activo.equals(1) &
            (p.nombre.like(patron) |
                p.codigoBarras.equals(query) |
                p.codigoInterno.equals(query)),
      )
      ..orderBy([(p) => OrderingTerm.asc(p.nombre)]);
  }
}
