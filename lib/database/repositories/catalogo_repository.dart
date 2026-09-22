import 'package:drift/drift.dart';

import '../app_database.dart';

/// Espeja el CHECK (rol IN ('DUEÑO','CAJERO')) de la tabla `usuario`.
enum RolUsuario {
  dueno,
  cajero;

  String get valorDb => switch (this) {
    RolUsuario.dueno => 'DUEÑO',
    RolUsuario.cajero => 'CAJERO',
  };
}

class TerminalRepository {
  TerminalRepository(this._db);

  final AppDatabase _db;

  Future<int> crear({required String nombre, required String codigo}) {
    return _db.into(_db.terminal).insert(
      TerminalCompanion.insert(nombre: nombre, codigo: codigo),
    );
  }

  Future<List<TerminalData>> listarActivos() {
    return (_db.select(
      _db.terminal,
    )..where((t) => t.activo.equals(1))).get();
  }

  Future<TerminalData?> buscarPorCodigo(String codigo) {
    return (_db.select(
      _db.terminal,
    )..where((t) => t.codigo.equals(codigo))).getSingleOrNull();
  }
}

class UsuarioRepository {
  UsuarioRepository(this._db);

  final AppDatabase _db;

  Future<int> crear({required String nombre, required RolUsuario rol}) {
    return _db.into(
      _db.usuario,
    ).insert(UsuarioCompanion.insert(nombre: nombre, rol: rol.valorDb));
  }

  Future<List<UsuarioData>> listarActivos() {
    return (_db.select(
      _db.usuario,
    )..where((u) => u.activo.equals(1))).get();
  }
}

class CategoriaRepository {
  CategoriaRepository(this._db);

  final AppDatabase _db;

  Future<int> crear({required String nombre}) {
    return _db.into(
      _db.categoria,
    ).insert(CategoriaCompanion.insert(nombre: nombre));
  }

  Future<List<CategoriaData>> listarTodas() {
    return (_db.select(
      _db.categoria,
    )..orderBy([(c) => OrderingTerm.asc(c.nombre)])).get();
  }
}

class TipoEnvaseRepository {
  TipoEnvaseRepository(this._db);

  final AppDatabase _db;

  Future<int> crear({
    required String nombre,
    int valorDepositoCentavos = 0,
    int? valorReposicionCentavos,
  }) {
    return _db.into(_db.tipoEnvase).insert(
      TipoEnvaseCompanion.insert(
        nombre: nombre,
        valorDepositoCentavos: Value(valorDepositoCentavos),
        valorReposicionCentavos: Value(valorReposicionCentavos),
      ),
    );
  }

  Future<List<TipoEnvaseData>> listarActivos() {
    return (_db.select(
      _db.tipoEnvase,
    )..where((t) => t.activo.equals(1))).get();
  }

  Future<TipoEnvaseData?> obtenerPorId(int id) {
    return (_db.select(
      _db.tipoEnvase,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}

class ProveedorRepository {
  ProveedorRepository(this._db);

  final AppDatabase _db;

  Future<int> crear({required String nombre}) {
    return _db.into(
      _db.proveedor,
    ).insert(ProveedorCompanion.insert(nombre: nombre));
  }

  Future<List<ProveedorData>> listarTodos() {
    return (_db.select(
      _db.proveedor,
    )..orderBy([(p) => OrderingTerm.asc(p.nombre)])).get();
  }
}
