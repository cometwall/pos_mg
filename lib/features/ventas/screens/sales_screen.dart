import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/session_providers.dart';
import '../../../shared/widgets/cash_session_status_badge.dart';
import '../controllers/sale_cart_controller.dart';
import '../controllers/sale_checkout_controller.dart';
import '../widgets/customer_picker.dart';
import '../widgets/payment_dialog.dart';
import '../widgets/sale_cart.dart';
import '../widgets/sale_completed_panel.dart';
import '../widgets/sale_summary.dart';
import '../widgets/product_search.dart';

/// Pantalla de venta rápida — home del POS. Buscar/agregar productos,
/// ver el carrito y el total siempre visibles; cliente y cobro solo
/// aparecen cuando el cajero los pide.
class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final _searchFocusNode = FocusNode();
  CheckoutExitoso? _ultimaVentaCompletada;
  bool _cobrando = false;

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: const [CashSessionStatusBadge(), SizedBox(width: 8)],
      ),
      body: Focus(
        autofocus: true,
        onKeyEvent: _onKeyEvent,
        child: _ultimaVentaCompletada != null
            ? SaleCompletedPanel(
                folio: _ultimaVentaCompletada!.folio,
                totalCentavos: _ultimaVentaCompletada!.totalCentavos,
                onNuevaVenta: _nuevaVenta,
              )
            : _VentaEnProgreso(
                searchFocusNode: _searchFocusNode,
                cobrando: _cobrando,
                onCobrar: _cobrar,
              ),
      ),
    );
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (_ultimaVentaCompletada != null) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _nuevaVenta();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.f9) {
      _cobrar();
      return KeyEventResult.handled;
    }
    if (HardwareKeyboard.instance.isControlPressed &&
        event.logicalKey == LogicalKeyboardKey.keyN) {
      _forzarNuevaVenta();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _nuevaVenta() {
    setState(() => _ultimaVentaCompletada = null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  Future<void> _forzarNuevaVenta() async {
    final carrito = ref.read(saleCartControllerProvider);
    if (carrito.estaVacio) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Descartar venta actual?'),
        content: const Text('El carrito tiene productos sin cobrar. Se perderán.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Descartar')),
        ],
      ),
    );
    if (confirmar == true) {
      ref.read(saleCartControllerProvider.notifier).limpiar();
    }
  }

  Future<void> _cobrar() async {
    final carrito = ref.read(saleCartControllerProvider);
    if (carrito.estaVacio || _cobrando) return;

    final sesion = ref.read(sesionCajaAbiertaProvider).value;
    final cobros = await PaymentDialog.show(
      context,
      productoCentavos: carrito.subtotalCentavos,
      depositoCentavos: carrito.depositoEnvaseCentavos,
      haySesionCaja: sesion != null,
    );
    if (cobros == null || !mounted) return;

    setState(() => _cobrando = true);
    try {
      final terminal = await ref.read(currentTerminalProvider.future);
      final usuario = await ref.read(currentUsuarioProvider.future);
      final resultado = await ref.read(saleCheckoutServiceProvider).cobrar(
        terminalId: terminal.id,
        usuarioId: usuario.id,
        cajaSesionId: sesion?.id,
        clienteId: carrito.clienteId,
        lineas: carrito.lineas,
        cobros: cobros,
      );
      if (!mounted) return;

      switch (resultado) {
        case CheckoutExitoso():
          ref.read(saleCartControllerProvider.notifier).limpiar();
          setState(() => _ultimaVentaCompletada = resultado);
        case CheckoutFallido(:final mensaje):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(mensaje), backgroundColor: Colors.red.shade700),
          );
      }
    } finally {
      if (mounted) setState(() => _cobrando = false);
    }
  }
}

class _VentaEnProgreso extends ConsumerWidget {
  const _VentaEnProgreso({
    required this.searchFocusNode,
    required this.cobrando,
    required this.onCobrar,
  });

  final FocusNode searchFocusNode;
  final bool cobrando;
  final VoidCallback onCobrar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carrito = ref.watch(saleCartControllerProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ProductSearch(focusNode: searchFocusNode),
          ),
        ),
        const VerticalDivider(width: 1),
        SizedBox(
          width: 380,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Carrito', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const Spacer(),
                    const Text('Ctrl+N', style: TextStyle(color: Colors.black38, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                const Expanded(child: SaleCart()),
                const Divider(),
                const CustomerPicker(),
                const SizedBox(height: 8),
                SaleSummary(
                  subtotalCentavos: carrito.subtotalCentavos,
                  depositoEnvaseCentavos: carrito.depositoEnvaseCentavos,
                  totalCentavos: carrito.subtotalCentavos + carrito.depositoEnvaseCentavos,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: carrito.estaVacio || cobrando ? null : onCobrar,
                  child: cobrando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('COBRAR  (F9)'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
