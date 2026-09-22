import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/caja_repository.dart';

void main() {
  late AppDatabase db;
  late CajaRepository caja;
  late int terminalId;
  late int usuarioId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    caja = CajaRepository(db);

    terminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 1', codigo: 'T1'));
    usuarioId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'Ana', rol: 'CAJERO'));
  });

  tearDown(() => db.close());

  test('abrir sesion y calcular efectivo esperado sin movimientos', () async {
    final sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 50000,
    );

    expect(await caja.efectivoEsperado(sesionId), 50000);
    expect(await caja.listarMovimientos(sesionId), isEmpty);
  });

  test('los movimientos de caja modifican el efectivo esperado', () async {
    final sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 50000,
    );

    await db.into(db.movimientoCaja).insert(
      MovimientoCajaCompanion.insert(
        cajaSesionId: sesionId,
        tipo: 'ENTRADA',
        montoCentavos: 10000,
        usuarioId: usuarioId,
      ),
    );
    await db.into(db.movimientoCaja).insert(
      MovimientoCajaCompanion.insert(
        cajaSesionId: sesionId,
        tipo: 'RETIRO',
        montoCentavos: -3000,
        usuarioId: usuarioId,
      ),
    );

    expect(await caja.efectivoEsperado(sesionId), 50000 + 10000 - 3000);
    expect(await caja.listarMovimientos(sesionId), hasLength(2));
  });

  test('no se puede abrir una segunda sesión en el mismo terminal', () async {
    await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 1000,
    );

    await expectLater(
      caja.abrirSesion(
        terminalId: terminalId,
        usuarioAperturaId: usuarioId,
        efectivoInicialCentavos: 2000,
      ),
      throwsA(anything),
    );
  });

  test('movimiento_caja se rechaza si la sesión no está abierta', () async {
    await expectLater(
      db.into(db.movimientoCaja).insert(
        MovimientoCajaCompanion.insert(
          cajaSesionId: 999,
          tipo: 'ENTRADA',
          montoCentavos: 100,
          usuarioId: usuarioId,
        ),
      ),
      throwsA(anything),
    );
  });

  test('cerrarSesion con lo contado igual a lo esperado da diferencia 0', () async {
    final sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 50000,
    );
    await db.into(db.movimientoCaja).insert(
      MovimientoCajaCompanion.insert(
        cajaSesionId: sesionId,
        tipo: 'ENTRADA',
        montoCentavos: 5000,
        usuarioId: usuarioId,
      ),
    );

    await caja.cerrarSesion(
      cajaSesionId: sesionId,
      usuarioCierreId: usuarioId,
      efectivoContadoCentavos: 55000,
    );

    final sesion = await (db.select(
      db.cajaSesion,
    )..where((s) => s.id.equals(sesionId))).getSingle();
    expect(sesion.estado, 'CERRADA');
    expect(sesion.efectivoEsperadoCentavos, 55000);
    expect(sesion.efectivoContadoCentavos, 55000);
    expect(sesion.diferenciaCentavos, 0);
  });

  test('cerrarSesion con sobrante y con faltante calcula la diferencia con signo', () async {
    final sesionSobrante = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 10000,
    );
    await caja.cerrarSesion(
      cajaSesionId: sesionSobrante,
      usuarioCierreId: usuarioId,
      efectivoContadoCentavos: 10500,
    );
    var sesion = await (db.select(
      db.cajaSesion,
    )..where((s) => s.id.equals(sesionSobrante))).getSingle();
    expect(sesion.diferenciaCentavos, 500);

    final otroTerminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 2', codigo: 'T2'));
    final sesionFaltante = await caja.abrirSesion(
      terminalId: otroTerminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 10000,
    );
    await caja.cerrarSesion(
      cajaSesionId: sesionFaltante,
      usuarioCierreId: usuarioId,
      efectivoContadoCentavos: 9800,
    );
    sesion = await (db.select(
      db.cajaSesion,
    )..where((s) => s.id.equals(sesionFaltante))).getSingle();
    expect(sesion.diferenciaCentavos, -200);
  });

  test('cerrar una sesión ya cerrada se rechaza', () async {
    final sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 10000,
    );
    await caja.cerrarSesion(
      cajaSesionId: sesionId,
      usuarioCierreId: usuarioId,
      efectivoContadoCentavos: 10000,
    );

    await expectLater(
      caja.cerrarSesion(
        cajaSesionId: sesionId,
        usuarioCierreId: usuarioId,
        efectivoContadoCentavos: 10000,
      ),
      throwsA(isA<SesionCajaNoAbiertaException>()),
    );
  });

  test('cerrar una sesión inexistente se rechaza', () async {
    await expectLater(
      caja.cerrarSesion(
        cajaSesionId: 9999,
        usuarioCierreId: usuarioId,
        efectivoContadoCentavos: 0,
      ),
      throwsA(isA<SesionCajaNoEncontradaException>()),
    );
  });

  test('tras cerrar, un movimiento sobre esa sesión se rechaza y se puede abrir otra', () async {
    final sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 10000,
    );
    await caja.cerrarSesion(
      cajaSesionId: sesionId,
      usuarioCierreId: usuarioId,
      efectivoContadoCentavos: 10000,
    );

    await expectLater(
      db.into(db.movimientoCaja).insert(
        MovimientoCajaCompanion.insert(
          cajaSesionId: sesionId,
          tipo: 'ENTRADA',
          montoCentavos: 100,
          usuarioId: usuarioId,
        ),
      ),
      throwsA(anything),
    );

    final nuevaSesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 5000,
    );
    expect(await caja.efectivoEsperado(nuevaSesionId), 5000);
  });
}
