import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/inventario_repository.dart';
import 'package:pos_mg/database/repositories/pago_repository.dart';
import 'package:pos_mg/database/repositories/venta_repository.dart';
import 'package:pos_mg/features/ventas/controllers/sale_checkout_controller.dart';
import 'package:pos_mg/features/ventas/models/sale_cart_line.dart';

void main() {
  late AppDatabase db;
  late int terminalId;
  late int usuarioId;
  late int productoId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    terminalId = await db
        .into(db.terminal)
        .insert(TerminalCompanion.insert(nombre: 'Caja 1', codigo: 'T1'));
    usuarioId = await db
        .into(db.usuario)
        .insert(UsuarioCompanion.insert(nombre: 'Ana', rol: 'CAJERO'));
    productoId = await db.into(db.producto).insert(
      ProductoCompanion.insert(
        nombre: 'Queso',
        codigoInterno: 'P-PESO',
        unidad: 'peso',
        precioVentaCentavos: 15000, // $150.00 por kilogramo
        costoReferenciaCentavos: const Value(9000), // $90.00 por kilogramo
      ),
    );
    await InventarioRepository(
      db,
    ).registrarAjuste(productoId: productoId, cantidad: 2000, usuarioId: usuarioId);
  });

  tearDown(() => db.close());

  test(
    'venta de producto por peso guarda precio/costo por gramo y el subtotal es exacto',
    () async {
      final ventaRepo = VentaRepository(db);
      final service = SaleCheckoutService(ventaRepo);

      final linea = SaleCartLine(
        productoId: productoId,
        nombre: 'Queso',
        esPorPeso: true,
        cantidad: 500, // 500 gramos = 0.5 kg
        precioUnitarioCentavos: 15000,
        costoReferenciaCentavos: 9000,
      );

      final resultado = await service.cobrar(
        terminalId: terminalId,
        usuarioId: usuarioId,
        cajaSesionId: null,
        clienteId: null,
        lineas: [linea],
        cobros: [
          Cobro(metodo: MetodoPago.tarjeta, montoCentavos: linea.subtotalCentavos),
        ],
      );

      expect(resultado, isA<CheckoutExitoso>());
      final exitoso = resultado as CheckoutExitoso;
      expect(exitoso.totalCentavos, 7500); // $150.00/kg * 0.5kg = $75.00

      final detalle = await ventaRepo.listarDetalle(exitoso.ventaId);
      expect(detalle, hasLength(1));
      expect(detalle.first.cantidad, 500);
      expect(detalle.first.precioUnitarioCentavos, 15); // por gramo, no por kilo
      expect(detalle.first.costoUnitarioCentavos, 9); // por gramo, no por kilo
      expect(detalle.first.subtotalCentavos, 7500);
    },
  );
}
