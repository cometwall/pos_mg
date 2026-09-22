import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/cliente_repository.dart';

void main() {
  late AppDatabase db;
  late ClienteRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ClienteRepository(db);
  });

  tearDown(() => db.close());

  test('crear y listar activos', () async {
    await repo.crear(nombre: 'Juan Pérez', telefono: '555-1234');
    await repo.crear(nombre: 'María López');

    final activos = await repo.listarActivos();
    expect(activos, hasLength(2));
    expect(activos.map((c) => c.nombre), ['Juan Pérez', 'María López']);
  });

  test('buscarPorNombre coincide parcialmente y es case-sensitive por LIKE de sqlite', () async {
    await repo.crear(nombre: 'Juan Pérez');
    await repo.crear(nombre: 'María López');

    final resultado = await repo.buscarPorNombre('juan');
    expect(resultado, hasLength(1));
    expect(resultado.single.nombre, 'Juan Pérez');
  });

  test('buscarPorNombre con texto vacio devuelve todos los activos', () async {
    await repo.crear(nombre: 'Juan Pérez');
    await repo.crear(nombre: 'María López');

    expect(await repo.buscarPorNombre(''), hasLength(2));
  });

  test('buscarPorNombre sin coincidencias devuelve vacio', () async {
    await repo.crear(nombre: 'Juan Pérez');
    expect(await repo.buscarPorNombre('inexistente'), isEmpty);
  });
}
