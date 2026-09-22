import 'package:flutter/material.dart';

import '../../../core/money.dart';
import '../../../database/repositories/pago_repository.dart';
import '../../../database/repositories/venta_repository.dart';
import '../../../shared/widgets/money_display.dart';

enum _MetodoTab { efectivo, tarjeta, mixto }

/// Diálogo de cobro. Devuelve la lista de [Cobro] elegida por el cajero
/// (o `null` si se canceló) — nunca ejecuta el cobro él mismo, eso lo
/// hace `SaleCheckoutService` con el resultado.
///
/// El dominio no modela "efectivo recibido" ni "cambio": solo el monto
/// aplicado a la venta. Por eso el campo de efectivo recibido y el
/// cambio calculado viven solo en este diálogo (ayuda visual para el
/// cajero) y nunca se envían al backend.
class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key, required this.totalCentavos, required this.haySesionCaja});

  final int totalCentavos;
  final bool haySesionCaja;

  static Future<List<Cobro>?> show(
    BuildContext context, {
    required int totalCentavos,
    required bool haySesionCaja,
  }) {
    return showDialog<List<Cobro>>(
      context: context,
      builder: (_) => PaymentDialog(totalCentavos: totalCentavos, haySesionCaja: haySesionCaja),
    );
  }

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  _MetodoTab _tab = _MetodoTab.efectivo;

  final _efectivoRecibidoController = TextEditingController();
  final _mixtoEfectivoController = TextEditingController();
  final _mixtoTarjetaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.haySesionCaja) _tab = _MetodoTab.tarjeta;
  }

  @override
  void dispose() {
    _efectivoRecibidoController.dispose();
    _mixtoEfectivoController.dispose();
    _mixtoTarjetaController.dispose();
    super.dispose();
  }

  void _agregarADenominacion(TextEditingController controller, int centavos) {
    final actual = parseCentavosDesdeTexto(controller.text) ?? 0;
    controller.text = _formateaParaEditar(actual + centavos);
    setState(() {});
  }

  String _formateaParaEditar(int centavos) => (centavos / 100).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Cobrar'),
          const Spacer(),
          MoneyDisplay(widget.totalCentavos, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<_MetodoTab>(
              segments: const [
                ButtonSegment(value: _MetodoTab.efectivo, label: Text('Efectivo')),
                ButtonSegment(value: _MetodoTab.tarjeta, label: Text('Tarjeta')),
                ButtonSegment(value: _MetodoTab.mixto, label: Text('Mixto')),
              ],
              selected: {_tab},
              onSelectionChanged: (seleccion) => setState(() => _tab = seleccion.first),
            ),
            const SizedBox(height: 16),
            if (!widget.haySesionCaja && _tab != _MetodoTab.tarjeta) ...[
              const _AvisoSinCaja(),
              const SizedBox(height: 12),
            ],
            switch (_tab) {
              _MetodoTab.efectivo => _EfectivoPanel(
                totalCentavos: widget.totalCentavos,
                recibidoController: _efectivoRecibidoController,
                onDenominacion: (c) => _agregarADenominacion(_efectivoRecibidoController, c),
                onExacto: () => setState(
                  () => _efectivoRecibidoController.text = _formateaParaEditar(widget.totalCentavos),
                ),
                onChanged: () => setState(() {}),
              ),
              _MetodoTab.tarjeta => const _TarjetaPanel(),
              _MetodoTab.mixto => _MixtoPanel(
                totalCentavos: widget.totalCentavos,
                efectivoController: _mixtoEfectivoController,
                tarjetaController: _mixtoTarjetaController,
                onChanged: () => setState(() {}),
              ),
            },
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(
          onPressed: _puedeConfirmar() ? () => Navigator.of(context).pop(_construirCobros()) : null,
          child: const Text('Confirmar cobro'),
        ),
      ],
    );
  }

  bool _puedeConfirmar() {
    if (!widget.haySesionCaja && _tab != _MetodoTab.tarjeta) return false;
    switch (_tab) {
      case _MetodoTab.efectivo:
        final recibido = parseCentavosDesdeTexto(_efectivoRecibidoController.text) ?? 0;
        return recibido >= widget.totalCentavos;
      case _MetodoTab.tarjeta:
        return true;
      case _MetodoTab.mixto:
        final efectivo = parseCentavosDesdeTexto(_mixtoEfectivoController.text) ?? 0;
        final tarjeta = parseCentavosDesdeTexto(_mixtoTarjetaController.text) ?? 0;
        return efectivo >= 0 && tarjeta >= 0 && efectivo + tarjeta == widget.totalCentavos;
    }
  }

  List<Cobro> _construirCobros() {
    switch (_tab) {
      case _MetodoTab.efectivo:
        return [Cobro(metodo: MetodoPago.efectivo, montoCentavos: widget.totalCentavos)];
      case _MetodoTab.tarjeta:
        return [Cobro(metodo: MetodoPago.tarjeta, montoCentavos: widget.totalCentavos)];
      case _MetodoTab.mixto:
        final efectivo = parseCentavosDesdeTexto(_mixtoEfectivoController.text) ?? 0;
        final tarjeta = parseCentavosDesdeTexto(_mixtoTarjetaController.text) ?? 0;
        return [
          if (efectivo > 0) Cobro(metodo: MetodoPago.efectivo, montoCentavos: efectivo),
          if (tarjeta > 0) Cobro(metodo: MetodoPago.tarjeta, montoCentavos: tarjeta),
        ];
    }
  }
}

