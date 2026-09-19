import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/caja_repository.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';
import 'package:pos_mg/database/repositories/pago_repository.dart';
import 'package:pos_mg/database/repositories/venta_repository.dart';

void main() {
  late AppDatabase db;
  late VentaRepository ventas;
  late InventarioRepository inventario;
  late PagoRepository pagos;
  late CajaRepository caja;
  late int terminalId;
  late int usuarioId;
  late int productoId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ventas = VentaRepository(db);
    inventario = InventarioRepository(db);
    pagos = PagoRepository(db);
    caja = CajaRepository(db);

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

  test('venta pagada en efectivo mueve inventario, pago y caja juntos', () async {
    final sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 20000,
    );

    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V001',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 3,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: [const Cobro(metodo: MetodoPago.efectivo, montoCentavos: 4500)],
      cajaSesionId: sesionId,
    );

    expect(await inventario.consultarSaldo(productoId), 7);

    final listaPagos = await pagos.listarPagos(ventaId);
    expect(listaPagos, hasLength(1));
    expect(listaPagos.single.metodo, 'EFECTIVO');
    expect(listaPagos.single.montoCentavos, 4500);

    final movimientosCaja = await caja.listarMovimientos(sesionId);
    expect(movimientosCaja, hasLength(1));
    expect(movimientosCaja.single.tipo, 'VENTA_EFECTIVO');
    expect(movimientosCaja.single.referenciaId, ventaId);
    expect(await caja.efectivoEsperado(sesionId), 20000 + 4500);
  });

  test('venta pagada con tarjeta no genera movimiento de caja', () async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V002',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 2,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: [const Cobro(metodo: MetodoPago.tarjeta, montoCentavos: 3000, ivaCentavos: 400)],
    );

    final listaPagos = await pagos.listarPagos(ventaId);
    expect(listaPagos.single.metodo, 'TARJETA');
    expect(listaPagos.single.ivaCentavos, 400);
  });

  test('pago dividido: parte efectivo mueve caja, parte tarjeta no', () async {
    final sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 10000,
    );

    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V006',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 4,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: const [
        Cobro(metodo: MetodoPago.efectivo, montoCentavos: 3000),
        Cobro(metodo: MetodoPago.tarjeta, montoCentavos: 3000, ivaCentavos: 350),
      ],
      cajaSesionId: sesionId,
    );

    final listaPagos = await pagos.listarPagos(ventaId);
    expect(listaPagos, hasLength(2));
    expect(
      listaPagos.map((p) => p.metodo).toSet(),
      {'EFECTIVO', 'TARJETA'},
    );

    final movimientosCaja = await caja.listarMovimientos(sesionId);
    expect(movimientosCaja, hasLength(1));
    expect(movimientosCaja.single.montoCentavos, 3000);
    expect(await caja.efectivoEsperado(sesionId), 10000 + 3000);
  });

  test('un pago que no cubre el total se rechaza antes de tocar la base', () async {
    await expectLater(
      ventas.registrarVentaConPago(
        terminalId: terminalId,
        folio: 'V003',
        usuarioId: usuarioId,
        items: [
          ItemVenta(
            productoId: productoId,
            cantidad: 2,
            precioUnitarioCentavos: 1500,
            costoUnitarioCentavos: 900,
          ),
        ],
        cobros: [const Cobro(metodo: MetodoPago.efectivo, montoCentavos: 2000)],
        cajaSesionId: 1,
      ),
      throwsA(isA<PagoIncompletoException>()),
    );

    expect(await inventario.consultarSaldo(productoId), 10);
    expect(await db.select(db.venta).get(), isEmpty);
  });

  test('cobrar en efectivo sin sesión de caja se rechaza', () async {
    await expectLater(
      ventas.registrarVentaConPago(
        terminalId: terminalId,
        folio: 'V004',
        usuarioId: usuarioId,
        items: [
          ItemVenta(
            productoId: productoId,
            cantidad: 1,
            precioUnitarioCentavos: 1500,
            costoUnitarioCentavos: 900,
          ),
        ],
        cobros: [const Cobro(metodo: MetodoPago.efectivo, montoCentavos: 1500)],
      ),
      throwsArgumentError,
    );

    expect(await inventario.consultarSaldo(productoId), 10);
  });

  test('cobrar en efectivo con la caja de otro terminal se rechaza', () async {
    final otroTerminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 2', codigo: 'T2'));
    final sesionOtroTerminal = await caja.abrirSesion(
      terminalId: otroTerminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 5000,
    );

    await expectLater(
      ventas.registrarVentaConPago(
        terminalId: terminalId,
        folio: 'V005',
        usuarioId: usuarioId,
        items: [
          ItemVenta(
            productoId: productoId,
            cantidad: 1,
            precioUnitarioCentavos: 1500,
            costoUnitarioCentavos: 900,
          ),
        ],
        cobros: [const Cobro(metodo: MetodoPago.efectivo, montoCentavos: 1500)],
        cajaSesionId: sesionOtroTerminal,
      ),
      throwsA(anything),
    );

    expect(await inventario.consultarSaldo(productoId), 10);
    expect(await db.select(db.venta).get(), isEmpty);
  });
}
