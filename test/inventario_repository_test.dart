import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';

void main() {
  late AppDatabase db;
  late InventarioRepository repo;
  late int productoId;
  late int usuarioId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = InventarioRepository(db);

    usuarioId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'Ana', rol: 'CAJERO'));
    productoId = await db.into(db.producto).insert(
      ProductoCompanion.insert(
        nombre: 'Refresco',
        codigoInterno: 'P001',
        unidad: 'pieza',
        precioVentaCentavos: 1500,
      ),
    );
  });

  tearDown(() => db.close());

  test('producto sin movimientos tiene saldo 0', () async {
    expect(await repo.consultarSaldo(productoId), 0);
  });

  test('registrar ajuste actualiza el saldo materializado', () async {
    await repo.registrarAjuste(
      productoId: productoId,
      cantidad: 15,
      usuarioId: usuarioId,
    );
    expect(await repo.consultarSaldo(productoId), 15);

    await repo.registrarAjuste(
      productoId: productoId,
      cantidad: -5,
      usuarioId: usuarioId,
    );
    expect(await repo.consultarSaldo(productoId), 10);
  });

  test('un ajuste que deja saldo negativo se rechaza y no se registra', () async {
    await repo.registrarAjuste(
      productoId: productoId,
      cantidad: 5,
      usuarioId: usuarioId,
    );

    await expectLater(
      repo.registrarAjuste(productoId: productoId, cantidad: -10, usuarioId: usuarioId),
      throwsA(anything),
    );

    expect(await repo.consultarSaldo(productoId), 5);
    expect(await repo.listarMovimientos(productoId), hasLength(1));
  });

  test('listar movimientos muestra el historial más reciente primero', () async {
    await repo.registrarAjuste(productoId: productoId, cantidad: 10, usuarioId: usuarioId);
    await repo.registrarAjuste(productoId: productoId, cantidad: -3, usuarioId: usuarioId);

    final movimientos = await repo.listarMovimientos(productoId);
    expect(movimientos, hasLength(2));
    expect(movimientos.first.cantidad, -3);
    expect(movimientos.last.cantidad, 10);
    expect(movimientos.every((m) => m.tipo == 'AJUSTE'), isTrue);
  });
}
