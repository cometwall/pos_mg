import '../../../database/app_database.dart';
import '../../../database/repositories/catalogo_repository.dart';
import '../../../database/repositories/dispositivo_repository.dart';
import '../../../database/repositories/usuario_auth_repository.dart';
import '../data/auth_api.dart';

enum ModoSesion { online, offline }

class SesionUsuario {
  const SesionUsuario({required this.usuario, required this.modo, this.tokens});

  final UsuarioData usuario;
  final ModoSesion modo;

  /// Solo presentes en sesiones online. Se guardan únicamente en
  /// memoria; [AuthController] los renueva antes de que expiren.
  final TokensSesion? tokens;

  String? get accessToken => tokens?.accessToken;
  String? get refreshToken => tokens?.refreshToken;

  bool get esAdmin => usuario.rol == RolUsuario.dueno.valorDb;
  bool get esOffline => modo == ModoSesion.offline;

  SesionUsuario conTokens(TokensSesion nuevos) =>
      SesionUsuario(usuario: usuario, modo: modo, tokens: nuevos);
}

/// Sin conexión y el usuario nunca inició sesión online en este equipo.
class UsuarioNoDisponibleOfflineException implements Exception {
  @override
  String toString() =>
      'Sin conexión con el servidor. Este usuario nunca ha iniciado sesión '
      'en este equipo, así que no puede entrar sin conexión.';
}

/// Sin conexión y el usuario es administrador.
class AdminRequiereConexionException implements Exception {
  @override
  String toString() =>
      'Sin conexión con el servidor. Para entrar como administrador se '
      'requiere conexión.';
}

/// Sin conexión y la contraseña no coincide con la guardada localmente.
class CredencialesOfflineInvalidasException implements Exception {
  @override
  String toString() =>
      'Sin conexión con el servidor y la contraseña no coincide con la del '
      'último inicio de sesión en este equipo.';
}

/// Online: el backend aceptó las credenciales, pero el equipo todavía no
/// está vinculado a una sucursal y el usuario no es administrador.
/// Offline: el equipo no está vinculado.
class EquipoSinVincularException implements Exception {
  EquipoSinVincularException({this.sinConexion = false});

  /// `true` si se llegó aquí por el fallback offline: el problema real
  /// puede ser la conexión y no el usuario.
  final bool sinConexion;

  @override
  String toString() => sinConexion
      ? 'No se pudo conectar con el servidor y este equipo todavía no está '
            'configurado. Revisa la conexión (y SUPABASE_URL) e inicia sesión '
            'como administrador para vincularlo a su sucursal.'
      : 'Este equipo todavía no está configurado. Un administrador debe '
            'iniciar sesión primero (con conexión) para vincularlo a su '
            'sucursal.';
}

/// El usuario pertenece a otra sucursal distinta a la de este equipo.
class SucursalDistintaException implements Exception {
  @override
  String toString() =>
      'Este usuario pertenece a otra sucursal y no puede iniciar sesión en '
      'este equipo.';
}

/// Sin conexión y la credencial local superó [AuthService.vigenciaOffline].
class CredencialOfflineVencidaException implements Exception {
  @override
  String toString() =>
      'Sin conexión con el servidor. Han pasado más de '
      '${AuthService.vigenciaOffline.inDays} días desde el último inicio de '
      'sesión con conexión; vuelve a entrar cuando haya internet.';
}

/// Reglas del login:
/// 1. Siempre se intenta primero contra el backend.
/// 2. Credenciales rechazadas por el backend → error, SIN fallback.
/// 3. El equipo pertenece a una sola sucursal: lo vincula el primer
///    admin que entra online, y después solo entran usuarios (admins
///    incluidos) de esa sucursal.
/// 4. Login online OK → se cachea usuario + credencial local.
/// 5. Backend inalcanzable → fallback offline, solo para no-admins de la
///    sucursal del equipo que entraron online en los últimos
///    [vigenciaOffline].
class AuthService {
  AuthService({
    required this.api,
    required this.repo,
    required this.dispositivo,
    this.backendConfigurado = true,
    DateTime Function()? ahora,
  }) : ahora = ahora ?? DateTime.now;

