import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/caja_repository.dart';
import 'package:pos_mg/database/repositories/compra_repository.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';
import 'package:pos_mg/database/repositories/pago_repository.dart';
import 'package:pos_mg/database/repositories/producto_repository.dart';
import 'package:pos_mg/database/repositories/venta_repository.dart';

/// Recorre en un solo flujo todo lo construido en los pasos 1 a 6:
/// crear producto -> abrir caja -> comprar a proveedor (abastece
/// inventario) -> vender con pago dividido (efectivo + tarjeta) ->
/// verificar inventario, pagos, caja y que el saldo materializado
/// sigue siendo consistente con el historial completo.
void main() {
  late AppDatabase db;
  late ProductoRepository productos;
  late CompraRepository compras;
  late VentaRepository ventas;
  late InventarioRepository inventario;
  late PagoRepository pagos;
  late CajaRepository caja;

  late int terminalId;
  late int usuarioId;
  late int proveedorId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    productos = ProductoRepository(db);
    compras = CompraRepository(db);
    ventas = VentaRepository(db);
    inventario = InventarioRepository(db);
    pagos = PagoRepository(db);
    caja = CajaRepository(db);

    terminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 1', codigo: 'T1'));
    usuarioId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'Ana', rol: 'DUEÑO'));
    proveedorId = await db
        .into(db.proveedor)
        .insert(ProveedorCompanion.insert(nombre: 'Distribuidora XYZ'));
  });

  tearDown(() => db.close());

  test('flujo completo: producto -> compra -> venta con pago dividido -> caja', () async {
    final productoId = await productos.crear(
      nombre: 'Refresco de cola',
      codigoInterno: 'P001',
      codigoBarras: '7501234567890',
      unidad: UnidadProducto.pieza,
      precioVentaCentavos: 1500,
    );

    final sesionId = await caja.abrirSesion(
      terminalId: terminalId,
      usuarioAperturaId: usuarioId,
      efectivoInicialCentavos: 50000,
    );

    final compraId = await compras.registrarCompra(
      terminalId: terminalId,
      folio: 'C001',
      proveedorId: proveedorId,
      usuarioId: usuarioId,
      cajaSesionId: sesionId,
      items: [
        ItemCompra(productoId: productoId, cantidad: 50, costoUnitarioCentavos: 900),
      ],
    );
    expect(await inventario.consultarSaldo(productoId), 50);

    final encontrado = await productos.buscar('7501234567890');
    expect(encontrado.single.id, productoId);

    final ventaId = await ventas.registrarVentaConPago(
      terminalId: terminalId,
      folio: 'V001',
      usuarioId: usuarioId,
      items: [
        ItemVenta(
          productoId: productoId,
          cantidad: 6,
          precioUnitarioCentavos: 1500,
          costoUnitarioCentavos: 900,
        ),
      ],
      cobros: const [
        Cobro(metodo: MetodoPago.efectivo, montoCentavos: 5000),
        Cobro(metodo: MetodoPago.tarjeta, montoCentavos: 4000, ivaCentavos: 500),
      ],
      cajaSesionId: sesionId,
    );

    // Inventario: 50 (compra) - 6 (venta) = 44.
    expect(await inventario.consultarSaldo(productoId), 44);
    final historial = await inventario.listarMovimientos(productoId);
    expect(historial, hasLength(2));
    expect(historial.last.tipo, 'COMPRA');
    expect(historial.last.referenciaId, compraId);
    expect(historial.first.tipo, 'VENTA');
    expect(historial.first.referenciaId, ventaId);

    // Pagos: uno en efectivo, uno en tarjeta, sumando el total exacto.
    final listaPagos = await pagos.listarPagos(ventaId);
    expect(listaPagos, hasLength(2));
    expect(
      listaPagos.fold<int>(0, (acc, p) => acc + p.montoCentavos),
      6 * 1500,
    );

    // Caja: solo el tramo en efectivo entra como movimiento de caja.
    final movimientosCaja = await caja.listarMovimientos(sesionId);
    expect(movimientosCaja, hasLength(1));
    expect(movimientosCaja.single.montoCentavos, 5000);
    expect(await caja.efectivoEsperado(sesionId), 50000 + 5000);

    // El saldo materializado sigue siendo consistente con todo el
    // historial de movimiento_inventario tras compra + venta.
    expect(await db.reconciliarInventario(), isEmpty);
  });
}
