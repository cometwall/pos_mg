import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money.dart';
import '../../../core/quantity.dart';
import '../../../database/app_database.dart';
import '../../productos/controllers/producto_stock_provider.dart';
import '../controllers/sale_cart_controller.dart';
import 'envase_dialog.dart';

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
    final estadoPrevio = ref.read(saleCartControllerProvider);
    final yaEstabaEnCarrito = estadoPrevio.lineas.any((l) => l.productoId == producto.id);
    final cantidadEnCarrito = estadoPrevio.lineas
        .where((l) => l.productoId == producto.id)
        .fold<int>(0, (acc, l) => acc + l.cantidad);
    // `.value`: última lectura conocida del stock reactivo (puede ser
    // `null` mientras carga la primera vez). Sin dato, se deja pasar —
    // el checkeo servidor al cobrar (`StockInsuficienteException`) sigue
    // siendo la red de seguridad final.
    final stockDisponible = ref.read(productoStockProvider(producto.id)).value;

    final int cantidadInicial;
    if (producto.unidad == 'peso') {
      final gramos = await _pedirCantidadPeso(
        producto,
        stockDisponibleGramos: stockDisponible,
        gramosYaEnCarrito: cantidadEnCarrito,
      );
      if (gramos == null) return;
      cantidadInicial = gramos;
    } else {
      if (stockDisponible != null && cantidadEnCarrito >= stockDisponible) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sin stock disponible de ${producto.nombre}')),
          );
        }
        return;
      }
      cantidadInicial = 1;
    }
    if (!mounted) return;

    final controller = ref.read(saleCartControllerProvider.notifier);

    controller.agregarProducto(producto, cantidadInicial: cantidadInicial);
    _controller.clear();
    ref.read(busquedaProductoProvider.notifier).actualizar('');

    // Producto con envase, línea NUEVA: se pide resolverlo de inmediato
    // (depósito, préstamo, entrega o "sin operación") en vez de dejar un
    // link pequeño en el carrito que es fácil pasar por alto. Si el
    // producto YA estaba en el carrito, este clic es solo "sumar una
    // unidad más" — como con cualquier otro producto — y no reabre el
    // diálogo; si la cantidad nueva deja de coincidir con lo ya
    // configurado, el resumen de la línea en el carrito lo señala (ver
    // `sale_cart.dart`) y el cajero lo ajusta desde el link "Configurar
    // envase" cuando le convenga, no a la fuerza en cada clic.
    if (producto.tipoEnvaseId != null && !yaEstabaEnCarrito && mounted) {
      final estado = ref.read(saleCartControllerProvider);
      final linea = estado.lineas.firstWhere((l) => l.productoId == producto.id);
      final confirmado = await EnvaseDialog.show(
        context,
        tipoEnvaseId: producto.tipoEnvaseId!,
        cantidadSugerida: linea.esPorPeso ? 1 : linea.cantidad,
        hayCliente: estado.clienteId != null,
        inicial: linea.operacionesEnvase,
        onGuardar: (operaciones) => controller.configurarEnvase(producto.id, operaciones),
      );
      // Cancelar debe significar "no hacer nada": como esta línea es
      // nueva (ver la condición de arriba), se revierte el alta —
      // sobre todo para cuando el cajero quería prestar/cobrar depósito
      // pero canceló porque le faltó asociar un cliente.
      if (!confirmado && mounted) {
        controller.eliminarLinea(producto.id);
      }
    }
  }

  /// [stockDisponibleGramos] es el stock total del producto (`null` si
  /// todavía no se conoce). [gramosYaEnCarrito] es lo que esta misma
  /// línea ya tiene acumulado en el carrito — el máximo que se deja
  /// escribir aquí es la diferencia, no el stock total, porque
  /// `agregarProducto` suma esta cantidad a lo que ya había.
  Future<int?> _pedirCantidadPeso(
    ProductoData producto, {
    required int? stockDisponibleGramos,
    required int gramosYaEnCarrito,
  }) {
    final kilosController = TextEditingController(text: '0.500');
    final maximoGramos = stockDisponibleGramos == null
        ? null
        : (stockDisponibleGramos - gramosYaEnCarrito).clamp(0, stockDisponibleGramos);

    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        void confirmar() {
          final kilos = double.tryParse(kilosController.text.replaceAll(',', '.'));
          if (kilos == null || kilos <= 0) return;
          final gramos = kilogramosAGramos(kilos);
          if (maximoGramos != null && gramos > maximoGramos) {
            ScaffoldMessenger.of(dialogContext).showSnackBar(
              SnackBar(
                content: Text(
                  'Solo hay ${formatearStock(esPorPeso: true, cantidad: maximoGramos)} disponibles',
                ),
              ),
            );
            return;
          }
          Navigator.of(dialogContext).pop(gramos);
        }

        return AlertDialog(
          title: Text(producto.nombre),
          content: TextField(
            controller: kilosController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: InputDecoration(
              suffixText: 'kg',
              helperText: maximoGramos != null
                  ? 'Precio: ${formatCentavos(producto.precioVentaCentavos)}/kg · '
                        'Disponible: ${formatearStock(esPorPeso: true, cantidad: maximoGramos)}'
                  : 'Precio: ${formatCentavos(producto.precioVentaCentavos)}/kg',
            ),
            onSubmitted: (_) => confirmar(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(onPressed: confirmar, child: const Text('Agregar')),
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
                  mainAxisExtent: 104,
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

class _ProductoCard extends ConsumerWidget {
  const _ProductoCard({required this.producto, required this.onTap});

  final ProductoData producto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esPorPeso = producto.unidad == 'peso';
    final precioTexto = esPorPeso
        ? '${formatCentavos(producto.precioVentaCentavos)}/kg'
        : formatCentavos(producto.precioVentaCentavos);
    final saldoAsync = ref.watch(productoStockProvider(producto.id));
    final sinStock = saldoAsync.value == 0;

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
              Text(
                saldoAsync.when(
                  data: (saldo) => 'Stock: ${formatearStock(esPorPeso: esPorPeso, cantidad: saldo)}',
                  loading: () => 'Stock: …',
                  error: (_, _) => 'Stock: ?',
                ),
                style: TextStyle(
                  fontSize: 12,
                  color: sinStock ? Colors.red.shade600 : Colors.black45,
                  fontWeight: sinStock ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
