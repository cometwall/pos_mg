import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

const urlSupabaseFalsa = 'https://test.supabase.co';

/// Simula la función `usuarios` del backend y el endpoint de tokens de
/// Supabase Auth, sin red real.
class BackendFalso implements HttpClientAdapter {
  /// Status de `/login`. `null` simula que el servidor es inalcanzable
  /// (para TODAS las rutas).
  int? status = 200;
  Map<String, dynamic> perfil = {
    'id': 7,
    'nombre_usuario': 'ana',
    'es_admin': false,
    'id_sucursal': 1,
  };
  final peticiones = <RequestOptions>[];

  /// Vigencia (segundos) de los tokens que entregan login y refresh.
  int expiresIn = 3600;

  /// Respuesta de `GET /perfil`.
  int statusPerfil = 200;
  Map<String, dynamic>? sucursalPerfil;

  /// Respuesta de `POST /auth/v1/token?grant_type=refresh_token`.
  int statusRefresh = 200;
  int _renovaciones = 0;

  /// Access tokens que `/registro` acepta; cualquier otro → 401.
  final tokensValidos = <String>{'acc'};

  /// Respuesta de `POST /registro` cuando el token es válido.
  int statusRegistro = 201;
  String errorRegistro = 'El nombre de usuario ya existe.';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    peticiones.add(options);
    final codigo = status;
    if (codigo == null) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'Sin red',
      );
    }

    final ruta = options.uri.path;
    if (ruta.endsWith('/auth/v1/token')) {
      if (statusRefresh != 200) {
        return _json({'error': 'invalid_grant'}, statusRefresh);
      }
      _renovaciones++;
      final access = 'acc-$_renovaciones';
      tokensValidos.add(access);
      return _json({
        'access_token': access,
        'refresh_token': 'ref-$_renovaciones',
        'expires_in': expiresIn,
      }, 200);
    }
    if (ruta.endsWith('/perfil')) {
      return _json({
        'usuario': perfil,
        'sucursal': sucursalPerfil,
      }, statusPerfil);
    }
    if (ruta.endsWith('/registro')) {
      final token = (options.headers['Authorization'] as String?)
          ?.replaceFirst('Bearer ', '');
      if (!tokensValidos.contains(token)) {
        return _json({'error': 'Token inválido o expirado.'}, 401);
      }
      if (statusRegistro != 201) {
        return _json({'error': errorRegistro}, statusRegistro);
      }
      final data = options.data as Map<String, dynamic>;
      return _json({
        'mensaje': 'Usuario registrado correctamente.',
        'usuario': {
          'id': 100,
          'nombre_usuario': data['nombre_usuario'],
          'es_admin': false,
          'id_sucursal': data['id_sucursal'],
        },
      }, 201);
    }

    return _json(
      codigo == 200
          ? {
              'mensaje': 'Inicio de sesion exitoso.',
              'usuario': perfil,
              'access_token': 'acc',
              'refresh_token': 'ref',
              'token_type': 'bearer',
              'expires_in': expiresIn,
            }
          : {'error': 'x'},
      codigo,
    );
  }

  static ResponseBody _json(Object body, int status) {
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio dioFalso(BackendFalso backend) =>
    Dio(BaseOptions(baseUrl: '$urlSupabaseFalsa/functions/v1/usuarios'))
      ..httpClientAdapter = backend;
