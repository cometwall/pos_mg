import 'package:drift/drift.dart';

import '../app_database.dart';

class ClienteRepository {
  ClienteRepository(this._db);

  final AppDatabase _db;

  Future<int> crear({
    required String nombre,
    String? telefono,
    int? umbralAdvertenciaCentavos,
  }) {
    return _db.into(_db.cliente).insert(
      ClienteCompanion.insert(
        nombre: nombre,
        telefono: Value(telefono),
        umbralAdvertenciaCentavos: Value(umbralAdvertenciaCentavos),
      ),
    );
  }

  Future<ClienteData?> obtenerPorId(int id) {
    return (_db.select(
      _db.cliente,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<List<ClienteData>> listarActivos() {
    return (_db.select(_db.cliente)
          ..where((c) => c.activo.equals(1))
          ..orderBy([(c) => OrderingTerm.asc(c.nombre)]))
        .get();
  }

  /// Coincide por nombre parcial. Con texto vacío devuelve los activos.
  Future<List<ClienteData>> buscarPorNombre(String texto) {
    final query = texto.trim();
    if (query.isEmpty) return listarActivos();

    final patron = '%$query%';
    return (_db.select(_db.cliente)
          ..where((c) => c.activo.equals(1) & c.nombre.like(patron))
          ..orderBy([(c) => OrderingTerm.asc(c.nombre)]))
        .get();
  }
}
