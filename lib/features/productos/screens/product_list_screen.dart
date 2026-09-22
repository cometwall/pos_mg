import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/producto_repository.dart';
import '../../../shared/widgets/money_display.dart';

final _productosActivosProvider = FutureProvider<List<ProductoData>>(
  (ref) => ref.watch(productoRepositoryProvider).listarActivos(),
);

final _categoriasProvider = FutureProvider<List<CategoriaData>>(
  (ref) => ref.watch(categoriaRepositoryProvider).listarTodas(),
);

final _tiposEnvaseProvider = FutureProvider<List<TipoEnvaseData>>(
  (ref) => ref.watch(tipoEnvaseRepositoryProvider).listarActivos(),
);

/// Catálogo de productos: alta y listado. Menor riesgo de UX que Ventas
/// (es un CRUD real de catálogo, no un caso de uso operativo).
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productosAsync = ref.watch(_productosActivosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormularioNuevoProducto(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
      body: productosAsync.when(
        data: (productos) {
          if (productos.isEmpty) {
            return const Center(child: Text('Sin productos todavía'));
          }
          return ListView.separated(
            itemCount: productos.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final producto = productos[index];
              final precioTexto = producto.unidad == 'peso' ? '/kg' : '';
              return ListTile(
                title: Text(producto.nombre),
                subtitle: Text(
                  '${producto.codigoInterno}'
                  '${producto.codigoBarras != null ? ' · ${producto.codigoBarras}' : ''}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MoneyDisplay(producto.precioVentaCentavos),
                    Text(precioTexto, style: const TextStyle(color: Colors.black45)),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _abrirFormularioNuevoProducto(BuildContext context, WidgetRef ref) async {
    final categorias = await ref.read(_categoriasProvider.future);
    final tiposEnvase = await ref.read(_tiposEnvaseProvider.future);
    if (!context.mounted) return;

    final nombreController = TextEditingController();
    final codigoInternoController = TextEditingController();
    final codigoBarrasController = TextEditingController();
    final precioController = TextEditingController();
    var unidad = UnidadProducto.pieza;
    int? categoriaId;
    int? tipoEnvaseId;

    final crear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Nuevo producto'),
              content: SizedBox(
                width: 360,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: nombreController,
                        autofocus: true,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                      ),
                      TextField(
                        controller: codigoInternoController,
                        decoration: const InputDecoration(labelText: 'Código interno'),
                      ),
                      TextField(
                        controller: codigoBarrasController,
                        decoration: const InputDecoration(labelText: 'Código de barras (opcional)'),
                      ),
                      DropdownButtonFormField<UnidadProducto>(
                        initialValue: unidad,
                        decoration: const InputDecoration(labelText: 'Unidad'),
                        items: const [
                          DropdownMenuItem(value: UnidadProducto.pieza, child: Text('Pieza')),
                          DropdownMenuItem(value: UnidadProducto.peso, child: Text('Peso (kg)')),
                        ],
                        onChanged: (valor) => setState(() => unidad = valor!),
                      ),
                      TextField(
                        controller: precioController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: unidad == UnidadProducto.peso
                              ? 'Precio por kilogramo'
                              : 'Precio de venta',
                          prefixText: r'$',
                        ),
                      ),
                      if (categorias.isNotEmpty)
                        DropdownButtonFormField<int?>(
                          initialValue: categoriaId,
                          decoration: const InputDecoration(labelText: 'Categoría (opcional)'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('—')),
                            for (final categoria in categorias)
                              DropdownMenuItem(value: categoria.id, child: Text(categoria.nombre)),
                          ],
                          onChanged: (valor) => setState(() => categoriaId = valor),
                        ),
                      if (tiposEnvase.isNotEmpty)
                        DropdownButtonFormField<int?>(
                          initialValue: tipoEnvaseId,
                          decoration: const InputDecoration(labelText: 'Tipo de envase (opcional)'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('—')),
                            for (final tipo in tiposEnvase)
                              DropdownMenuItem(value: tipo.id, child: Text(tipo.nombre)),
                          ],
                          onChanged: (valor) => setState(() => tipoEnvaseId = valor),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Crear'),
                ),
              ],
            );
          },
        );
      },
    );

    if (crear != true) return;
    final precio = double.tryParse(precioController.text.replaceAll(',', '.'));
    if (nombreController.text.trim().isEmpty ||
        codigoInternoController.text.trim().isEmpty ||
        precio == null ||
        precio < 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Completa nombre, código interno y precio')));
      }
      return;
    }

    try {
      await ref.read(productoRepositoryProvider).crear(
        nombre: nombreController.text.trim(),
        codigoInterno: codigoInternoController.text.trim(),
        codigoBarras: codigoBarrasController.text.trim().isEmpty
            ? null
            : codigoBarrasController.text.trim(),
        unidad: unidad,
        precioVentaCentavos: (precio * 100).round(),
        categoriaId: categoriaId,
        tipoEnvaseId: tipoEnvaseId,
      );
      ref.invalidate(_productosActivosProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo crear: $e')));
      }
    }
  }
}
