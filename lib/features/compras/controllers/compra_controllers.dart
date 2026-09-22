import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../database/app_database.dart';

final comprasHistorialProvider = StreamProvider<List<CompraData>>(
  (ref) => ref.watch(compraRepositoryProvider).observarCompras(),
);

final proveedoresProvider = FutureProvider<List<ProveedorData>>(
  (ref) => ref.watch(proveedorRepositoryProvider).listarTodos(),
);

final detalleCompraProvider = FutureProvider.family<List<DetalleCompraData>, int>(
  (ref, compraId) => ref.watch(compraRepositoryProvider).listarDetalle(compraId),
);

final nombreProveedorProvider = FutureProvider.family<String, int>((ref, proveedorId) async {
  final proveedores = await ref.watch(proveedoresProvider.future);
  return proveedores
      .firstWhere(
        (p) => p.id == proveedorId,
        orElse: () => ProveedorData(id: proveedorId, nombre: 'Proveedor #$proveedorId'),
      )
      .nombre;
});
