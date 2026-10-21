import 'package:drift/drift.dart';

import '../app_database.dart';

/// Vinculación de ESTE equipo con una sucursal (`dispositivo_config`,
/// una sola fila). Sin vinculación, nadie que no sea administrador
/// puede iniciar sesión.
class DispositivoRepository {
  DispositivoRepository(this._db);

  final AppDatabase _db;

  Future<DispositivoConfigData?> obtener() {
    return _db.select(_db.dispositivoConfig).getSingleOrNull();
  }

  Stream<DispositivoConfigData?> observar() {
    return _db.select(_db.dispositivoConfig).watchSingleOrNull();
  }

  Future<void> vincular({
    required int sucursalId,
    required int usuarioId,
    String? sucursalNombre,
  }) {
    return _db
        .into(_db.dispositivoConfig)
        .insertOnConflictUpdate(
          DispositivoConfigCompanion.insert(
            id: const Value(1),
            sucursalId: sucursalId,
            sucursalNombre: Value(sucursalNombre),
            vinculadoPorUsuarioId: usuarioId,
            vinculadoEn: Value(DateTime.now().toUtc().toIso8601String()),
          ),
        );
  }

  Future<void> actualizarNombreSucursal(String nombre) {
    return (_db.update(_db.dispositivoConfig)..where((d) => d.id.equals(1)))
        .write(DispositivoConfigCompanion(sucursalNombre: Value(nombre)));
  }

  Future<void> desvincular() => _db.delete(_db.dispositivoConfig).go();
}
