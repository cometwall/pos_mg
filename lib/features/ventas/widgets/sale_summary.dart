import 'package:flutter/material.dart';

import '../../../shared/widgets/money_display.dart';

/// Subtotal/depósito de envase/total de la venta en progreso. También se
/// reutiliza en el detalle de Historial (ahí sin depósito, ya que una
/// venta cerrada no vuelve a mostrar operaciones de envase pendientes de
/// configurar).
class SaleSummary extends StatelessWidget {
  const SaleSummary({
    super.key,
    required this.subtotalCentavos,
    required this.totalCentavos,
    this.depositoEnvaseCentavos = 0,
  });

  final int subtotalCentavos;
  final int totalCentavos;

  /// Depósito de envase configurado en el carrito. Se muestra aparte y se
  /// suma al TOTAL para que el cajero sepa que también debe cobrarlo
  /// físicamente, aunque contablemente sea un concepto independiente del
  /// subtotal de productos (ver `SaleCartState.depositoEnvaseCentavos`).
  final int depositoEnvaseCentavos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal productos', style: TextStyle(color: Colors.black54)),
            MoneyDisplay(subtotalCentavos, style: const TextStyle(color: Colors.black54)),
          ],
        ),
        if (depositoEnvaseCentavos > 0) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Depósito de envase', style: TextStyle(color: Colors.black54)),
              MoneyDisplay(depositoEnvaseCentavos, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
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
