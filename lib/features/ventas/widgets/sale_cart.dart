import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/money_display.dart';
import '../../../shared/widgets/quantity_editor.dart';
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
          if (linea.tipoEnvaseId != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: InkWell(
                onTap: () => EnvaseDialog.show(
                  context,
                  tipoEnvaseId: linea.tipoEnvaseId!,
                  cantidadSugerida: linea.esPorPeso ? 1 : linea.cantidad,
                  hayCliente: hayCliente,
                  inicial: linea.operacionEnvase,
                  onGuardar: (operacion) =>
                      controller.configurarEnvase(linea.productoId, operacion),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.liquor_outlined,
                      size: 16,
                      color: linea.operacionEnvase != null ? Colors.blue.shade700 : Colors.black38,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      linea.operacionEnvase == null
                          ? 'Configurar envase'
                          : linea.operacionEnvase!.tipo.name == 'depositoCobrado'
                          ? 'Depósito: ${linea.operacionEnvase!.cantidad} envases'
                          : 'Préstamo: ${linea.operacionEnvase!.cantidad} envases',
                      style: TextStyle(
                        fontSize: 12,
                        color: linea.operacionEnvase != null
                            ? Colors.blue.shade700
                            : Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
