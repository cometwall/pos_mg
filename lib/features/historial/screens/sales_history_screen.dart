import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../../../shared/widgets/money_display.dart';
import '../controllers/sale_history_controllers.dart';
import 'sale_detail_screen.dart';

/// Historial de ventas: consulta, filtro y punto de entrada a
/// devoluciones/cancelaciones. Las operaciones frecuentes (vender) no
/// viven aquí — esta pantalla es para lo ocasional.
class SalesHistoryScreen extends ConsumerStatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  ConsumerState<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends ConsumerState<SalesHistoryScreen> {
  String _filtro = '';

  @override
  Widget build(BuildContext context) {
    final ventasAsync = ref.watch(ventasHistorialProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar por folio',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (texto) => setState(() => _filtro = texto.trim().toLowerCase()),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ventasAsync.when(
                data: (ventas) {
                  final filtradas = _filtro.isEmpty
                      ? ventas
                      : ventas.where((v) => v.folio.toLowerCase().contains(_filtro)).toList();
                  if (filtradas.isEmpty) {
                    return const Center(child: Text('Sin ventas todavía'));
                  }
                  return ListView.separated(
                    itemCount: filtradas.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) => _VentaTile(venta: filtradas[index]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VentaTile extends ConsumerWidget {
  const _VentaTile({required this.venta});

  final VentaData venta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esCancelada = venta.estado == 'CANCELADA';
    final clienteAsync = venta.clienteId != null
        ? ref.watch(nombreClienteProvider(venta.clienteId!))
        : null;

    return ListTile(
      title: Text(venta.folio, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        clienteAsync?.when(
              data: (nombre) => nombre ?? venta.fecha,
              loading: () => venta.fecha,
              error: (_, _) => venta.fecha,
            ) ??
            venta.fecha,
      ),
      leading: Chip(
        label: Text(venta.estado, style: const TextStyle(fontSize: 11)),
        backgroundColor: esCancelada ? Colors.red.shade50 : Colors.green.shade50,
        labelStyle: TextStyle(color: esCancelada ? Colors.red.shade700 : Colors.green.shade700),
        visualDensity: VisualDensity.compact,
      ),
      trailing: MoneyDisplay(venta.totalCentavos, style: const TextStyle(fontWeight: FontWeight.w600)),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SaleDetailScreen(ventaId: venta.id)),
      ),
    );
  }
}
