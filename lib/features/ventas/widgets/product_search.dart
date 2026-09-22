import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money.dart';
import '../../../core/quantity.dart';
import '../../../database/app_database.dart';
import '../controllers/sale_cart_controller.dart';

/// Buscador de producto + resultados en vivo. Con texto exacto de código
/// de barras y un único resultado, agrega directo al carrito (soporte de
/// lector de código de barras: escribe rápido y termina en Enter).
class ProductSearch extends ConsumerStatefulWidget {
  const ProductSearch({super.key, this.focusNode});

  final FocusNode? focusNode;

  @override
  ConsumerState<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends ConsumerState<ProductSearch> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String texto) {
    ref.read(busquedaProductoProvider.notifier).actualizar(texto);
  }

  Future<void> _onSubmitted(String texto) async {
    final resultados = await ref.read(resultadosBusquedaProductoProvider.future);
    if (!mounted) return;
    if (texto.trim().isNotEmpty && resultados.length == 1) {
      await _agregarProducto(resultados.first);
    }
  }

  Future<void> _agregarProducto(ProductoData producto) async {
    if (producto.unidad == 'peso') {
      final gramos = await _pedirCantidadPeso(producto);
      if (gramos == null) return;
      ref
          .read(saleCartControllerProvider.notifier)
          .agregarProducto(producto, cantidadInicial: gramos);
    } else {
      ref
          .read(saleCartControllerProvider.notifier)
          .agregarProducto(producto, cantidadInicial: 1);
    }
    _controller.clear();
    ref.read(busquedaProductoProvider.notifier).actualizar('');
  }

  Future<int?> _pedirCantidadPeso(ProductoData producto) {
    final kilosController = TextEditingController(text: '0.500');
    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(producto.nombre),
          content: TextField(
            controller: kilosController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: InputDecoration(
              suffixText: 'kg',
              helperText: 'Precio: ${formatCentavos(producto.precioVentaCentavos)}/kg',
            ),
            onSubmitted: (texto) {
              final kilos = double.tryParse(texto.replaceAll(',', '.'));
              if (kilos != null && kilos > 0) {
                Navigator.of(dialogContext).pop(kilogramosAGramos(kilos));
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final kilos = double.tryParse(kilosController.text.replaceAll(',', '.'));
                if (kilos != null && kilos > 0) {
                  Navigator.of(dialogContext).pop(kilogramosAGramos(kilos));
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultadosAsync = ref.watch(resultadosBusquedaProductoProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          focusNode: widget.focusNode,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar producto o escanear código de barras',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: _onChanged,
          onSubmitted: _onSubmitted,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: resultadosAsync.when(
            data: (resultados) {
              if (resultados.isEmpty) {
                return const Center(child: Text('Sin resultados'));
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisExtent: 88,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final producto = resultados[index];
                  return _ProductoCard(
                    producto: producto,
                    onTap: () => _agregarProducto(producto),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error al buscar: $error')),
          ),
        ),
      ],
    );
  }
}

class _ProductoCard extends StatelessWidget {
  const _ProductoCard({required this.producto, required this.onTap});

  final ProductoData producto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final precioTexto = producto.unidad == 'peso'
        ? '${formatCentavos(producto.precioVentaCentavos)}/kg'
        : formatCentavos(producto.precioVentaCentavos);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                producto.nombre,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(precioTexto, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
