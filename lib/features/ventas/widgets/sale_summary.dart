import 'package:flutter/material.dart';

import '../../../shared/widgets/money_display.dart';

/// Subtotal/total de la venta en progreso. También se reutiliza en el
/// detalle de Historial.
class SaleSummary extends StatelessWidget {
  const SaleSummary({super.key, required this.subtotalCentavos, required this.totalCentavos});

  final int subtotalCentavos;
  final int totalCentavos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal', style: TextStyle(color: Colors.black54)),
            MoneyDisplay(subtotalCentavos, style: const TextStyle(color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TOTAL',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            MoneyDisplay(
              totalCentavos,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
            ),
          ],
        ),
      ],
    );
  }
}
