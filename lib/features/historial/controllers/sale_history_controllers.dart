import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../database/app_database.dart';

/// Historial de ventas, más recientes primero.
final ventasHistorialProvider = StreamProvider<List<VentaData>>(
  (ref) => ref.watch(ventaRepositoryProvider).observarVentas(),
);

final ventaPorIdProvider = FutureProvider.family<VentaData?, int>(
  (ref, ventaId) => ref.watch(ventaRepositoryProvider).obtenerPorId(ventaId),
);

final detalleVentaProvider = FutureProvider.family<List<DetalleVentaData>, int>(
  (ref, ventaId) => ref.watch(ventaRepositoryProvider).listarDetalle(ventaId),
);

final pagosVentaProvider = FutureProvider.family<List<PagoData>, int>(
  (ref, ventaId) => ref.watch(pagoRepositoryProvider).listarPagos(ventaId),
);

final devolucionesVentaProvider = FutureProvider.family<List<DevolucionData>, int>(
  (ref, ventaId) => ref.watch(devolucionRepositoryProvider).listarPorVenta(ventaId),
);

final operacionesEnvaseVentaProvider = FutureProvider.family<List<OperacionEnvaseData>, int>(
  (ref, ventaId) => ref.watch(envaseRepositoryProvider).listarOperaciones(ventaId),
);

final cantidadActivaDetalleProvider = FutureProvider.family<int, int>(
  (ref, detalleVentaId) => ref.watch(cuentasQueriesProvider).cantidadActivaDetalle(detalleVentaId),
);

final tienePagoTarjetaProvider = FutureProvider.family<bool, int>((ref, ventaId) async {
  final pagos = await ref.watch(pagosVentaProvider(ventaId).future);
  return pagos.any((p) => p.metodo == 'TARJETA');
});

final nombreProductoProvider = FutureProvider.family<String, int>((ref, productoId) async {
  final producto = await ref.watch(productoRepositoryProvider).obtenerPorId(productoId);
  return producto?.nombre ?? 'Producto #$productoId';
});

final productoPorIdProvider = FutureProvider.family<ProductoData?, int>(
  (ref, productoId) => ref.watch(productoRepositoryProvider).obtenerPorId(productoId),
);

/// Depósito/préstamo de envase todavía pendiente de esa venta para ese
/// tipo de envase — se usa al devolver un producto para saber cuánto se
/// puede marcar como "el envase también regresa" (ver
/// `DevolucionRepository.registrarDevolucion`).
final depositoPendienteVentaProvider = FutureProvider.family<int, (int ventaId, int tipoEnvaseId)>(
  (ref, params) =>
      ref.watch(cuentasQueriesProvider).depositoPendienteVenta(params.$1, params.$2),
);

final prestamoPendienteVentaProvider = FutureProvider.family<int, (int ventaId, int tipoEnvaseId)>(
  (ref, params) =>
      ref.watch(cuentasQueriesProvider).envasePendienteVenta(params.$1, params.$2),
);

final nombreClienteProvider = FutureProvider.family<String?, int>((ref, clienteId) async {
  final cliente = await ref.watch(clienteRepositoryProvider).obtenerPorId(clienteId);
  return cliente?.nombre;
});
