import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';

import '../app_database.dart';
import 'catalogo_repository.dart';

/// Perfil del usuario tal como lo devuelve el backend en `/login`.
class PerfilRemoto {
  const PerfilRemoto({
    required this.id,
    required this.nombreUsuario,
    required this.esAdmin,
    required this.sucursalId,
  });

  factory PerfilRemoto.fromJson(Map<String, dynamic> json) => PerfilRemoto(
    id: json['id'] as int,
    nombreUsuario: json['nombre_usuario'] as String,
    esAdmin: json['es_admin'] as bool,
    sucursalId: json['id_sucursal'] as int,
  );

  final int id;
  final String nombreUsuario;
  final bool esAdmin;
  final int sucursalId;
}

/// Persistencia local de la identidad del backend y de la credencial
/// que permite el login sin conexión. El backend sigue siendo la fuente
/// de verdad: aquí solo se cachea lo que devolvió el último login
/// online exitoso.
class UsuarioAuthRepository {
  UsuarioAuthRepository(this._db, {this.iteraciones = 100000});

  final AppDatabase _db;

  /// Iteraciones de PBKDF2 para credenciales NUEVAS. Las ya guardadas
  /// se verifican con las iteraciones con que se crearon.
  final int iteraciones;

  /// Crea o actualiza el usuario local que corresponde a [perfil] y
  /// devuelve la fila resultante. `es_admin` se refleja en el `rol`
  /// existente (admin → DUEÑO, común → CAJERO).
  Future<UsuarioData> upsertDesdeRemoto(PerfilRemoto perfil) {
    return _db.transaction(() async {
      final rol = perfil.esAdmin ? RolUsuario.dueno : RolUsuario.cajero;
      final existente = await (_db.select(
        _db.usuario,
      )..where((u) => u.remotoId.equals(perfil.id))).getSingleOrNull();

      // Otro usuario local con el mismo nombre pero distinta identidad
      // remota (la cuenta se borró y recreó en el backend): se le quita
      // el nombre y su credencial, para que la contraseña vieja no
      // abra la cuenta nueva en modo offline.
      final homonimo =
          await (_db.select(_db.usuario)..where(
                (u) =>
                    u.nombreUsuario.equals(perfil.nombreUsuario) &
                    u.remotoId.equals(perfil.id).not(),
              ))
              .getSingleOrNull();
      if (homonimo != null) {
        await (_db.update(_db.usuario)..where((u) => u.id.equals(homonimo.id)))
            .write(const UsuarioCompanion(nombreUsuario: Value(null)));
        await (_db.delete(
          _db.credencialOffline,
        )..where((c) => c.usuarioId.equals(homonimo.id))).go();
      }

      final datos = UsuarioCompanion(
        nombre: Value(perfil.nombreUsuario),
        rol: Value(rol.valorDb),
        activo: const Value(1),
        remotoId: Value(perfil.id),
        nombreUsuario: Value(perfil.nombreUsuario),
        sucursalId: Value(perfil.sucursalId),
      );

      final int id;
      if (existente == null) {
        id = await _db.into(_db.usuario).insert(datos);
      } else {
        id = existente.id;
        await (_db.update(
          _db.usuario,
        )..where((u) => u.id.equals(id))).write(datos);
      }
      return (_db.select(
        _db.usuario,
      )..where((u) => u.id.equals(id))).getSingle();
    });
  }

  /// Usuarios del backend conocidos por este equipo (los que han
  /// iniciado sesión aquí o se registraron desde aquí) de una sucursal.
  Stream<List<UsuarioData>> observarDeSucursal(int sucursalId) {
    return (_db.select(_db.usuario)
          ..where(
            (u) => u.sucursalId.equals(sucursalId) & u.remotoId.isNotNull(),
          )
          ..orderBy([(u) => OrderingTerm.asc(u.nombreUsuario)]))
        .watch();
  }

  Future<UsuarioData?> buscarPorNombreUsuario(String nombreUsuario) {
    return (_db.select(_db.usuario)..where(
          (u) => u.nombreUsuario.equals(nombreUsuario) & u.activo.equals(1),
        ))
        .getSingleOrNull();
  }

  Future<void> guardarCredencial(int usuarioId, String password) async {
    final salt = _saltAleatorio();
    final hash = await _derivar(password, salt, iteraciones);
    await _db
        .into(_db.credencialOffline)
        .insertOnConflictUpdate(
          CredencialOfflineCompanion.insert(
            usuarioId: Value(usuarioId),
            hash: hash,
            salt: salt,
            iteraciones: iteraciones,
            actualizadoEn: Value(DateTime.now().toUtc().toIso8601String()),
          ),
        );
  }

  Future<CredencialOfflineData?> obtenerCredencial(int usuarioId) {
    return (_db.select(
      _db.credencialOffline,
    )..where((c) => c.usuarioId.equals(usuarioId))).getSingleOrNull();
  }

  Future<void> borrarCredencial(int usuarioId) {
    return (_db.delete(
      _db.credencialOffline,
    )..where((c) => c.usuarioId.equals(usuarioId))).go();
  }

  /// `false` tanto si la contraseña no coincide como si el usuario
  /// nunca guardó credencial en este equipo.
  Future<bool> verificarCredencial(int usuarioId, String password) async {
    final credencial = await obtenerCredencial(usuarioId);
    if (credencial == null) return false;
    final hash = await _derivar(
      password,
      credencial.salt,
      credencial.iteraciones,
    );
    return _igualesTiempoConstante(hash, credencial.hash);
  }

  static Uint8List _saltAleatorio() {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(16, (_) => random.nextInt(256)));
  }

  /// PBKDF2-HMAC-SHA256 en un isolate aparte: con 100k iteraciones en
  /// Dart puro tarda lo suficiente como para congelar la UI.
  static Future<Uint8List> _derivar(
    String password,
    Uint8List salt,
    int iteraciones,
  ) {
    return Isolate.run(() async {
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: iteraciones,
        bits: 256,
      );
      final clave = await pbkdf2.deriveKeyFromPassword(
        password: password,
        nonce: salt,
      );
      return Uint8List.fromList(await clave.extractBytes());
    });
  }

  static bool _igualesTiempoConstante(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diferencia = 0;
    for (var i = 0; i < a.length; i++) {
      diferencia |= a[i] ^ b[i];
    }
    return diferencia == 0;
  }
}
