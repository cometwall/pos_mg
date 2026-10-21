import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/caja_repository.dart';
import 'package:pos_mg/database/repositories/cuentas_queries.dart';
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
  late CuentasQueries cuentas;
  late int terminalId;
  late int usuarioId;
  late int productoId;
  late int clienteId;
  late int tipoEnvaseId;
  late int sesionId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    ventas = VentaRepository(db);
    devoluciones = DevolucionRepository(db);
    inventario = InventarioRepository(db);
    caja = CajaRepository(db);
    envases = EnvaseRepository(db);
    cuentas = CuentasQueries(db);

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
    await inventario.registrarAjuste(
      productoId: productoId,
      cantidad: 20,
      usuarioId: usuarioId,
    );
    tipoEnvaseId = await db
        .into(db.tipoEnvase)
        .insert(TipoEnvaseCompanion.insert(nombre: 'Botellón 20L'));
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

  Future<(int ventaId, int detalleVentaId)> ventaEnEfectivo(int cantidad) async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V${DateTime.now().microsecondsSinceEpoch}',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: cantidad,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: [Cobro(metodo: MetodoPago.efectivo, montoCentavos: cantidad * 1500)],
      cajaSesionId: sesionId,
    );
    final detalle = await ventas.listarDetalle(ventaId);
    return (ventaId, detalle.single.id);
  }

  test('devolucion BUENO reingresa inventario y la reconciliacion sigue vacia', () async {
    final (ventaId, detalleVentaId) = await ventaEnEfectivo(5);
    expect(await inventario.consultarSaldo(productoId), 15);

    await devoluciones.registrarDevolucion(
      ventaId: ventaId,
      detalleVentaId: detalleVentaId,
      productoId: productoId,
      cantidad: 2,
      condicion: CondicionDevolucion.bueno,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    expect(await inventario.consultarSaldo(productoId), 17);
    expect(await db.reconciliarInventario(), isEmpty);

    final movimientosCaja = await caja.listarMovimientos(sesionId);
    expect(movimientosCaja.map((m) => m.montoCentavos), containsAll([1500 * 5, -3000]));
  });

  test('devolucion DAÑADO no reingresa inventario', () async {
    final (ventaId, detalleVentaId) = await ventaEnEfectivo(5);

    await devoluciones.registrarDevolucion(
      ventaId: ventaId,
      detalleVentaId: detalleVentaId,
      productoId: productoId,
      cantidad: 2,
      condicion: CondicionDevolucion.danado,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    expect(await inventario.consultarSaldo(productoId), 15);
  });

  test('dos devoluciones parciales validas, la tercera que excede se rechaza', () async {
    final (ventaId, detalleVentaId) = await ventaEnEfectivo(5);

    await devoluciones.registrarDevolucion(
      ventaId: ventaId,
      detalleVentaId: detalleVentaId,
      productoId: productoId,
      cantidad: 2,
      condicion: CondicionDevolucion.bueno,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );
    await devoluciones.registrarDevolucion(
      ventaId: ventaId,
      detalleVentaId: detalleVentaId,
      productoId: productoId,
      cantidad: 2,
      condicion: CondicionDevolucion.bueno,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    await expectLater(
      devoluciones.registrarDevolucion(
        ventaId: ventaId,
        detalleVentaId: detalleVentaId,
        productoId: productoId,
        cantidad: 2,
        condicion: CondicionDevolucion.bueno,
        usuarioId: usuarioId,
        cajaSesionId: sesionId,
      ),
      throwsA(isA<CantidadExcedeActivaException>()),
    );

    expect(await devoluciones.listarPorVenta(ventaId), hasLength(2));
  });

  test('devolucion sobre venta con pago TARJETA se rechaza', () async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'VTARJETA',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 3,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: const [Cobro(metodo: MetodoPago.tarjeta, montoCentavos: 4500)],
    );
    final detalle = await ventas.listarDetalle(ventaId);

    await expectLater(
      devoluciones.registrarDevolucion(
        ventaId: ventaId,
        detalleVentaId: detalle.single.id,
        productoId: productoId,
        cantidad: 1,
        condicion: CondicionDevolucion.bueno,
        usuarioId: usuarioId,
        cajaSesionId: sesionId,
      ),
      throwsA(isA<ReembolsoTarjetaNoSoportadoException>()),
    );
  });

  test('devolucion sobre venta CANCELADA se rechaza', () async {
    final (ventaId, detalleVentaId) = await ventaEnEfectivo(5);
    await ventas.cancelarVenta(
      ventaId: ventaId,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
    );

    await expectLater(
      devoluciones.registrarDevolucion(
        ventaId: ventaId,
        detalleVentaId: detalleVentaId,
        productoId: productoId,
        cantidad: 1,
        condicion: CondicionDevolucion.bueno,
        usuarioId: usuarioId,
        cajaSesionId: sesionId,
      ),
      throwsA(anything),
    );
  });

  test('devolucion sin cajaSesionId cuando hay monto a devolver se rechaza', () async {
    final (ventaId, detalleVentaId) = await ventaEnEfectivo(5);

    await expectLater(
      devoluciones.registrarDevolucion(
        ventaId: ventaId,
        detalleVentaId: detalleVentaId,
        productoId: productoId,
        cantidad: 1,
        condicion: CondicionDevolucion.bueno,
        usuarioId: usuarioId,
      ),
      throwsArgumentError,
    );
  });

  Future<(int ventaId, int detalleVentaId)> ventaConDeposito(int cantidad) async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'VDEP${DateTime.now().microsecondsSinceEpoch}',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: cantidad,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: [Cobro(metodo: MetodoPago.efectivo, montoCentavos: cantidad * 1500)],
      cajaSesionId: sesionId,
      clienteId: clienteId,
      operacionesEnvase: [
        OperacionEnvaseVenta(
          tipoEnvaseId: tipoEnvaseId,
          tipo: TipoOperacionEnvase.depositoCobrado,
          cantidad: cantidad,
          montoUnitarioCentavos: 5000,
        ),
      ],
    );
    final detalle = await ventas.listarDetalle(ventaId);
    return (ventaId, detalle.single.id);
  }

  test('devolucion con el deposito de envase regresando libera el pendiente y repone stock', () async {
    final (ventaId, detalleVentaId) = await ventaConDeposito(2);
    expect(await envases.saldoFisico(tipoEnvaseId), 8);
    expect(await cuentas.depositoPendienteVenta(ventaId, tipoEnvaseId), 2);

    await devoluciones.registrarDevolucion(
      ventaId: ventaId,
      detalleVentaId: detalleVentaId,
      productoId: productoId,
      cantidad: 1,
      condicion: CondicionDevolucion.bueno,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
      tipoEnvaseId: tipoEnvaseId,
      envaseDepositoRegresa: 1,
    );

    expect(await inventario.consultarSaldo(productoId), 19);
    expect(await envases.saldoFisico(tipoEnvaseId), 9);
    expect(await cuentas.depositoPendienteVenta(ventaId, tipoEnvaseId), 1);

    final movimientosCaja = await caja.listarMovimientos(sesionId);
    // El reembolso del producto (-1500) y la devolución del depósito (-5000).
    expect(movimientosCaja.map((m) => m.montoCentavos), containsAll([-1500, -5000]));
  });

  test('devolucion con el prestamo de envase regresando libera el pendiente del cliente', () async {
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'VPREST',
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
          cantidad: 1,
        ),
      ],
    );
    final detalle = await ventas.listarDetalle(ventaId);
    expect(await envases.saldoFisico(tipoEnvaseId), 9);
    expect(await cuentas.envasePendienteVenta(ventaId, tipoEnvaseId), 1);

    await devoluciones.registrarDevolucion(
      ventaId: ventaId,
      detalleVentaId: detalle.single.id,
      productoId: productoId,
      cantidad: 1,
      condicion: CondicionDevolucion.bueno,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
      tipoEnvaseId: tipoEnvaseId,
      envasePrestamoRegresa: 1,
    );

    expect(await envases.saldoFisico(tipoEnvaseId), 10);
    expect(await cuentas.envasePendienteVenta(ventaId, tipoEnvaseId), 0);
  });

  test('marcar mas envases regresando que unidades devueltas se rechaza', () async {
    final (ventaId, detalleVentaId) = await ventaConDeposito(2);

    await expectLater(
      devoluciones.registrarDevolucion(
        ventaId: ventaId,
        detalleVentaId: detalleVentaId,
        productoId: productoId,
        cantidad: 1,
        condicion: CondicionDevolucion.bueno,
        usuarioId: usuarioId,
        cajaSesionId: sesionId,
        tipoEnvaseId: tipoEnvaseId,
        envaseDepositoRegresa: 2,
      ),
      throwsA(isA<EnvaseRegresaExcedeCantidadException>()),
    );
  });

  test('regresar mas deposito del pendiente en esa venta se rechaza', () async {
    // Se venden 3 unidades del producto pero el depósito solo se cobró
    // para 1 (las otras 2 no requerían envase propio de la tienda) —
    // operacion_envase no está ligado 1:1 a la cantidad del producto.
    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'VDEP2',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 3,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: const [Cobro(metodo: MetodoPago.efectivo, montoCentavos: 4500)],
      cajaSesionId: sesionId,
      clienteId: clienteId,
      operacionesEnvase: [
        OperacionEnvaseVenta(
          tipoEnvaseId: tipoEnvaseId,
          tipo: TipoOperacionEnvase.depositoCobrado,
          cantidad: 1,
          montoUnitarioCentavos: 5000,
        ),
      ],
    );
    final detalle = await ventas.listarDetalle(ventaId);

    await expectLater(
      devoluciones.registrarDevolucion(
        ventaId: ventaId,
        detalleVentaId: detalle.single.id,
        productoId: productoId,
        cantidad: 2,
        condicion: CondicionDevolucion.bueno,
        usuarioId: usuarioId,
        cajaSesionId: sesionId,
        tipoEnvaseId: tipoEnvaseId,
        envaseDepositoRegresa: 2,
      ),
      throwsA(isA<CantidadExcedePendienteEnvaseException>()),
    );
  });
}
