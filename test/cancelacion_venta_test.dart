import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/caja_repository.dart';
import 'package:pos_mg/database/repositories/devolucion_repository.dart';
import 'package:pos_mg/database/repositories/envase_repository.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';
import 'package:pos_mg/database/repositories/pago_repository.dart';
import 'package:pos_mg/database/repositories/venta_repository.dart';

void main() {
  late AppDatabase db;
  late VentaRepository ventas;
  late DevolucionRepository devoluciones;
  late InventarioRepository inventario;
  late CajaRepository caja;
  late EnvaseRepository envases;
  late int terminalId;
  late int usuarioId;
  late int clienteId;
  late int productoId;
  late int tipoEnvaseId;
  late int sesionId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ventas = VentaRepository(db);
    devoluciones = DevolucionRepository(db);
    inventario = InventarioRepository(db);
    caja = CajaRepository(db);
    envases = EnvaseRepository(db);

    terminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 1', codigo: 'T1'));
    usuarioId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'Ana', rol: 'CAJERO'));
    clienteId = await db
        .into(db.cliente)
        .insert(ClienteCompanion.insert(nombre: 'Juan'));
    productoId = await db.into(db.producto).insert(
      ProductoCompanion.insert(
        nombre: 'Refresco',
        codigoInterno: 'P001',
        unidad: 'pieza',
        precioVentaCentavos: 1500,
      ),
    );
    tipoEnvaseId = await db
        .into(db.tipoEnvase)
        .insert(TipoEnvaseCompanion.insert(nombre: 'Botellón 20L'));
    await inventario.registrarAjuste(
      productoId: productoId,
      cantidad: 20,
      usuarioId: usuarioId,
    );
    await envases.registrarCompraAProveedor(
      tipoEnvaseId: tipoEnvaseId,
      cantidad: 10,
      usuarioId: usuarioId,
    );
    sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 20000,
    );
  });

  tearDown(() => db.close());

  test('cancelar venta sin devoluciones revierte el 100% del inventario', () async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V001',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 5,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: const [Cobro(metodo: MetodoPago.efectivo, montoCentavos: 7500)],
      cajaSesionId: sesionId,
    );
    expect(await inventario.consultarSaldo(productoId), 15);

    await ventas.cancelarVenta(
      ventaId: ventaId,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    expect(await inventario.consultarSaldo(productoId), 20);
    expect(await db.reconciliarInventario(), isEmpty);

    final venta = await (db.select(
      db.venta,
    )..where((v) => v.id.equals(ventaId))).getSingle();
    expect(venta.estado, 'CANCELADA');

    final movimientosCaja = await caja.listarMovimientos(sesionId);
    expect(movimientosCaja.map((m) => m.montoCentavos), containsAll([7500, -7500]));
  });

  test('cancelar venta con una devolucion previa solo revierte el remanente activo', () async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V002',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 5,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: const [Cobro(metodo: MetodoPago.efectivo, montoCentavos: 7500)],
      cajaSesionId: sesionId,
    );
    final detalle = await ventas.listarDetalle(ventaId);

    await devoluciones.registrarDevolucion(
      ventaId: ventaId,
      detalleVentaId: detalle.single.id,
      productoId: productoId,
      cantidad: 2,
      condicion: CondicionDevolucion.bueno,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );
    expect(await inventario.consultarSaldo(productoId), 17);

    await ventas.cancelarVenta(
      ventaId: ventaId,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    // 5 vendidas, 2 ya devueltas -> solo 3 activas se revierten al cancelar.
    expect(await inventario.consultarSaldo(productoId), 20);
    expect(await db.reconciliarInventario(), isEmpty);

    final movimientosCaja = await caja.listarMovimientos(sesionId);
    // venta (+7500), devolucion (-3000), cancelacion del remanente (-4500).
    expect(movimientosCaja.map((m) => m.montoCentavos), containsAll([7500, -3000, -4500]));
  });

  test('cancelar venta revierte deposito y prestamo de envase pendientes', () async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V003',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 1,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: const [Cobro(metodo: MetodoPago.efectivo, montoCentavos: 1500)],
      cajaSesionId: sesionId,
      clienteId: clienteId,
      operacionesEnvase: [
        OperacionEnvaseVenta(
          tipoEnvaseId: tipoEnvaseId,
          tipo: TipoOperacionEnvase.depositoCobrado,
          cantidad: 2,
          montoUnitarioCentavos: 5000,
        ),
        OperacionEnvaseVenta(
          tipoEnvaseId: tipoEnvaseId,
          tipo: TipoOperacionEnvase.prestado,
          cantidad: 1,
        ),
      ],
    );
    expect(await envases.saldoFisico(tipoEnvaseId), 7);

    await ventas.cancelarVenta(
      ventaId: ventaId,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    expect(await envases.saldoFisico(tipoEnvaseId), 10);

    final movimientosCaja = await caja.listarMovimientos(sesionId);
    // venta efectivo (+1500), deposito cobrado (+10000), reembolso venta
    // cancelada (-1500), devolucion de deposito al cancelar (-10000).
    expect(
      movimientosCaja.map((m) => m.montoCentavos),
      containsAll([1500, 10000, -1500, -10000]),
    );
  });

  test('cancelar venta con pago TARJETA se rechaza', () async {
    final ventaId = await ventas.registrarVentaConPago(
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
      cobros: const [Cobro(metodo: MetodoPago.tarjeta, montoCentavos: 1500)],
    );

    await expectLater(
      ventas.cancelarVenta(ventaId: ventaId, usuarioId: usuarioId),
      throwsA(isA<ReembolsoTarjetaNoSoportadoException>()),
    );
  });

  test('cancelar una venta ya cancelada se rechaza', () async {
    final ventaId = await ventas.registrarVentaConPago(
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
      cobros: const [Cobro(metodo: MetodoPago.efectivo, montoCentavos: 1500)],
      cajaSesionId: sesionId,
    );
    await ventas.cancelarVenta(
      ventaId: ventaId,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    await expectLater(
      ventas.cancelarVenta(ventaId: ventaId, usuarioId: usuarioId, cajaSesionId: sesionId),
      throwsA(isA<VentaNoCancelableException>()),
    );
  });

  test('cancelar una venta inexistente se rechaza', () async {
    await expectLater(
      ventas.cancelarVenta(ventaId: 9999, usuarioId: usuarioId),
      throwsA(isA<VentaNoEncontradaException>()),
    );
  });

  test('tras cancelar, un pago normal sobre esa venta se sigue rechazando', () async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V006',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 1,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: const [Cobro(metodo: MetodoPago.efectivo, montoCentavos: 1500)],
      cajaSesionId: sesionId,
    );
    await ventas.cancelarVenta(
      ventaId: ventaId,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    await expectLater(
      db.into(db.pago).insert(
        PagoCompanion.insert(ventaId: ventaId, metodo: 'EFECTIVO', montoCentavos: 100),
      ),
      throwsA(anything),
    );
  });
}
