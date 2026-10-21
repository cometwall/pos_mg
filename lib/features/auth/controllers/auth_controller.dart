import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/dio_provider.dart';
import '../../../database/app_database.dart';
import '../data/auth_api.dart';
import '../services/auth_service.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  final config = ref.watch(backendConfigProvider);
  return AuthApi(
    ref.watch(dioProvider),
    supabaseUrl: config.supabaseUrl,
    publishableKey: config.publishableKey,
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    api: ref.watch(authApiProvider),
    repo: ref.watch(usuarioAuthRepositoryProvider),
    dispositivo: ref.watch(dispositivoRepositoryProvider),
    backendConfigurado: ref.watch(backendConfigProvider).configurado,
  );
});

/// Cada cuánto una sesión offline reintenta validarse contra el backend.
/// Es un provider para que los tests lo acorten.
final intervaloReconexionProvider = Provider<Duration>(
  (ref) => const Duration(minutes: 1),
);

/// Sesión activa, o `null` si nadie ha iniciado sesión. No se persiste:
/// el POS pide login en cada arranque.
final authControllerProvider = NotifierProvider<AuthController, SesionUsuario?>(
  AuthController.new,
);

class AuthController extends Notifier<SesionUsuario?> {
  /// Último nombre de usuario que inició sesión durante esta ejecución,
  /// para precargarlo en el login tras cerrar sesión.
  String? ultimoUsuario;

  /// Por qué se cerró la sesión sin que el usuario lo pidiera (p. ej. el
  /// backend la revocó al volver la conexión). El login lo muestra una vez.
  String? motivoCierre;

  /// Contraseña de una sesión OFFLINE, solo en memoria, para revalidarla
  /// en cuanto vuelva la conexión sin pedírsela de nuevo al cajero. Se
  /// borra al promover la sesión a online o al cerrarla.
  String? _passwordPendiente;
  Timer? _reconexion;
  bool _reintentando = false;

  /// Margen para renovar el access token antes de que expire.
  static const _margenRenovacion = Duration(minutes: 1);

  @override
  SesionUsuario? build() {
    ref.onDispose(_detenerReconexion);
    return null;
  }

  /// Lanza las excepciones de [AuthService]/[AuthApi] tal cual: la
  /// pantalla de login las traduce a mensajes.
  Future<SesionUsuario> iniciarSesion(String usuario, String password) async {
    final sesion = await ref
        .read(authServiceProvider)
        .iniciarSesion(usuario, password);
    ultimoUsuario = sesion.usuario.nombreUsuario;
    motivoCierre = null;
    state = sesion;
    if (sesion.esOffline) {
      _passwordPendiente = password;
      _reconexion = Timer.periodic(
        ref.read(intervaloReconexionProvider),
        (_) => reintentarConexion(),
      );
    }
    return sesion;
  }

  void cerrarSesion({String? motivo}) {
    _detenerReconexion();
    motivoCierre = motivo;
    state = null;
  }

  /// Intenta convertir la sesión offline en online. Si el backend sigue
  /// sin responder no pasa nada; si ahora RECHAZA al usuario (cambió la
  /// contraseña, lo movieron de sucursal, perdió el perfil) se cierra la
  /// sesión: el modo offline no puede seguir dándole acceso.
  Future<void> reintentarConexion() async {
    final sesion = state;
    final password = _passwordPendiente;
    if (_reintentando || sesion == null || !sesion.esOffline) return;
    if (password == null) return;
    _reintentando = true;
    try {
      final online = await ref
          .read(authServiceProvider)
          .iniciarSesionOnline(sesion.usuario.nombreUsuario!, password);
      // El usuario pudo cerrar sesión mientras se esperaba la respuesta.
      if (!identical(state, sesion)) return;
      _detenerReconexion();
      state = online;
    } on BackendNoDisponibleException {
      // Sigue sin conexión: se reintenta en el próximo ciclo.
    } on Exception catch (e) {
      if (identical(state, sesion)) cerrarSesion(motivo: e.toString());
    } finally {
      _reintentando = false;
    }
  }

  /// Access token válido de la sesión online, renovándolo si está por
  /// expirar. Si ya no se puede renovar, cierra la sesión.
  Future<String> tokenVigente({bool forzarRenovacion = false}) async {
    final sesion = state;
    final tokens = sesion?.tokens;
    if (sesion == null || tokens == null) {
      throw StateError('Se requiere una sesión iniciada con conexión');
    }
    final porExpirar = DateTime.now().add(_margenRenovacion).isAfter(
      tokens.expiraEn,
    );
    if (!forzarRenovacion && !porExpirar) return tokens.accessToken;

    try {
      final nuevos = await ref
          .read(authApiProvider)
          .refrescar(tokens.refreshToken);
      if (identical(state, sesion)) state = sesion.conTokens(nuevos);
      return nuevos.accessToken;
    } on SesionExpiradaException catch (e) {
      cerrarSesion(motivo: e.toString());
      rethrow;
    }
  }

  /// Ejecuta una llamada autenticada; si el backend responde 401 renueva
  /// el token una vez y reintenta.
  Future<T> conToken<T>(Future<T> Function(String token) llamada) async {
    try {
      return await llamada(await tokenVigente());
    } on SesionExpiradaException {
      // Si fue la renovación la que falló, la sesión ya se cerró.
      if (state == null) rethrow;
      return llamada(await tokenVigente(forzarRenovacion: true));
    }
  }

  /// Registra un usuario común en la sucursal de este equipo vía
  /// `/registro` y lo deja en la base local para que aparezca en la
  /// lista. Solo para un admin con sesión online.
  Future<UsuarioData> registrarUsuario({
    required String nombreUsuario,
    required String password,
  }) async {
    final sesion = state;
    if (sesion == null || !sesion.esAdmin || sesion.esOffline) {
      throw StateError('Solo un administrador con conexión puede registrar');
    }
    final config = await ref.read(dispositivoRepositoryProvider).obtener();
    if (config == null) throw EquipoSinVincularException();

    final perfil = await conToken(
      (token) => ref
          .read(authApiProvider)
          .registrar(
            accessToken: token,
            nombreUsuario: nombreUsuario,
            password: password,
            sucursalId: config.sucursalId,
          ),
    );
    return ref.read(usuarioAuthRepositoryProvider).upsertDesdeRemoto(perfil);
  }

  /// Quita la sucursal de este equipo para que el próximo admin que
  /// entre online lo vuelva a vincular. Solo un admin con sesión online.
  Future<void> desvincularEquipo() async {
    final sesion = state;
    if (sesion == null || !sesion.esAdmin || sesion.esOffline) {
      throw StateError('Solo un administrador con conexión puede desvincular');
    }
    await ref.read(dispositivoRepositoryProvider).desvincular();
    cerrarSesion();
  }

  void _detenerReconexion() {
    _reconexion?.cancel();
    _reconexion = null;
    _passwordPendiente = null;
  }
}
