import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

/// Existencia actual de un producto (piezas o gramos según su unidad).
/// Se usa tanto en el catálogo de Productos como en la búsqueda de
/// Ventas, para que el cajero vea el stock disponible antes de vender.
/// Es un `StreamProvider` (no `FutureProvider`) a propósito: usa
/// `InventarioRepository.observarSaldo`, que reacciona sola a cualquier
/// venta, compra, cancelación o ajuste — sin esto, la UI se quedaba con
/// el valor leído una sola vez y no reflejaba cambios posteriores.
final productoStockProvider = StreamProvider.family<int, int>(
  (ref, productoId) => ref.watch(inventarioRepositoryProvider).observarSaldo(productoId),
);
