import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/database/repositories/envase_repository.dart';
import 'package:pos_mg/features/ventas/controllers/sale_cart_controller.dart';

/// `SaleCartController` es 100% en memoria (sin Drift): no necesita base
/// de datos, solo un `ProviderContainer`.
void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  ProductoData producto({required int id, int? tipoEnvaseId}) => ProductoData(
    id: id,
    nombre: 'Producto $id',
    codigoInterno: 'P$id',
    unidad: 'pieza',
    precioVentaCentavos: 1500,
    activo: 1,
    creadoEn: '2024-01-01',
    tipoEnvaseId: tipoEnvaseId,
  );

  test('quitarCliente limpia una linea con deposito cobrado', () {
    final notifier = container.read(saleCartControllerProvider.notifier);
    notifier.agregarProducto(producto(id: 1, tipoEnvaseId: 10), cantidadInicial: 1);
    notifier.asociarCliente(id: 5, nombre: 'Juan');
    notifier.configurarEnvase(1, [
      const OperacionEnvaseVenta(
        tipoEnvaseId: 10,
        tipo: TipoOperacionEnvase.depositoCobrado,
        cantidad: 2,
        montoUnitarioCentavos: 5000,
      ),
    ]);

    expect(container.read(saleCartControllerProvider).depositoEnvaseCentavos, 10000);

    notifier.quitarCliente();

    final estado = container.read(saleCartControllerProvider);
    expect(estado.clienteId, isNull);
    expect(estado.lineas.single.operacionesEnvase, isEmpty);
    expect(estado.depositoEnvaseCentavos, 0);
  });

  test('quitarCliente limpia una linea con prestamo sin deposito', () {
    final notifier = container.read(saleCartControllerProvider.notifier);
    notifier.agregarProducto(producto(id: 1, tipoEnvaseId: 10), cantidadInicial: 1);
    notifier.asociarCliente(id: 5, nombre: 'Juan');
    notifier.configurarEnvase(1, [
      const OperacionEnvaseVenta(tipoEnvaseId: 10, tipo: TipoOperacionEnvase.prestado, cantidad: 1),
    ]);

    notifier.quitarCliente();

    final estado = container.read(saleCartControllerProvider);
    expect(estado.clienteId, isNull);
    expect(estado.lineas.single.operacionesEnvase, isEmpty);
  });

  test('quitarCliente no toca lineas sin operacion o con entregado/recibido', () {
    final notifier = container.read(saleCartControllerProvider.notifier);
    notifier.agregarProducto(producto(id: 1, tipoEnvaseId: 10), cantidadInicial: 1);
    notifier.agregarProducto(producto(id: 2, tipoEnvaseId: 11), cantidadInicial: 1);
    notifier.agregarProducto(producto(id: 3), cantidadInicial: 1); // sin envase
    notifier.asociarCliente(id: 5, nombre: 'Juan');
    notifier.configurarEnvase(1, [
      const OperacionEnvaseVenta(tipoEnvaseId: 10, tipo: TipoOperacionEnvase.entregado, cantidad: 1),
    ]);
    // producto 2 se queda sin operacionesEnvase (vacío) a propósito.

    notifier.quitarCliente();

    final lineas = container.read(saleCartControllerProvider).lineas;
    expect(
      lineas.firstWhere((l) => l.productoId == 1).operacionesEnvase.single.tipo,
      TipoOperacionEnvase.entregado,
    );
    expect(lineas.firstWhere((l) => l.productoId == 2).operacionesEnvase, isEmpty);
    expect(lineas.firstWhere((l) => l.productoId == 3).operacionesEnvase, isEmpty);
  });

  test('quitarCliente sin lineas de envase solo quita al cliente', () {
    final notifier = container.read(saleCartControllerProvider.notifier);
    notifier.agregarProducto(producto(id: 1), cantidadInicial: 1);
    notifier.asociarCliente(id: 5, nombre: 'Juan');

    notifier.quitarCliente();

    final estado = container.read(saleCartControllerProvider);
    expect(estado.clienteId, isNull);
    expect(estado.clienteNombre, isNull);
    expect(estado.lineas, hasLength(1));
  });

  test('configurarEnvase combina entregado y deposito cobrado en la misma linea', () {
    final notifier = container.read(saleCartControllerProvider.notifier);
    notifier.agregarProducto(producto(id: 1, tipoEnvaseId: 10), cantidadInicial: 3);
    notifier.asociarCliente(id: 5, nombre: 'Juan');
    notifier.configurarEnvase(1, const [
      OperacionEnvaseVenta(tipoEnvaseId: 10, tipo: TipoOperacionEnvase.entregado, cantidad: 2),
      OperacionEnvaseVenta(
        tipoEnvaseId: 10,
        tipo: TipoOperacionEnvase.depositoCobrado,
        cantidad: 1,
        montoUnitarioCentavos: 5000,
      ),
    ]);

    final linea = container.read(saleCartControllerProvider).lineas.single;
    expect(linea.operacionesEnvase, hasLength(2));
    expect(container.read(saleCartControllerProvider).depositoEnvaseCentavos, 5000);
  });

  test('configurarEnvase combina entregado y prestamo sin deposito en la misma linea', () {
    final notifier = container.read(saleCartControllerProvider.notifier);
    notifier.agregarProducto(producto(id: 1, tipoEnvaseId: 10), cantidadInicial: 2);
    notifier.asociarCliente(id: 5, nombre: 'Juan');
    notifier.configurarEnvase(1, const [
      OperacionEnvaseVenta(tipoEnvaseId: 10, tipo: TipoOperacionEnvase.entregado, cantidad: 1),
      OperacionEnvaseVenta(tipoEnvaseId: 10, tipo: TipoOperacionEnvase.prestado, cantidad: 1),
    ]);

    final linea = container.read(saleCartControllerProvider).lineas.single;
    expect(linea.operacionesEnvase, hasLength(2));
    expect(container.read(saleCartControllerProvider).depositoEnvaseCentavos, 0);
  });

  test('quitarCliente en una linea mixta conserva entregado y quita solo deposito cobrado', () {
    final notifier = container.read(saleCartControllerProvider.notifier);
    notifier.agregarProducto(producto(id: 1, tipoEnvaseId: 10), cantidadInicial: 3);
    notifier.asociarCliente(id: 5, nombre: 'Juan');
    notifier.configurarEnvase(1, const [
      OperacionEnvaseVenta(tipoEnvaseId: 10, tipo: TipoOperacionEnvase.entregado, cantidad: 2),
      OperacionEnvaseVenta(
        tipoEnvaseId: 10,
        tipo: TipoOperacionEnvase.depositoCobrado,
        cantidad: 1,
        montoUnitarioCentavos: 5000,
      ),
    ]);

    notifier.quitarCliente();

    final linea = container.read(saleCartControllerProvider).lineas.single;
    expect(linea.operacionesEnvase, hasLength(1));
    expect(linea.operacionesEnvase.single.tipo, TipoOperacionEnvase.entregado);
    expect(linea.operacionesEnvase.single.cantidad, 2);
  });
}
