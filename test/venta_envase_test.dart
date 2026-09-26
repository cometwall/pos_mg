import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/caja_repository.dart';
import 'package:pos_mg/database/repositories/envase_repository.dart';
import 'package:pos_mg/database/repositories/pago_repository.dart';
import 'package:pos_mg/database/repositories/venta_repository.dart';

void main() {
  late AppDatabase db;
  late VentaRepository ventas;
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
    await db.into(db.movimientoInventario).insert(
      MovimientoInventarioCompanion.insert(
        productoId: productoId,
        tipo: 'AJUSTE',
        cantidad: 20,
        referenciaTipo: const Value('AJUSTE_MANUAL'),
        usuarioId: usuarioId,
      ),
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

  test('venta con deposito cobrado mueve cuenta, inventario de envase y caja', () async {
    final ventaRealId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V002',
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
      ],
    );

    expect(await envases.saldoFisico(tipoEnvaseId), 8);

    final movimientosCaja = await caja.listarMovimientos(sesionId);
    expect(movimientosCaja, hasLength(2));
    expect(
      movimientosCaja.map((m) => m.montoCentavos).toSet(),
      {1500, 10000},
    );
    expect(movimientosCaja.any((m) => m.referenciaId == ventaRealId), isTrue);
  });

  test('venta con envase prestado sin cliente se rechaza antes de tocar la base', () async {
    await expectLater(
      ventas.registrarVentaConPago(
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
        operacionesEnvase: [
          OperacionEnvaseVenta(
            tipoEnvaseId: tipoEnvaseId,
            tipo: TipoOperacionEnvase.prestado,
            cantidad: 1,
          ),
        ],
      ),
      throwsA(isA<EnvaseSinClienteException>()),
    );

    expect(await db.select(db.venta).get(), isEmpty);
  });

  test('venta con deposito cobrado sin cliente se rechaza antes de tocar la base', () async {
    await expectLater(
      ventas.registrarVentaConPago(
        terminalId: terminalId,
        folio: 'V003B',
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
        operacionesEnvase: [
          OperacionEnvaseVenta(
            tipoEnvaseId: tipoEnvaseId,
            tipo: TipoOperacionEnvase.depositoCobrado,
            cantidad: 2,
            montoUnitarioCentavos: 5000,
          ),
        ],
      ),
      throwsA(isA<EnvaseSinClienteException>()),
    );

    expect(await db.select(db.venta).get(), isEmpty);
  });

  test('venta con envase prestado y cliente descuenta stock fisico', () async {
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
      cobros: const [Cobro(metodo: MetodoPago.efectivo, montoCentavos: 1500)],
      cajaSesionId: sesionId,
      clienteId: clienteId,
      operacionesEnvase: [
        OperacionEnvaseVenta(
          tipoEnvaseId: tipoEnvaseId,
          tipo: TipoOperacionEnvase.prestado,
          cantidad: 3,
        ),
      ],
    );

    expect(await envases.saldoFisico(tipoEnvaseId), 7);
    final movimientosCaja = await caja.listarMovimientos(sesionId);
    // Solo el cobro del producto entra a caja; el préstamo de envase no.
    expect(movimientosCaja, hasLength(1));
    expect(movimientosCaja.single.montoCentavos, 1500);
    expect(movimientosCaja.single.referenciaId, ventaId);
  });

  test('venta con envase entregado no mueve el stock fisico de envases', () async {
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
      operacionesEnvase: [
        OperacionEnvaseVenta(
          tipoEnvaseId: tipoEnvaseId,
          tipo: TipoOperacionEnvase.entregado,
          cantidad: 1,
        ),
      ],
    );

    // El stock de envases sigue en 10 (lo que compró el setUp): el
    // cliente trajo su propio envase vacío a cambio del lleno, así que
    // no hay salida física que registrar.
    expect(await envases.saldoFisico(tipoEnvaseId), 10);

    // Pero sí queda el registro de que ocurrió, para historial/reportes.
    final operaciones = await envases.listarOperaciones(ventaId);
    expect(operaciones, hasLength(1));
    expect(operaciones.single.tipo, 'ENTREGADO');
  });

  test('venta con envase entregado no requiere stock fisico disponible', () async {
    // A diferencia de depósito/préstamo, "entregado" no es una salida
    // física de la tienda (ver test anterior), así que puede pedirse
    // más de lo que hay en stock sin que se rechace.
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V007',
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
      operacionesEnvase: [
        OperacionEnvaseVenta(
          tipoEnvaseId: tipoEnvaseId,
          tipo: TipoOperacionEnvase.entregado,
          cantidad: 999,
        ),
      ],
    );

    expect(ventaId, isPositive);
    expect(await envases.saldoFisico(tipoEnvaseId), 10);
  });

  test('venta con envase sin stock fisico suficiente se rechaza', () async {
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
        cobros: const [Cobro(metodo: MetodoPago.efectivo, montoCentavos: 1500)],
        cajaSesionId: sesionId,
        clienteId: clienteId,
        operacionesEnvase: [
          OperacionEnvaseVenta(
            tipoEnvaseId: tipoEnvaseId,
            tipo: TipoOperacionEnvase.prestado,
            cantidad: 999,
          ),
        ],
      ),
      throwsA(isA<StockEnvaseInsuficienteException>()),
    );

    final ventasRegistradas = await db.select(db.venta).get();
    expect(ventasRegistradas, isEmpty);
  });
}
