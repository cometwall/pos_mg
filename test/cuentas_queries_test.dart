import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/cuentas_queries.dart';

void main() {
  late AppDatabase db;
  late CuentasQueries cuentas;
  late int usuarioId;
  late int clienteId;
  late int terminalId;
  late int productoId;
  late int tipoEnvaseId;
  late int ventaId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    cuentas = CuentasQueries(db);

    usuarioId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'Ana', rol: 'CAJERO'));
    clienteId = await db
        .into(db.cliente)
        .insert(ClienteCompanion.insert(nombre: 'Juan'));
    terminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 1', codigo: 'T1'));
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
    ventaId = await db.into(db.venta).insert(
      VentaCompanion.insert(
        terminalId: terminalId,
        folio: 'V001',
        usuarioId: usuarioId,
        clienteId: Value(clienteId),
        subtotalCentavos: Value(100000),
        totalCentavos: Value(100000),
      ),
    );
  });

  tearDown(() => db.close());

  test('deudaPendienteVenta es 0 sin movimientos', () async {
    expect(await cuentas.deudaPendienteVenta(ventaId), 0);
  });

  test('deudaPendienteVenta baja con abonos y con cancelacion', () async {
    await db.into(db.cuentaMonetariaMov).insert(
      CuentaMonetariaMovCompanion.insert(
        clienteId: clienteId,
        ventaId: Value(ventaId),
        tipo: 'CARGO',
        montoCentavos: 1000,
        usuarioId: usuarioId,
      ),
    );
    expect(await cuentas.deudaPendienteVenta(ventaId), 1000);

    await db.into(db.cuentaMonetariaMov).insert(
      CuentaMonetariaMovCompanion.insert(
        clienteId: clienteId,
        ventaId: Value(ventaId),
        tipo: 'ABONO',
        montoCentavos: 400,
        usuarioId: usuarioId,
      ),
    );
    expect(await cuentas.deudaPendienteVenta(ventaId), 600);
  });

  test('envasePendienteVenta baja con devolucion y pago', () async {
    expect(await cuentas.envasePendienteVenta(ventaId, tipoEnvaseId), 0);

    await db.into(db.cuentaEnvaseMov).insert(
      CuentaEnvaseMovCompanion.insert(
        clienteId: clienteId,
        ventaId: Value(ventaId),
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'PRESTAMO',
        cantidad: 5,
        usuarioId: usuarioId,
      ),
    );
    expect(await cuentas.envasePendienteVenta(ventaId, tipoEnvaseId), 5);

    await db.into(db.cuentaEnvaseMov).insert(
      CuentaEnvaseMovCompanion.insert(
        clienteId: clienteId,
        ventaId: Value(ventaId),
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'DEVOLUCION',
        cantidad: 2,
        usuarioId: usuarioId,
      ),
    );
    expect(await cuentas.envasePendienteVenta(ventaId, tipoEnvaseId), 3);
  });

  test('depositoPendienteVenta baja con lo devuelto', () async {
    await db.into(db.cuentaDepositoEnvaseMov).insert(
      CuentaDepositoEnvaseMovCompanion.insert(
        ventaId: ventaId,
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'COBRADO',
        cantidad: 4,
        montoUnitarioCentavos: 5000,
        usuarioId: usuarioId,
      ),
    );
    expect(await cuentas.depositoPendienteVenta(ventaId, tipoEnvaseId), 4);

    await db.into(db.cuentaDepositoEnvaseMov).insert(
      CuentaDepositoEnvaseMovCompanion.insert(
        ventaId: ventaId,
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'DEVUELTO',
        cantidad: 1,
        montoUnitarioCentavos: 5000,
        usuarioId: usuarioId,
      ),
    );
    expect(await cuentas.depositoPendienteVenta(ventaId, tipoEnvaseId), 3);
  });

  test('cantidadActivaDetalle baja con devoluciones parciales', () async {
    final detalleVentaId = await db.into(db.detalleVenta).insert(
      DetalleVentaCompanion.insert(
        ventaId: ventaId,
        productoId: productoId,
        cantidad: 5,
        precioUnitarioCentavos: 1500,
        costoUnitarioCentavos: 900,
        subtotalCentavos: 7500,
      ),
    );

    expect(await cuentas.cantidadActivaDetalle(detalleVentaId), 5);

    await db.into(db.devolucion).insert(
      DevolucionCompanion.insert(
        ventaId: ventaId,
        detalleVentaId: detalleVentaId,
        productoId: productoId,
        cantidad: 2,
        montoDevueltoCentavos: 3000,
        condicion: 'BUENO',
        usuarioId: usuarioId,
      ),
    );

    expect(await cuentas.cantidadActivaDetalle(detalleVentaId), 3);
  });

  test('saldoFisicoEnvase combina compra, salida y entrada', () async {
    expect(await cuentas.saldoFisicoEnvase(tipoEnvaseId), 0);

    await db.into(db.envaseInventarioMov).insert(
      EnvaseInventarioMovCompanion.insert(
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'COMPRA_PROVEEDOR',
        cantidad: 20,
        usuarioId: usuarioId,
      ),
    );
    await db.into(db.envaseInventarioMov).insert(
      EnvaseInventarioMovCompanion.insert(
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'SALIDA_PRESTAMO',
        cantidad: -5,
        usuarioId: usuarioId,
      ),
    );
    await db.into(db.envaseInventarioMov).insert(
      EnvaseInventarioMovCompanion.insert(
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'ENTRADA_DEVOLUCION',
        cantidad: 2,
        usuarioId: usuarioId,
      ),
    );

    expect(await cuentas.saldoFisicoEnvase(tipoEnvaseId), 17);
  });

  test('tiposEnvaseConDepositoEnVenta y ConPrestamoEnVenta listan distinct', () async {
    expect(await cuentas.tiposEnvaseConDepositoEnVenta(ventaId), isEmpty);
    expect(await cuentas.tiposEnvaseConPrestamoEnVenta(ventaId), isEmpty);

    await db.into(db.cuentaDepositoEnvaseMov).insert(
      CuentaDepositoEnvaseMovCompanion.insert(
        ventaId: ventaId,
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'COBRADO',
        cantidad: 1,
        montoUnitarioCentavos: 5000,
        usuarioId: usuarioId,
      ),
    );
    await db.into(db.cuentaEnvaseMov).insert(
      CuentaEnvaseMovCompanion.insert(
        clienteId: clienteId,
        ventaId: Value(ventaId),
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'PRESTAMO',
        cantidad: 1,
        usuarioId: usuarioId,
      ),
    );

    expect(await cuentas.tiposEnvaseConDepositoEnVenta(ventaId), [tipoEnvaseId]);
    expect(await cuentas.tiposEnvaseConPrestamoEnVenta(ventaId), [tipoEnvaseId]);
  });
}
