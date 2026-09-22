import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/catalogo_repository.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  group('TerminalRepository', () {
    test('crear, listar activos y buscar por codigo', () async {
      final repo = TerminalRepository(db);
      await repo.crear(nombre: 'Caja 1', codigo: 'T1');

      final activos = await repo.listarActivos();
      expect(activos, hasLength(1));
      expect((await repo.buscarPorCodigo('T1'))?.nombre, 'Caja 1');
      expect(await repo.buscarPorCodigo('NOEXISTE'), isNull);
    });

    test('codigo duplicado se rechaza', () async {
      final repo = TerminalRepository(db);
      await repo.crear(nombre: 'Caja 1', codigo: 'T1');
      await expectLater(
        repo.crear(nombre: 'Caja 2', codigo: 'T1'),
        throwsA(anything),
      );
    });
  });

  group('UsuarioRepository', () {
    test('crear y listar activos', () async {
      final repo = UsuarioRepository(db);
      await repo.crear(nombre: 'Ana', rol: RolUsuario.cajero);
      await repo.crear(nombre: 'Beto', rol: RolUsuario.dueno);

      final activos = await repo.listarActivos();
      expect(activos, hasLength(2));
      expect(activos.map((u) => u.rol), containsAll(['CAJERO', 'DUEÑO']));
    });
  });

  group('CategoriaRepository', () {
    test('crear y listar todas ordenadas', () async {
      final repo = CategoriaRepository(db);
      await repo.crear(nombre: 'Bebidas');
      await repo.crear(nombre: 'Abarrotes');

      final todas = await repo.listarTodas();
      expect(todas.map((c) => c.nombre), ['Abarrotes', 'Bebidas']);
    });

    test('nombre duplicado se rechaza', () async {
      final repo = CategoriaRepository(db);
      await repo.crear(nombre: 'Bebidas');
      await expectLater(repo.crear(nombre: 'Bebidas'), throwsA(anything));
    });
  });

  group('TipoEnvaseRepository', () {
    test('crear con y sin valores opcionales, listar activos', () async {
      final repo = TipoEnvaseRepository(db);
      await repo.crear(nombre: 'Botellón 20L', valorDepositoCentavos: 5000);
      await repo.crear(nombre: 'Caja de refrescos');

      final activos = await repo.listarActivos();
      expect(activos, hasLength(2));
      final botellon = activos.firstWhere((t) => t.nombre == 'Botellón 20L');
      expect(botellon.valorDepositoCentavos, 5000);
      final caja = activos.firstWhere((t) => t.nombre == 'Caja de refrescos');
      expect(caja.valorDepositoCentavos, 0);
    });
  });

  group('ProveedorRepository', () {
    test('crear y listar todos ordenados', () async {
      final repo = ProveedorRepository(db);
      await repo.crear(nombre: 'Distribuidora Z');
      await repo.crear(nombre: 'Distribuidora A');

      final todos = await repo.listarTodos();
      expect(todos.map((p) => p.nombre), ['Distribuidora A', 'Distribuidora Z']);
    });
  });
}
