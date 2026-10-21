import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/app/providers.dart';
import 'package:pos_mg/core/backend_config.dart';
import 'package:pos_mg/core/dio_provider.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/usuario_auth_repository.dart';
import 'package:pos_mg/features/auth/controllers/auth_controller.dart';
import 'package:pos_mg/features/auth/data/auth_api.dart';
import 'package:pos_mg/features/auth/services/auth_service.dart';

import 'support/backend_falso.dart';

void main() {
  late AppDatabase db;
  late BackendFalso backend;
  late ProviderContainer container;

  AuthController controller() => container.read(authControllerProvider.notifier);
  SesionUsuario? sesion() => container.read(authControllerProvider);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    backend = BackendFalso();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        backendConfigProvider.overrideWithValue(
          const BackendConfig(
            supabaseUrl: urlSupabaseFalsa,
            publishableKey: 'pk',
          ),
        ),
        dioProvider.overrideWithValue(dioFalso(backend)),
        usuarioAuthRepositoryProvider.overrideWithValue(
          UsuarioAuthRepository(db, iteraciones: 1000),
        ),
        // Los reintentos se disparan a mano en los tests.
        intervaloReconexionProvider.overrideWithValue(const Duration(hours: 1)),
      ],
    );
    final adminId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'admin', rol: 'DUEÑO'));
    await container
        .read(dispositivoRepositoryProvider)
        .vincular(sucursalId: 1, usuarioId: adminId);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  /// Deja a "ana" con credencial local y la hace entrar sin conexión.
  Future<void> entrarOffline() async {
    await controller().iniciarSesion('ana', 'secreto123');
    controller().cerrarSesion();
    backend.status = null;
    await controller().iniciarSesion('ana', 'secreto123');
    expect(sesion()!.esOffline, isTrue);
  }

  group('sesión offline al volver la conexión', () {
    test('se promueve a online con tokens', () async {
      await entrarOffline();
      backend.status = 200;

      await controller().reintentarConexion();
      expect(sesion()!.modo, ModoSesion.online);
      expect(sesion()!.accessToken, 'acc');
    });

    test('si sigue sin servidor, sigue offline', () async {
      await entrarOffline();

      await controller().reintentarConexion();
      expect(sesion()!.esOffline, isTrue);
    });

    test('si el backend ya no la acepta, se cierra con motivo', () async {
      await entrarOffline();
      backend.status = 401;

      await controller().reintentarConexion();
      expect(sesion(), isNull);
      expect(controller().motivoCierre, contains('incorrectos'));
    });

    test('si lo movieron de sucursal, se cierra', () async {
      await entrarOffline();
      backend.status = 200;
      backend.perfil = {...backend.perfil, 'id_sucursal': 2};

      await controller().reintentarConexion();
      expect(sesion(), isNull);
      expect(controller().motivoCierre, contains('otra sucursal'));
    });
  });

  group('tokens', () {
    test('se renueva el access token cuando está por expirar', () async {
      backend.expiresIn = 30; // menos que el margen de renovación
      await controller().iniciarSesion('ana', 'secreto123');

      expect(await controller().tokenVigente(), 'acc-1');
      expect(sesion()!.refreshToken, 'ref-1');
      final refresh = backend.peticiones.last;
      expect(refresh.uri.toString(), startsWith('$urlSupabaseFalsa/auth/v1/token'));
      expect(refresh.uri.queryParameters['grant_type'], 'refresh_token');
      expect(refresh.data, {'refresh_token': 'ref'});
      expect(refresh.headers['apikey'], 'pk');
    });

    test('un token vigente no se renueva', () async {
      await controller().iniciarSesion('ana', 'secreto123');
      final peticiones = backend.peticiones.length;

      expect(await controller().tokenVigente(), 'acc');
      expect(backend.peticiones, hasLength(peticiones));
    });

    test('si el refresh es rechazado se cierra la sesión', () async {
      backend.expiresIn = 30;
      await controller().iniciarSesion('ana', 'secreto123');
      backend.statusRefresh = 400;

      await expectLater(
        controller().tokenVigente(),
        throwsA(isA<SesionExpiradaException>()),
      );
      expect(sesion(), isNull);
      expect(controller().motivoCierre, contains('expiró'));
    });
  });

  group('registro de usuarios', () {
    Future<void> entrarComoAdmin() async {
      backend.perfil = {...backend.perfil, 'es_admin': true};
      await controller().iniciarSesion('ana', 'secreto123');
    }

    test('registra en la sucursal del equipo y lo guarda localmente', () async {
      await entrarComoAdmin();

      final usuario = await controller().registrarUsuario(
        nombreUsuario: ' Luis ',
        password: 'clave-segura',
      );
      expect(usuario.remotoId, 100);
      expect(usuario.nombreUsuario, 'luis');
      expect(usuario.sucursalId, 1);
      expect(usuario.rol, 'CAJERO');

      final registro = backend.peticiones.last;
      expect(registro.headers['Authorization'], 'Bearer acc');
      expect(registro.data, {
        'nombre_usuario': 'luis',
        'password': 'clave-segura',
        'id_sucursal': 1,
      });
    });

    test('ante un 401 renueva el token y reintenta una vez', () async {
      await entrarComoAdmin();
      backend.tokensValidos.remove('acc');

      final usuario = await controller().registrarUsuario(
        nombreUsuario: 'luis',
        password: 'clave-segura',
      );
      expect(usuario.remotoId, 100);
      expect(backend.peticiones.last.headers['Authorization'], 'Bearer acc-1');
      expect(sesion()!.accessToken, 'acc-1');
    });

    test('muestra el mensaje del backend cuando rechaza el alta', () async {
      await entrarComoAdmin();
      backend.statusRegistro = 409;

      await expectLater(
        controller().registrarUsuario(nombreUsuario: 'luis', password: 'clave-segura'),
        throwsA(
          isA<OperacionRechazadaException>().having(
            (e) => e.mensaje,
            'mensaje',
            'El nombre de usuario ya existe.',
          ),
        ),
      );
    });

    test('un usuario común no puede registrar', () async {
      await controller().iniciarSesion('ana', 'secreto123');
      await expectLater(
        controller().registrarUsuario(nombreUsuario: 'luis', password: 'clave-segura'),
        throwsStateError,
      );
    });
  });
}
