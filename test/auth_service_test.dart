import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/dispositivo_repository.dart';
import 'package:pos_mg/database/repositories/usuario_auth_repository.dart';
import 'package:pos_mg/features/auth/data/auth_api.dart';
import 'package:pos_mg/features/auth/services/auth_service.dart';

import 'support/backend_falso.dart';

void main() {
  late AppDatabase db;
  late BackendFalso backend;
  late UsuarioAuthRepository repo;
  late DispositivoRepository dispositivo;
  late AuthService auth;
  late DateTime ahora;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    backend = BackendFalso();
    final dio = dioFalso(backend);
    // Pocas iteraciones: el costo de PBKDF2 no es lo que se prueba aquí.
    repo = UsuarioAuthRepository(db, iteraciones: 1000);
    dispositivo = DispositivoRepository(db);
    ahora = DateTime.now();
    auth = AuthService(
      api: AuthApi(dio),
      repo: repo,
      dispositivo: dispositivo,
      ahora: () => ahora,
    );

    // La mayoría de los casos parten de un equipo ya vinculado a la
    // sucursal 1 (la del perfil por defecto del backend falso).
    final adminId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'admin', rol: 'DUEÑO'));
    await dispositivo.vincular(sucursalId: 1, usuarioId: adminId);
  });

  tearDown(() => db.close());

  test('login online crea el usuario local y guarda credencial', () async {
    final sesion = await auth.iniciarSesion('  Ana ', 'secreto123');

    expect(sesion.modo, ModoSesion.online);
    expect(sesion.accessToken, 'acc');
    expect(sesion.esAdmin, isFalse);
    expect(sesion.usuario.remotoId, 7);
    expect(sesion.usuario.nombreUsuario, 'ana');
    expect(sesion.usuario.sucursalId, 1);
    expect(sesion.usuario.rol, 'CAJERO');
    expect(backend.peticiones.single.uri.path, endsWith('/usuarios/login'));
    expect(backend.peticiones.single.data, {
      'nombre_usuario': 'ana',
      'password': 'secreto123',
    });
    expect(await repo.verificarCredencial(sesion.usuario.id, 'secreto123'), isTrue);
    expect(await repo.verificarCredencial(sesion.usuario.id, 'otra'), isFalse);
  });

  test('un segundo login online actualiza en lugar de duplicar', () async {
    final primera = await auth.iniciarSesion('ana', 'secreto123');
    backend.perfil = {...backend.perfil, 'es_admin': true};
    final segunda = await auth.iniciarSesion('ana', 'nueva-clave');

    expect(segunda.usuario.id, primera.usuario.id);
    expect(segunda.esAdmin, isTrue);
    expect(await db.select(db.usuario).get(), hasLength(2));
    expect(await repo.verificarCredencial(segunda.usuario.id, 'nueva-clave'), isTrue);
    expect(await repo.verificarCredencial(segunda.usuario.id, 'secreto123'), isFalse);
  });

  test('cuenta recreada en el backend invalida la credencial vieja', () async {
    await auth.iniciarSesion('ana', 'secreto123');
    backend.perfil = {...backend.perfil, 'id': 99};
    final nueva = await auth.iniciarSesion('ana', 'otra-clave');

    expect(nueva.usuario.remotoId, 99);
    final vieja = await (db.select(db.usuario)
          ..where((u) => u.remotoId.equals(7)))
        .getSingle();
    expect(vieja.nombreUsuario, isNull);
    expect(await repo.verificarCredencial(vieja.id, 'secreto123'), isFalse);
  });

  test('401 no cae a offline aunque exista credencial local', () async {
    await auth.iniciarSesion('ana', 'secreto123');
    backend.status = 401;

    expect(
      () => auth.iniciarSesion('ana', 'secreto123'),
      throwsA(isA<CredencialesInvalidasException>()),
    );
  });

  test('403 se reporta como perfil no encontrado', () async {
    backend.status = 403;
    expect(
      () => auth.iniciarSesion('ana', 'secreto123'),
      throwsA(isA<PerfilNoEncontradoException>()),
    );
  });

  group('sin conexión', () {
    test('usuario común cacheado entra en modo offline', () async {
      await auth.iniciarSesion('ana', 'secreto123');
      backend.status = null;

      final sesion = await auth.iniciarSesion('ANA', 'secreto123');
      expect(sesion.modo, ModoSesion.offline);
      expect(sesion.accessToken, isNull);
      expect(sesion.usuario.nombreUsuario, 'ana');
    });

    test('un 5xx también habilita el modo offline', () async {
      await auth.iniciarSesion('ana', 'secreto123');
      backend.status = 503;

      final sesion = await auth.iniciarSesion('ana', 'secreto123');
      expect(sesion.modo, ModoSesion.offline);
    });

    test('contraseña incorrecta se rechaza', () async {
      await auth.iniciarSesion('ana', 'secreto123');
      backend.status = null;

      expect(
        () => auth.iniciarSesion('ana', 'equivocada'),
        throwsA(isA<CredencialesOfflineInvalidasException>()),
      );
    });

    test('administrador requiere conexión', () async {
      backend.perfil = {...backend.perfil, 'es_admin': true};
      await auth.iniciarSesion('ana', 'secreto123');
      backend.status = null;

      expect(
        () => auth.iniciarSesion('ana', 'secreto123'),
        throwsA(isA<AdminRequiereConexionException>()),
      );
    });

    test('usuario que nunca inició sesión online se rechaza', () async {
      backend.status = null;
      expect(
        () => auth.iniciarSesion('ana', 'secreto123'),
        throwsA(isA<UsuarioNoDisponibleOfflineException>()),
      );
    });

    test('backend sin configurar va directo a offline', () async {
      await auth.iniciarSesion('ana', 'secreto123');
      final peticionesPrevias = backend.peticiones.length;
      final sinBackend = AuthService(
        api: auth.api,
        repo: repo,
        dispositivo: dispositivo,
        backendConfigurado: false,
      );

      final sesion = await sinBackend.iniciarSesion('ana', 'secreto123');
      expect(sesion.modo, ModoSesion.offline);
      expect(backend.peticiones, hasLength(peticionesPrevias));
    });
  });

  group('sucursal del equipo', () {
    test('equipo sin vincular: el primer admin lo vincula a su sucursal', () async {
      await dispositivo.desvincular();
      backend.perfil = {...backend.perfil, 'es_admin': true, 'id_sucursal': 3};

      final sesion = await auth.iniciarSesion('ana', 'secreto123');
      final config = await dispositivo.obtener();
      expect(config!.sucursalId, 3);
      expect(config.vinculadoPorUsuarioId, sesion.usuario.id);
    });

    test('al vincular guarda el nombre de la sucursal si /perfil responde', () async {
      await dispositivo.desvincular();
      backend.perfil = {...backend.perfil, 'es_admin': true};
      backend.sucursalPerfil = {'id': 1, 'nombre': 'Centro'};

      await auth.iniciarSesion('ana', 'secreto123');
      expect((await dispositivo.obtener())!.sucursalNombre, 'Centro');
      expect(backend.peticiones.last.headers['Authorization'], 'Bearer acc');
    });

    test('si /perfil falla igual se vincula, sin nombre', () async {
      await dispositivo.desvincular();
      backend.perfil = {...backend.perfil, 'es_admin': true};
      backend.statusPerfil = 500;

      await auth.iniciarSesion('ana', 'secreto123');
      final config = await dispositivo.obtener();
      expect(config!.sucursalId, 1);
      expect(config.sucursalNombre, isNull);
    });

    test('equipo sin vincular: un usuario común es rechazado', () async {
      await dispositivo.desvincular();

      await expectLater(
        auth.iniciarSesion('ana', 'secreto123'),
        throwsA(isA<EquipoSinVincularException>()),
      );
      expect(await dispositivo.obtener(), isNull);
      expect(await db.select(db.credencialOffline).get(), isEmpty);
    });

    test('usuario común de otra sucursal es rechazado y pierde su credencial', () async {
      final previo = await auth.iniciarSesion('ana', 'secreto123');
      backend.perfil = {...backend.perfil, 'id_sucursal': 2};

      await expectLater(
        auth.iniciarSesion('ana', 'secreto123'),
        throwsA(isA<SucursalDistintaException>()),
      );
      expect(await repo.obtenerCredencial(previo.usuario.id), isNull);

      // Tampoco entra sin conexión.
      backend.status = null;
      await expectLater(
        auth.iniciarSesion('ana', 'secreto123'),
        throwsA(isA<SucursalDistintaException>()),
      );
    });

    test('admin de otra sucursal también es rechazado', () async {
      backend.perfil = {...backend.perfil, 'es_admin': true, 'id_sucursal': 2};
      await expectLater(
        auth.iniciarSesion('ana', 'secreto123'),
        throwsA(isA<SucursalDistintaException>()),
      );
      expect((await dispositivo.obtener())!.sucursalId, 1);
    });

    test('offline con equipo sin vincular se rechaza', () async {
      await auth.iniciarSesion('ana', 'secreto123');
      await dispositivo.desvincular();
      backend.status = null;

      await expectLater(
        auth.iniciarSesion('ana', 'secreto123'),
        throwsA(isA<EquipoSinVincularException>()),
      );
    });
  });

  group('caducidad offline', () {
    test('a los 29 días todavía entra', () async {
      await auth.iniciarSesion('ana', 'secreto123');
      backend.status = null;
      ahora = ahora.add(const Duration(days: 29));

      final sesion = await auth.iniciarSesion('ana', 'secreto123');
      expect(sesion.modo, ModoSesion.offline);
    });

    test('a los 31 días se rechaza hasta volver a entrar online', () async {
      await auth.iniciarSesion('ana', 'secreto123');
      backend.status = null;
      ahora = ahora.add(const Duration(days: 31));

      await expectLater(
        auth.iniciarSesion('ana', 'secreto123'),
        throwsA(isA<CredencialOfflineVencidaException>()),
      );

      // Un login online renueva la credencial.
      backend.status = 200;
      ahora = DateTime.now();
      await auth.iniciarSesion('ana', 'secreto123');
      backend.status = null;
      ahora = ahora.add(const Duration(days: 1));
      final sesion = await auth.iniciarSesion('ana', 'secreto123');
      expect(sesion.modo, ModoSesion.offline);
    });
  });
}
