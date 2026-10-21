import 'package:dio/dio.dart';

import '../../../database/repositories/usuario_auth_repository.dart';

/// Usuario o contraseña incorrectos (400/401). Nunca debe disparar el
/// login offline: la contraseña pudo haber cambiado en el servidor.
class CredencialesInvalidasException implements Exception {
  @override
  String toString() => 'Nombre de usuario o contraseña incorrectos.';
}

/// La cuenta existe en Auth pero no tiene perfil en `usuario` (403).
class PerfilNoEncontradoException implements Exception {
  @override
  String toString() => 'No se encontró el perfil del usuario.';
}

/// No se pudo hablar con el backend (sin red, timeout, 404 de la
/// función o error 5xx). Es el único caso que habilita el login offline.
class BackendNoDisponibleException implements Exception {
  BackendNoDisponibleException([this.causa]);

  final Object? causa;

  @override
  String toString() => 'No se pudo conectar con el servidor.';
}

/// El access token ya no es válido y no se pudo renovar: hay que volver
/// a iniciar sesión.
class SesionExpiradaException implements Exception {
  @override
  String toString() =>
      'La sesión con el servidor expiró. Vuelve a iniciar sesión.';
}

/// El backend rechazó una operación con un mensaje para el usuario
/// (validaciones de `/registro`, nombre repetido, falta de permisos).
class OperacionRechazadaException implements Exception {
  OperacionRechazadaException(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

class TokensSesion {
  const TokensSesion({
    required this.accessToken,
    required this.refreshToken,
    required this.expiraEn,
  });

  /// `expires_in` (segundos) convertido a instante absoluto.
  factory TokensSesion.fromJson(Map<String, dynamic> json) => TokensSesion(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
    expiraEn: DateTime.now().add(
      Duration(seconds: (json['expires_in'] as num?)?.toInt() ?? 3600),
    ),
  );

  final String accessToken;
  final String refreshToken;
  final DateTime expiraEn;
}

class LoginResultado {
  const LoginResultado({required this.perfil, required this.tokens});

  final PerfilRemoto perfil;
  final TokensSesion tokens;
}

class AuthApi {
  AuthApi(this._dio, {this.supabaseUrl, this.publishableKey});

  final Dio _dio;

  /// Necesarios solo para renovar tokens, que va directo a Supabase
  /// Auth (`/auth/v1/token`) porque la función no expone un refresh.
  final String? supabaseUrl;
  final String? publishableKey;

  /// Mismo criterio que el backend, para que el usuario cacheado
  /// localmente coincida con el `nombre_usuario` remoto.
  static String normalizarUsuario(String nombreUsuario) =>
      nombreUsuario.trim().toLowerCase();

  Future<LoginResultado> login(String nombreUsuario, String password) async {
    final Response<Map<String, dynamic>> respuesta;
    try {
      respuesta = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: {
          'nombre_usuario': normalizarUsuario(nombreUsuario),
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw _traducirLogin(e);
    }

    final body = respuesta.data;
    if (body == null || body['usuario'] is! Map<String, dynamic>) {
      throw BackendNoDisponibleException('Respuesta de login inválida');
    }
    return LoginResultado(
      perfil: PerfilRemoto.fromJson(body['usuario'] as Map<String, dynamic>),
      tokens: TokensSesion.fromJson(body),
    );
  }

  /// Canjea el refresh token por un par nuevo. Supabase rota el refresh
  /// token: el anterior deja de servir tras usarse.
  Future<TokensSesion> refrescar(String refreshToken) async {
    final url = supabaseUrl;
    if (url == null || url.isEmpty) throw BackendNoDisponibleException();
    try {
      final respuesta = await _dio.post<Map<String, dynamic>>(
        '$url/auth/v1/token',
        queryParameters: {'grant_type': 'refresh_token'},
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'apikey': publishableKey}),
      );
      return TokensSesion.fromJson(respuesta.data!);
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      if (status >= 400 && status < 500) throw SesionExpiradaException();
      throw BackendNoDisponibleException(e);
    }
  }

  /// Nombre de la sucursal del usuario según `GET /perfil`, o `null`
  /// si la respuesta no lo trae. Acepta `nombre` o `nombre_sucursal`.
  Future<String?> nombreSucursal(String accessToken) async {
    try {
      final respuesta = await _dio.get<Map<String, dynamic>>(
        '/perfil',
        options: _autorizado(accessToken),
      );
      final sucursal = respuesta.data?['sucursal'];
      if (sucursal is! Map<String, dynamic>) return null;
      final nombre = sucursal['nombre'] ?? sucursal['nombre_sucursal'];
      return nombre is String ? nombre : null;
    } on DioException catch (e) {
      throw _traducirLogin(e);
    }
  }

  /// `POST /registro`. Solo un admin (lo valida el backend con el token).
  /// El usuario se crea siempre como no-admin.
  Future<PerfilRemoto> registrar({
    required String accessToken,
    required String nombreUsuario,
    required String password,
    required int sucursalId,
  }) async {
    try {
      final respuesta = await _dio.post<Map<String, dynamic>>(
        '/registro',
        data: {
          'nombre_usuario': normalizarUsuario(nombreUsuario),
          'password': password,
          'id_sucursal': sucursalId,
        },
        options: _autorizado(accessToken),
      );
      return PerfilRemoto.fromJson(
        respuesta.data!['usuario'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      if (status == 401) throw SesionExpiradaException();
      if (status >= 400 && status < 500) {
        throw OperacionRechazadaException(
          _mensajeDe(e) ?? 'El servidor rechazó la operación.',
        );
      }
      throw BackendNoDisponibleException(e);
    }
  }

  static Options _autorizado(String accessToken) =>
      Options(headers: {'Authorization': 'Bearer $accessToken'});

  static String? _mensajeDe(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] is String) return data['error'] as String;
    return null;
  }

  static Exception _traducirLogin(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      final status = e.response?.statusCode ?? 0;
      if (status == 400 || status == 401) return CredencialesInvalidasException();
      if (status == 403) return PerfilNoEncontradoException();
    }
    return BackendNoDisponibleException(e);
  }
}
