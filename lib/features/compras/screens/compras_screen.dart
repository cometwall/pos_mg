import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/money_display.dart';
import '../controllers/compra_controllers.dart';
import 'compra_detail_screen.dart';
import 'new_compra_screen.dart';

/// Registro de compras a proveedores. Módulo secundario: la frecuencia
/// de uso es mucho menor que Ventas, así que vive fuera del flujo
/// principal, sin atajos de teclado dedicados.
class ComprasScreen extends ConsumerWidget {
  const ComprasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comprasAsync = ref.watch(comprasHistorialProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Compras')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'compras_fab',
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const NewCompraScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Nueva compra'),
      ),
      body: comprasAsync.when(
        data: (compras) {
          if (compras.isEmpty) {
            return const Center(child: Text('Sin compras todavía'));
          }
          return ListView.separated(
            itemCount: compras.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final compra = compras[index];
              final esCancelada = compra.estado == 'CANCELADA';
              return ListTile(
                title: Text(compra.folio),
                subtitle: Consumer(
                  builder: (context, ref, _) {
                    final nombre = ref.watch(nombreProveedorProvider(compra.proveedorId));
                    return Text(nombre.value ?? compra.fecha);
                  },
                ),
                leading: Chip(
                  label: Text(compra.estado, style: const TextStyle(fontSize: 11)),
                  backgroundColor: esCancelada ? Colors.red.shade50 : Colors.green.shade50,
                  visualDensity: VisualDensity.compact,
                ),
                trailing: MoneyDisplay(compra.totalCentavos),
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => CompraDetailScreen(compra: compra))),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
