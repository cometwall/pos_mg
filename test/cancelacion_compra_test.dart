import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/compra_repository.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';
import 'package:pos_mg/database/repositories/venta_repository.dart';

void main() {
  late AppDatabase db;
  late CompraRepository compras;
  late VentaRepository ventas;
  late InventarioRepository inventario;
  late int terminalId;
  late int usuarioId;
  late int proveedorId;
  late int productoId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    compras = CompraRepository(db);
    ventas = VentaRepository(db);
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

  test('cancelar compra revierte el inventario completo', () async {
    final compraId = await compras.registrarCompra(
      terminalId: terminalId,
      folio: 'C001',
      proveedorId: proveedorId,
      usuarioId: usuarioId,
      items: [
        ItemCompra(productoId: productoId, cantidad: 20, costoUnitarioCentavos: 900),
      ],
    );
    expect(await inventario.consultarSaldo(productoId), 20);

    await compras.cancelarCompra(compraId: compraId, usuarioId: usuarioId);

    expect(await inventario.consultarSaldo(productoId), 0);
    expect(await db.reconciliarInventario(), isEmpty);

    final compra = await (db.select(
      db.compra,
    )..where((c) => c.id.equals(compraId))).getSingle();
    expect(compra.estado, 'CANCELADA');
  });

  test('cancelar compra cuyo stock ya se vendio parcialmente se rechaza sin dejar nada a medias', () async {
    final compraId = await compras.registrarCompra(
      terminalId: terminalId,
      folio: 'C002',
      proveedorId: proveedorId,
      usuarioId: usuarioId,
      items: [
        ItemCompra(productoId: productoId, cantidad: 10, costoUnitarioCentavos: 900),
      ],
    );

    await ventas.registrarVenta(
      terminalId: terminalId,
      folio: 'V001',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 8,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
    );
    expect(await inventario.consultarSaldo(productoId), 2);

    await expectLater(
      compras.cancelarCompra(compraId: compraId, usuarioId: usuarioId),
      throwsA(isA<StockInsuficienteParaCancelarException>()),
    );

    expect(await inventario.consultarSaldo(productoId), 2);
    final compra = await (db.select(
      db.compra,
    )..where((c) => c.id.equals(compraId))).getSingle();
    expect(compra.estado, 'COMPLETADA');
  });

  test('cancelar una compra ya cancelada se rechaza', () async {
    final compraId = await compras.registrarCompra(
      terminalId: terminalId,
      folio: 'C003',
      proveedorId: proveedorId,
      usuarioId: usuarioId,
      items: [
        ItemCompra(productoId: productoId, cantidad: 5, costoUnitarioCentavos: 900),
      ],
    );
    await compras.cancelarCompra(compraId: compraId, usuarioId: usuarioId);

    await expectLater(
      compras.cancelarCompra(compraId: compraId, usuarioId: usuarioId),
      throwsA(isA<CompraNoCancelableException>()),
    );
  });

  test('cancelar una compra inexistente se rechaza', () async {
    await expectLater(
      compras.cancelarCompra(compraId: 9999, usuarioId: usuarioId),
      throwsA(isA<CompraNoEncontradaException>()),
    );
  });
}
