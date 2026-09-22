import 'package:flutter/material.dart';

import '../../../shared/widgets/money_display.dart';

/// Confirmación de venta completada. El foco está en dejar al cajero
/// listo para la siguiente venta lo más rápido posible: folio, total y
/// un botón "Nueva venta" grande (también disponible con Enter).
class SaleCompletedPanel extends StatelessWidget {
  const SaleCompletedPanel({
    super.key,
    required this.folio,
    required this.totalCentavos,
    required this.onNuevaVenta,
  });

  final String folio;
  final int totalCentavos;
  final VoidCallback onNuevaVenta;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 72, color: Colors.green.shade600),
          const SizedBox(height: 16),
          const Text('Venta completada', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Folio $folio', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          MoneyDisplay(
            totalCentavos,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: onNuevaVenta,
            icon: const Icon(Icons.add),
            label: const Text('Nueva venta (Enter)'),
          ),
        ],
      ),
    );
  }
}
