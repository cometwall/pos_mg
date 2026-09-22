import 'package:flutter/material.dart';

import '../../core/quantity.dart';

/// Editor de cantidad para una línea del carrito. Un solo componente con
/// dos modos según `unidad` del producto:
/// - `pieza`: incrementa/decrementa en enteros.
/// - `peso`: el usuario escribe kilogramos; internamente se maneja en
///   gramos (ver [core/quantity.dart]).
///
/// El widget nunca conoce gramos hacia afuera: [cantidadGramosOPiezas]
/// siempre es la cantidad en la unidad de guardado (piezas o gramos), y
/// para `peso` se muestra convertida a kilogramos.
class QuantityEditor extends StatelessWidget {
  const QuantityEditor({
    super.key,
    required this.esPorPeso,
    required this.cantidadGramosOPiezas,
    required this.onChanged,
  });

  final bool esPorPeso;
  final int cantidadGramosOPiezas;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    if (esPorPeso) {
      return _EditorPeso(
        gramos: cantidadGramosOPiezas,
        onChanged: onChanged,
      );
    }
    return _EditorPieza(
      piezas: cantidadGramosOPiezas,
      onChanged: onChanged,
    );
  }
}

class _EditorPieza extends StatelessWidget {
  const _EditorPieza({required this.piezas, required this.onChanged});

  final int piezas;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          visualDensity: VisualDensity.compact,
          onPressed: piezas > 1 ? () => onChanged(piezas - 1) : null,
        ),
        SizedBox(
          width: 28,
          child: Text(
            '$piezas',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          visualDensity: VisualDensity.compact,
          onPressed: () => onChanged(piezas + 1),
        ),
      ],
    );
  }
}

class _EditorPeso extends StatefulWidget {
  const _EditorPeso({required this.gramos, required this.onChanged});

  final int gramos;
  final ValueChanged<int> onChanged;

  @override
  State<_EditorPeso> createState() => _EditorPesoState();
}

class _EditorPesoState extends State<_EditorPeso> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatKilos(widget.gramos));
  }

  @override
  void didUpdateWidget(covariant _EditorPeso oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gramos != widget.gramos) {
      _controller.text = _formatKilos(widget.gramos);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatKilos(int gramos) =>
      gramosAKilogramos(gramos).toStringAsFixed(3);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          suffixText: 'kg',
          isDense: true,
        ),
        onSubmitted: (texto) {
          final kilos = double.tryParse(texto.replaceAll(',', '.'));
          if (kilos != null && kilos > 0) {
            widget.onChanged(kilogramosAGramos(kilos));
          } else {
            _controller.text = _formatKilos(widget.gramos);
          }
        },
      ),
    );
  }
}
