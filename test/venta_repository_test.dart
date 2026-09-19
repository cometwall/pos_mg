import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';
import 'package:pos_mg/database/repositories/venta_repository.dart';

void main() {
  late AppDatabase db;
  late VentaRepository ventas;
  late InventarioRepository inventario;
  late int terminalId;
  late int usuarioId;
  late int productoId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ventas = VentaRepository(db);
    inventario = InventarioRepository(db);

    terminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 1', codigo: 'T1'));
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

    await inventario.registrarAjuste(
      productoId: productoId,
      cantidad: 10,
      usuarioId: usuarioId,
    );
  });

  tearDown(() => db.close());

  test('registrar venta descuenta inventario y calcula el total', () async {
    final ventaId = await ventas.registrarVenta(
      terminalId: terminalId,
      folio: 'V001',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 4,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
    );

    final venta = await (db.select(
      db.venta,
    )..where((v) => v.id.equals(ventaId))).getSingle();
    expect(venta.subtotalCentavos, 4 * 1500);
    expect(venta.totalCentavos, 4 * 1500);
    expect(venta.estado, 'COMPLETADA');

    expect(await inventario.consultarSaldo(productoId), 6);

    final movimientos = await inventario.listarMovimientos(productoId);
    expect(movimientos.first.tipo, 'VENTA');
    expect(movimientos.first.cantidad, -4);
    expect(movimientos.first.referenciaId, ventaId);
  });

  test('vender exactamente el stock disponible lo deja en 0', () async {
    await ventas.registrarVenta(
      terminalId: terminalId,
      folio: 'V002',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 10,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
    );

    expect(await inventario.consultarSaldo(productoId), 0);
  });

  test('vender más stock del disponible se rechaza sin tocar la base', () async {
    await expectLater(
      ventas.registrarVenta(
        terminalId: terminalId,
        folio: 'V003',
        usuarioId: usuarioId,
        items: [
          ItemVenta(
            productoId: productoId,
            cantidad: 11,
            precioUnitarioCentavos: 1500,
            costoUnitarioCentavos: 900,
          ),
        ],
      ),
      throwsA(isA<StockInsuficienteException>()),
    );

    expect(await inventario.consultarSaldo(productoId), 10);
    final todasLasVentas = await db.select(db.venta).get();
    expect(todasLasVentas, isEmpty);
  });

  test('una venta con varios ítems donde uno excede stock revierte todo', () async {
    final otroProductoId = await db.into(db.producto).insert(
      ProductoCompanion.insert(
        nombre: 'Agua',
        codigoInterno: 'P002',
        unidad: 'pieza',
        precioVentaCentavos: 1000,
      ),
    );

    await expectLater(
      ventas.registrarVenta(
        terminalId: terminalId,
        folio: 'V004',
        usuarioId: usuarioId,
        items: [
          ItemVenta(
            productoId: productoId,
            cantidad: 2,
            precioUnitarioCentavos: 1500,
            costoUnitarioCentavos: 900,
          ),
          ItemVenta(
            productoId: otroProductoId,
            cantidad: 1,
            precioUnitarioCentavos: 1000,
            costoUnitarioCentavos: 500,
          ),
        ],
      ),
      throwsA(isA<StockInsuficienteException>()),
    );

    expect(await inventario.consultarSaldo(productoId), 10);
    expect(await inventario.consultarSaldo(otroProductoId), 0);
  });
}
