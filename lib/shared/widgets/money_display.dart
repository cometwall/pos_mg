import 'package:flutter/material.dart';

import '../../core/money.dart';

/// Muestra un monto en centavos con formato de moneda consistente en toda
/// la app (`$152.50`). Es el único lugar que debería llamar a
/// [formatCentavos] dentro de un widget.
class MoneyDisplay extends StatelessWidget {
  const MoneyDisplay(
    this.centavos, {
    super.key,
    this.style,
    this.color,
  });

  final int centavos;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatCentavos(centavos),
      style: (style ?? const TextStyle()).copyWith(color: color),
    );
  }
}