class _AvisoSinCaja extends StatelessWidget {
  const _AvisoSinCaja();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text('Necesitas abrir la caja para cobrar en efectivo. Puedes cobrar con tarjeta mientras tanto.'),
          ),
        ],
      ),
    );
  }
}

const _denominaciones = [5000, 10000, 20000, 50000];

class _EfectivoPanel extends StatelessWidget {
  const _EfectivoPanel({
    required this.totalCentavos,
    required this.recibidoController,
    required this.onDenominacion,
    required this.onExacto,
    required this.onChanged,
  });

  final int totalCentavos;
  final TextEditingController recibidoController;
  final ValueChanged<int> onDenominacion;
  final VoidCallback onExacto;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final recibido = parseCentavosDesdeTexto(recibidoController.text) ?? 0;
    final cambio = recibido - totalCentavos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: recibidoController,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Efectivo recibido', prefixText: r'$'),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final denominacion in _denominaciones)
              OutlinedButton(
                onPressed: () => onDenominacion(denominacion),
                child: Text(formatCentavos(denominacion)),
              ),
            OutlinedButton(onPressed: onExacto, child: const Text('Exacto')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Cambio a entregar', style: TextStyle(fontSize: 16)),
            MoneyDisplay(
              cambio < 0 ? 0 : cambio,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: cambio < 0 ? Colors.black26 : Colors.green.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TarjetaPanel extends StatelessWidget {
  const _TarjetaPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.credit_card, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Confirma el cobro en la terminal bancaria. Una vez aprobado, presiona "Confirmar cobro".',
            ),
          ),
        ],
      ),
    );
  }
}

class _MixtoPanel extends StatelessWidget {
  const _MixtoPanel({
    required this.totalCentavos,
    required this.efectivoController,
    required this.tarjetaController,
    required this.onChanged,
  });

  final int totalCentavos;
  final TextEditingController efectivoController;
  final TextEditingController tarjetaController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final efectivo = parseCentavosDesdeTexto(efectivoController.text) ?? 0;
    final tarjeta = parseCentavosDesdeTexto(tarjetaController.text) ?? 0;
    final restante = totalCentavos - efectivo - tarjeta;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: efectivoController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Monto en efectivo', prefixText: r'$'),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: tarjetaController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Monto en tarjeta', prefixText: r'$'),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 12),
        Text(
          restante == 0
              ? 'Los montos cubren el total exacto.'
              : 'Falta ${formatCentavos(restante)} para cubrir el total.',
          style: TextStyle(color: restante == 0 ? Colors.green.shade700 : Colors.red.shade700),
        ),
      ],
    );
  }
}
