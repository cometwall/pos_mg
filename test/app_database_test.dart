import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';

void main() {
  late AppDatabase db;
  late InventarioRepository inventario;
  late int usuarioId;
  late int productoId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    inventario = InventarioRepository(db);

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

  test('el esquema crea todas las tablas esperadas', () async {
    final tablas = db.allTables.map((t) => t.actualTableName).toSet();
    expect(
      tablas,
      containsAll([
        'terminal',
        'usuario',
        'caja_sesion',
        'producto',
        'movimiento_inventario',
        'inventario_saldo',
        'compra',
        'detalle_compra',
        'venta',
        'detalle_venta',
        'pago',
        'movimiento_caja',
        'cuenta_monetaria_mov',
        'cuenta_envase_mov',
        'cuenta_deposito_envase_mov',
        'devolucion',
      ]),
    );
  });

  test('reconciliarInventario no reporta nada cuando el saldo está sano', () async {
    await inventario.registrarAjuste(
      productoId: productoId,
      cantidad: 20,
      usuarioId: usuarioId,
    );
    await inventario.registrarAjuste(
      productoId: productoId,
      cantidad: -7,
      usuarioId: usuarioId,
    );

    expect(await db.reconciliarInventario(), isEmpty);
  });

  test('reconciliarInventario detecta un saldo corrompido y reconstruirInventarioSaldo lo repara', () async {
    await inventario.registrarAjuste(
      productoId: productoId,
      cantidad: 20,
      usuarioId: usuarioId,
    );

    // Simula una corrupción del saldo materializado usando el mismo
    // mecanismo administrativo documentado en el esquema (activar la
    // bandera saldo_guard para poder escribir directo).
    await db.customStatement('INSERT INTO saldo_guard (activo) VALUES (1)');
    await db.customStatement(
      'UPDATE inventario_saldo SET cantidad_actual = 999 WHERE producto_id = ?',
      [productoId],
    );
    await db.customStatement('DELETE FROM saldo_guard');

    expect(await inventario.consultarSaldo(productoId), 999);

    final discrepancias = await db.reconciliarInventario();
    expect(discrepancias, hasLength(1));
    expect(discrepancias.single.read<int>('saldo_materializado'), 999);
    expect(discrepancias.single.read<int>('saldo_calculado'), 20);

    await db.reconstruirInventarioSaldo();

    expect(await inventario.consultarSaldo(productoId), 20);
    expect(await db.reconciliarInventario(), isEmpty);
  });

  test('inventario_saldo sigue bloqueando escrituras directas sin la bandera', () async {
    // Necesita existir una fila para que el trigger BEFORE UPDATE
    // llegue a dispararse (sobre 0 filas afectadas no se ejecuta).
    await inventario.registrarAjuste(
      productoId: productoId,
      cantidad: 1,
      usuarioId: usuarioId,
    );

    await expectLater(
      db.customStatement(
        'UPDATE inventario_saldo SET cantidad_actual = 5 WHERE producto_id = ?',
        [productoId],
      ),
      throwsA(anything),
    );
  });
}