  static const vigenciaOffline = Duration(days: 30);

  final AuthApi api;
  final UsuarioAuthRepository repo;
  final DispositivoRepository dispositivo;

  /// Sin URL del backend se va directo al modo offline.
  final bool backendConfigurado;

  /// Reloj inyectable para probar la caducidad de la credencial.
  final DateTime Function() ahora;

  Future<SesionUsuario> iniciarSesion(
    String nombreUsuario,
    String password,
  ) async {
    final usuarioNormalizado = AuthApi.normalizarUsuario(nombreUsuario);
    try {
      return await iniciarSesionOnline(usuarioNormalizado, password);
    } on BackendNoDisponibleException {
      return _iniciarOffline(usuarioNormalizado, password);
    }
  }

  /// Solo la parte online de [iniciarSesion], sin fallback: lanza
  /// [BackendNoDisponibleException] si no hay servidor. La usa también
  /// el reintento que promueve una sesión offline a online.
  Future<SesionUsuario> iniciarSesionOnline(
    String nombreUsuario,
    String password,
  ) async {
    if (!backendConfigurado) throw BackendNoDisponibleException();
    final resultado = await api.login(
      AuthApi.normalizarUsuario(nombreUsuario),
      password,
    );

    final perfil = resultado.perfil;
    final config = await dispositivo.obtener();
    if (config == null && !perfil.esAdmin) {
      throw EquipoSinVincularException();
    }

    final usuario = await repo.upsertDesdeRemoto(perfil);
    if (config != null && config.sucursalId != perfil.sucursalId) {
      // Pudo haber cambiado de sucursal en el backend: su credencial
      // vieja tampoco debe servir para entrar aquí sin conexión.
      await repo.borrarCredencial(usuario.id);
      throw SucursalDistintaException();
    }

    if (config == null) {
      await dispositivo.vincular(
        sucursalId: perfil.sucursalId,
        usuarioId: usuario.id,
      );
      await _guardarNombreSucursal(resultado.tokens.accessToken);
    }

    await repo.guardarCredencial(usuario.id, password);
    return SesionUsuario(
      usuario: usuario,
      modo: ModoSesion.online,
      tokens: resultado.tokens,
    );
  }

  /// Solo cosmético: si `/perfil` falla, el equipo se queda con el id.
  Future<void> _guardarNombreSucursal(String accessToken) async {
    try {
      final nombre = await api.nombreSucursal(accessToken);
      if (nombre != null) await dispositivo.actualizarNombreSucursal(nombre);
    } on Exception {
      // Ignorado a propósito: nunca bloquea el login.
    }
  }

  Future<SesionUsuario> _iniciarOffline(
    String nombreUsuario,
    String password,
  ) async {
    final config = await dispositivo.obtener();
    if (config == null) throw EquipoSinVincularException(sinConexion: true);

    final usuario = await repo.buscarPorNombreUsuario(nombreUsuario);
    if (usuario == null) throw UsuarioNoDisponibleOfflineException();
    if (usuario.rol == RolUsuario.dueno.valorDb) {
      throw AdminRequiereConexionException();
    }
    if (usuario.sucursalId != config.sucursalId) {
      throw SucursalDistintaException();
    }

    final credencial = await repo.obtenerCredencial(usuario.id);
    if (credencial == null) throw UsuarioNoDisponibleOfflineException();
    final actualizada = DateTime.parse(credencial.actualizadoEn);
    if (ahora().difference(actualizada) > vigenciaOffline) {
      throw CredencialOfflineVencidaException();
    }

    if (!await repo.verificarCredencial(usuario.id, password)) {
      throw CredencialesOfflineInvalidasException();
    }
    return SesionUsuario(usuario: usuario, modo: ModoSesion.offline);
  }
}
