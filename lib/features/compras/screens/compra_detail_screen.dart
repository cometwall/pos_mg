import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session_providers.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/compra_repository.dart';
import '../../../features/historial/controllers/sale_history_controllers.dart';
import '../../../shared/widgets/money_display.dart';
import '../controllers/compra_controllers.dart';

class CompraDetailScreen extends ConsumerWidget {
  const CompraDetailScreen({super.key, required this.compra});

  final CompraData compra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalleAsync = ref.watch(detalleCompraProvider(compra.id));
    final esCancelada = compra.estado == 'CANCELADA';

    return Scaffold(
      appBar: AppBar(title: Text('Compra ${compra.folio}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chip(
              label: Text(compra.estado),
              backgroundColor: esCancelada ? Colors.red.shade50 : Colors.green.shade50,
            ),
            const SizedBox(height: 16),
            const Text('Productos', style: TextStyle(fontWeight: FontWeight.w700)),
            const Divider(),
            Expanded(
              child: detalleAsync.when(
                data: (detalles) => ListView(
                  children: [
                    for (final detalle in detalles)
                      Consumer(
                        builder: (context, ref, _) {
                          final nombre = ref.watch(nombreProductoProvider(detalle.productoId));
                          return ListTile(
                            title: Text(nombre.value ?? 'Producto #${detalle.productoId}'),
                            subtitle: Text('Cantidad: ${detalle.cantidad}'),
                            trailing: MoneyDisplay(detalle.subtotalCentavos),
                          );
                        },
                      ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Error: $error'),
              ),
            ),
            if (!esCancelada)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => _cancelarCompra(context, ref),
                  child: const Text('Cancelar compra'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelarCompra(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Cancelar esta compra?'),
        content: const Text(
          'Se revertirá el 100% del inventario recibido. Se rechaza si ya se vendió parte de lo comprado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancelar compra'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    final usuario = await ref.read(currentUsuarioProvider.future);
    try {
      await ref
          .read(compraRepositoryProvider)
          .cancelarCompra(compraId: compra.id, usuarioId: usuario.id);
      if (context.mounted) Navigator.of(context).pop();
    } on StockInsuficienteParaCancelarException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se puede cancelar: ya se vendieron ${e.aRevertir - e.disponible} unidades del producto #${e.productoId}.',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}
