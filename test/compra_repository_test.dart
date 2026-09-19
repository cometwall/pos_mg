import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/compra_repository.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';

void main() {
  late AppDatabase db;
  late CompraRepository compras;
  late InventarioRepository inventario;
  late int terminalId;
  late int usuarioId;
  late int proveedorId;
  late int productoAId;
  late int productoBId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    compras = CompraRepository(db);
    inventario = InventarioRepository(db);

    terminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 1', codigo: 'T1'));
    usuarioId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'Ana', rol: 'DUEÑO'));
    proveedorId = await db
        .into(db.proveedor)
        .insert(ProveedorCompanion.insert(nombre: 'Distribuidora XYZ'));
    productoAId = await db.into(db.producto).insert(
      ProductoCompanion.insert(
        nombre: 'Refresco',
        codigoInterno: 'P001',
        unidad: 'pieza',
        precioVentaCentavos: 1500,
      ),
    );
    productoBId = await db.into(db.producto).insert(
      ProductoCompanion.insert(
        nombre: 'Agua',
        codigoInterno: 'P002',
        unidad: 'pieza',
        precioVentaCentavos: 1000,
      ),
    );
  });

  tearDown(() => db.close());

  test('registrar compra crea cabecera, detalle e inventario', () async {
    final compraId = await compras.registrarCompra(
      terminalId: terminalId,
      folio: 'C001',
      proveedorId: proveedorId,
      usuarioId: usuarioId,
      items: [
        ItemCompra(productoId: productoAId, cantidad: 10, costoUnitarioCentavos: 900),
        ItemCompra(productoId: productoBId, cantidad: 24, costoUnitarioCentavos: 600),
      ],
    );

    final compra = await (db.select(
      db.compra,
    )..where((c) => c.id.equals(compraId))).getSingle();
    expect(compra.totalCentavos, 10 * 900 + 24 * 600);
    expect(compra.estado, 'COMPLETADA');

    final detalle = await compras.listarDetalle(compraId);
    expect(detalle, hasLength(2));

    expect(await inventario.consultarSaldo(productoAId), 10);
    expect(await inventario.consultarSaldo(productoBId), 24);

    final movimientosA = await inventario.listarMovimientos(productoAId);
    expect(movimientosA.single.tipo, 'COMPRA');
    expect(movimientosA.single.referenciaId, compraId);
  });

  test('una compra vacía se rechaza antes de tocar la base', () async {
    expect(
      () => compras.registrarCompra(
        terminalId: terminalId,
        folio: 'C002',
        proveedorId: proveedorId,
        usuarioId: usuarioId,
        items: [],
      ),
      throwsArgumentError,
    );
  });

  test('un ítem inválido revierte toda la compra (sin filas parciales)', () async {
    const productoInexistente = 9999;

    await expectLater(
      compras.registrarCompra(
        terminalId: terminalId,
        folio: 'C003',
        proveedorId: proveedorId,
        usuarioId: usuarioId,
        items: [
          ItemCompra(productoId: productoAId, cantidad: 5, costoUnitarioCentavos: 900),
          ItemCompra(productoId: productoInexistente, cantidad: 1, costoUnitarioCentavos: 100),
        ],
      ),
      throwsA(anything),
    );

    final todasLasCompras = await db.select(db.compra).get();
    expect(todasLasCompras, isEmpty);
    expect(await inventario.consultarSaldo(productoAId), 0);
  });
}
