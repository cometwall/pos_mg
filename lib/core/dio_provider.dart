import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backend_config.dart';

final backendConfigProvider = Provider<BackendConfig>(
  (ref) => BackendConfig.fromEnvironment(),
);

/// Cliente HTTP único hacia la función `Usuarios` del backend. En tests
/// se sobreescribe con un `Dio` que usa un adaptador falso.
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(backendConfigProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: config.funcionUsuariosUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
      contentType: Headers.jsonContentType,
      headers: {'apikey': config.publishableKey},
    ),
  );
  ref.onDispose(dio.close);
  return dio;
});
