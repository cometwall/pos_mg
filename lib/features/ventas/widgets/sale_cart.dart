import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/repositories/envase_repository.dart';
import '../../../shared/widgets/money_display.dart';
import '../../../shared/widgets/quantity_editor.dart';
import '../../productos/controllers/producto_stock_provider.dart';
import '../controllers/sale_cart_controller.dart';
import '../models/sale_cart_line.dart';
import 'envase_dialog.dart';

/// Lista de líneas del carrito en progreso.
class SaleCart extends ConsumerWidget {
  const SaleCart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lineas = ref.watch(saleCartControllerProvider).lineas;

    if (lineas.isEmpty) {
      return const Center(
        child: Text('El carrito está vacío', style: TextStyle(color: Colors.black45)),
      );
    }

    return ListView.separated(
      itemCount: lineas.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _SaleCartTile(linea: lineas[index]),
    );
  }
}

class _SaleCartTile extends ConsumerWidget {
  const _SaleCartTile({required this.linea});

  final SaleCartLine linea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(saleCartControllerProvider.notifier);
    final hayCliente = ref.watch(saleCartControllerProvider).clienteId != null;
    final stockDisponible = ref.watch(productoStockProvider(linea.productoId)).value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(linea.nombre, style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
              QuantityEditor(
                esPorPeso: linea.esPorPeso,
                cantidadGramosOPiezas: linea.cantidad,
                stockDisponible: stockDisponible,
                onChanged: (nuevaCantidad) =>
                    controller.actualizarCantidad(linea.productoId, nuevaCantidad),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 72,
                child: MoneyDisplay(
                  linea.subtotalCentavos,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                visualDensity: VisualDensity.compact,
                tooltip: 'Quitar',
                onPressed: () => controller.eliminarLinea(linea.productoId),
              ),
            ],
          ),
          if (linea.tipoEnvaseId != null) _EnvaseResumen(linea: linea, hayCliente: hayCliente),
        ],
      ),
    );
  }
}

String _etiquetaCorta(TipoOperacionEnvase tipo) => switch (tipo) {
  TipoOperacionEnvase.depositoCobrado => 'Depósito',
  TipoOperacionEnvase.prestado => 'Préstamo',
  TipoOperacionEnvase.entregado => 'Entregado',
  TipoOperacionEnvase.recibido => 'Recibido',
};

/// Link "Configurar envase" bajo una línea del carrito, con el resumen de
/// lo ya configurado. Si la línea creció de cantidad después de
/// configurarse (el diálogo solo se abre solo una vez, al crear la
/// línea — ver `product_search.dart`), la cobertura puede quedar
/// desactualizada; en vez de forzar el diálogo en cada clic, esto lo
/// señala en ámbar directamente en el resumen para que el cajero lo note
/// sin tener que abrirlo.
class _EnvaseResumen extends ConsumerWidget {
  const _EnvaseResumen({required this.linea, required this.hayCliente});

  final SaleCartLine linea;
  final bool hayCliente;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Igual que `cantidadSugerida` en las dos llamadas a `EnvaseDialog`:
    // para productos por peso, el objetivo son envases discretos (1),
    // no los gramos vendidos.
    final objetivo = linea.esPorPeso ? 1 : linea.cantidad;
    final cubiertas = linea.operacionesEnvase
        .where((o) => o.tipo != TipoOperacionEnvase.recibido)
        .fold<int>(0, (acc, o) => acc + o.cantidad);
    final sinConfigurar = linea.operacionesEnvase.isEmpty;
    final desactualizada = !sinConfigurar && cubiertas != objetivo;

    final color = sinConfigurar
        ? Colors.black38
        : desactualizada
        ? Colors.amber.shade800
        : Colors.blue.shade700;

    final resumen = linea.operacionesEnvase
        .map((o) => '${_etiquetaCorta(o.tipo)}: ${o.cantidad}')
        .join(' · ');
    final texto = sinConfigurar
        ? 'Configurar envase'
        : desactualizada
        ? '$resumen (cubre $cubiertas de $objetivo)'
        : resumen;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: InkWell(
        onTap: () => EnvaseDialog.show(
          context,
          tipoEnvaseId: linea.tipoEnvaseId!,
          cantidadSugerida: objetivo,
          hayCliente: hayCliente,
          inicial: linea.operacionesEnvase,
          onGuardar: (operaciones) => ref
              .read(saleCartControllerProvider.notifier)
              .configurarEnvase(linea.productoId, operaciones),
        ),
        child: Row(
          children: [
            Icon(Icons.liquor_outlined, size: 16, color: color),
            const SizedBox(width: 4),
            Text(texto, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}
