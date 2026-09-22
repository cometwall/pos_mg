import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/caja_repository.dart';
import 'package:pos_mg/database/repositories/envase_repository.dart';

void main() {
  late AppDatabase db;
  late EnvaseRepository envases;
  late CajaRepository caja;
  late int usuarioId;
  late int clienteId;
  late int terminalId;
  late int tipoEnvaseId;
  late int ventaId;
  late int sesionId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    envases = EnvaseRepository(db);
    caja = CajaRepository(db);

    usuarioId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'Ana', rol: 'CAJERO'));
    clienteId = await db
        .into(db.cliente)
        .insert(ClienteCompanion.insert(nombre: 'Juan'));
    terminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 1', codigo: 'T1'));
    tipoEnvaseId = await db
        .into(db.tipoEnvase)
        .insert(TipoEnvaseCompanion.insert(nombre: 'Botellón 20L'));
    ventaId = await db.into(db.venta).insert(
      VentaCompanion.insert(
        terminalId: terminalId,
        folio: 'V001',
        usuarioId: usuarioId,
        clienteId: Value(clienteId),
        subtotalCentavos: Value(0),
        totalCentavos: Value(0),
      ),
    );
    sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 10000,
    );

    // Stock físico inicial de envase (como si ya se hubiera comprado a
    // un proveedor).
    await envases.registrarCompraAProveedor(
      tipoEnvaseId: tipoEnvaseId,
      cantidad: 50,
      usuarioId: usuarioId,
    );
  });

  tearDown(() => db.close());

  // Simula lo que hace VentaRepository._registrarOperacionesEnvase en una
  // venta real: la deuda/depósito Y la salida física del envase del
  // inventario de la tienda, juntas.
  Future<void> cobrarDeposito(int cantidad) async {
    await db.into(db.cuentaDepositoEnvaseMov).insert(
      CuentaDepositoEnvaseMovCompanion.insert(
        ventaId: ventaId,
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'COBRADO',
        cantidad: cantidad,
        montoUnitarioCentavos: 5000,
        usuarioId: usuarioId,
      ),
    );
    await db.into(db.envaseInventarioMov).insert(
      EnvaseInventarioMovCompanion.insert(
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'SALIDA_PRESTAMO',
        cantidad: -cantidad,
        usuarioId: usuarioId,
      ),
    );
  }

  Future<void> prestarEnvase(int cantidad) async {
    await db.into(db.cuentaEnvaseMov).insert(
      CuentaEnvaseMovCompanion.insert(
        clienteId: clienteId,
        ventaId: Value(ventaId),
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'PRESTAMO',
        cantidad: cantidad,
        usuarioId: usuarioId,
      ),
    );
    await db.into(db.envaseInventarioMov).insert(
      EnvaseInventarioMovCompanion.insert(
        tipoEnvaseId: tipoEnvaseId,
        tipo: 'SALIDA_PRESTAMO',
        cantidad: -cantidad,
        usuarioId: usuarioId,
      ),
    );
  }

  test('saldoFisico refleja compra a proveedor', () async {
    expect(await envases.saldoFisico(tipoEnvaseId), 50);
  });

  test('devolverDeposito completo actualiza cuenta, inventario y caja', () async {
    await cobrarDeposito(5);

    await envases.devolverDeposito(
      ventaOriginalId: ventaId,
      tipoEnvaseId: tipoEnvaseId,
      cantidad: 5,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    final pendiente = await db.customSelect(
      "SELECT COALESCE(SUM(CASE tipo WHEN 'COBRADO' THEN cantidad ELSE -cantidad END),0) AS p "
      'FROM cuenta_deposito_envase_mov WHERE venta_id = ? AND tipo_envase_id = ?',
      variables: [Variable.withInt(ventaId), Variable.withInt(tipoEnvaseId)],
    ).getSingle();
    expect(pendiente.read<int>('p'), 0);

    expect(await envases.saldoFisico(tipoEnvaseId), 50);

    final movimientos = await caja.listarMovimientos(sesionId);
    expect(movimientos.single.montoCentavos, -(5 * 5000));
  });

  test('devolver mas deposito del pendiente se rechaza sin tocar la base', () async {
    await cobrarDeposito(5);

    await expectLater(
      envases.devolverDeposito(
        ventaOriginalId: ventaId,
        tipoEnvaseId: tipoEnvaseId,
        cantidad: 6,
        usuarioId: usuarioId,
        cajaSesionId: sesionId,
      ),
      throwsA(isA<CantidadExcedePendienteEnvaseException>()),
    );

    expect(await caja.listarMovimientos(sesionId), isEmpty);
  });

  test('devolverEnvasePrestado no mueve dinero, si inventario', () async {
    await prestarEnvase(3);

    await envases.devolverEnvasePrestado(
      ventaOriginalId: ventaId,
      clienteId: clienteId,
      tipoEnvaseId: tipoEnvaseId,
      cantidad: 3,
      usuarioId: usuarioId,
    );

    expect(await envases.saldoFisico(tipoEnvaseId), 50);
    expect(await caja.listarMovimientos(sesionId), isEmpty);
  });

  test('pagarEnvasePrestado mueve caja pero no inventario', () async {
    await prestarEnvase(3);

    await envases.pagarEnvasePrestado(
      ventaOriginalId: ventaId,
      clienteId: clienteId,
      tipoEnvaseId: tipoEnvaseId,
      cantidad: 3,
      montoCentavos: 6000,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    // El envase no vuelve: sigue descontado desde que se prestó.
    expect(await envases.saldoFisico(tipoEnvaseId), 47);
    final movimientos = await caja.listarMovimientos(sesionId);
    expect(movimientos.single.montoCentavos, 6000);
  });

  test('liquidar envase contra una venta cancelada se rechaza', () async {
    await cobrarDeposito(2);
    await (db.update(db.venta)..where((v) => v.id.equals(ventaId))).write(
      const VentaCompanion(estado: Value('CANCELADA')),
    );

    await expectLater(
      envases.devolverDeposito(
        ventaOriginalId: ventaId,
        tipoEnvaseId: tipoEnvaseId,
        cantidad: 1,
        usuarioId: usuarioId,
        cajaSesionId: sesionId,
      ),
      throwsA(isA<VentaOriginalNoCompletadaException>()),
    );
  });

  test('comprarEnvaseACliente no toca ninguna cuenta de venta', () async {
    await envases.comprarEnvaseACliente(
      tipoEnvaseId: tipoEnvaseId,
      cantidad: 4,
      montoCentavos: 8000,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    expect(await envases.saldoFisico(tipoEnvaseId), 54);
    final movimientos = await caja.listarMovimientos(sesionId);
    expect(movimientos.single.montoCentavos, -8000);
  });
}
