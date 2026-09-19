import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/producto_repository.dart';

void main() {
  late AppDatabase db;
  late ProductoRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ProductoRepository(db);
  });

  tearDown(() => db.close());

  test('crear, listar y buscar producto', () async {
    await repo.crear(
      nombre: 'Refresco de cola',
      codigoInterno: 'P001',
      codigoBarras: '7501234567890',
      unidad: UnidadProducto.pieza,
      precioVentaCentavos: 1500,
    );
    await repo.crear(
      nombre: 'Jamón por kilo',
      codigoInterno: 'P002',
      unidad: UnidadProducto.peso,
      precioVentaCentavos: 12000,
    );

    final activos = await repo.listarActivos();
    expect(activos, hasLength(2));
    expect(activos.map((p) => p.nombre), containsAll(['Refresco de cola', 'Jamón por kilo']));

    final porNombre = await repo.buscar('refresco');
    expect(porNombre, hasLength(1));
    expect(porNombre.single.codigoInterno, 'P001');

    final porCodigoBarras = await repo.buscar('7501234567890');
    expect(porCodigoBarras.single.nombre, 'Refresco de cola');

    final sinCoincidencias = await repo.buscar('inexistente');
    expect(sinCoincidencias, isEmpty);
  });

  test('codigo_interno duplicado es rechazado por la base', () async {
    await repo.crear(
      nombre: 'Producto A',
      codigoInterno: 'DUP',
      unidad: UnidadProducto.pieza,
      precioVentaCentavos: 100,
    );

    expect(
      () => repo.crear(
        nombre: 'Producto B',
        codigoInterno: 'DUP',
        unidad: UnidadProducto.pieza,
        precioVentaCentavos: 200,
      ),
      throwsA(anything),
    );
  });
}
