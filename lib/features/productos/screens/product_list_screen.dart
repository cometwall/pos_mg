import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/quantity.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/producto_repository.dart';
import '../../../shared/widgets/money_display.dart';
import '../controllers/producto_stock_provider.dart';

final productosActivosProvider = StreamProvider<List<ProductoData>>(
  (ref) => ref.watch(productoRepositoryProvider).observarActivos(),
);

final _categoriasProvider = FutureProvider<List<CategoriaData>>(
  (ref) => ref.watch(categoriaRepositoryProvider).listarTodas(),
);

final _tiposEnvaseProvider = FutureProvider<List<TipoEnvaseData>>(
  (ref) => ref.watch(tipoEnvaseRepositoryProvider).listarActivos(),
);

/// Catálogo de productos: alta, edición y listado (con stock actual de
/// cada uno). Menor riesgo de UX que Ventas (es un CRUD real de
/// catálogo, no un caso de uso operativo).
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productosAsync = ref.watch(productosActivosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'productos_fab',
        onPressed: () => _abrirFormularioProducto(context, ref),
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
            itemBuilder: (context, index) => _ProductoTile(producto: productos[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ProductoTile extends ConsumerWidget {
  const _ProductoTile({required this.producto});

  final ProductoData producto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esPorPeso = producto.unidad == 'peso';
    final saldoAsync = ref.watch(productoStockProvider(producto.id));
    final precioTexto = esPorPeso ? '/kg' : '';

    return ListTile(
      title: Text(producto.nombre),
      subtitle: Text(
        '${producto.codigoInterno}'
        '${producto.codigoBarras != null ? ' · ${producto.codigoBarras}' : ''}\n'
        'Stock: ${saldoAsync.when(
          data: (saldo) => formatearStock(esPorPeso: esPorPeso, cantidad: saldo),
          loading: () => '…',
          error: (_, _) => '?',
        )}',
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MoneyDisplay(producto.precioVentaCentavos),
          Text(precioTexto, style: const TextStyle(color: Colors.black45)),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => _abrirFormularioProducto(context, ref, existente: producto),
          ),
        ],
      ),
    );
  }
}

Future<void> _abrirFormularioProducto(
  BuildContext context,
  WidgetRef ref, {
  ProductoData? existente,
}) async {
  final categorias = await ref.read(_categoriasProvider.future);
  final tiposEnvase = await ref.read(_tiposEnvaseProvider.future);
  if (!context.mounted) return;

  final esEdicion = existente != null;
  final nombreController = TextEditingController(text: existente?.nombre ?? '');
  final codigoInternoController = TextEditingController(text: existente?.codigoInterno ?? '');
  final codigoBarrasController = TextEditingController(text: existente?.codigoBarras ?? '');
  final precioController = TextEditingController(
    text: existente != null ? (existente.precioVentaCentavos / 100).toStringAsFixed(2) : '',
  );
  var unidad = existente != null
      ? UnidadProducto.desdeDb(existente.unidad)
      : UnidadProducto.pieza;
  int? categoriaId = existente?.categoriaId;
  int? tipoEnvaseId = existente?.tipoEnvaseId;

  final confirmar = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(esEdicion ? 'Editar producto' : 'Nuevo producto'),
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
                child: Text(esEdicion ? 'Guardar' : 'Crear'),
              ),
            ],
          );
        },
      );
    },
  );

  if (confirmar != true) return;
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
    final repo = ref.read(productoRepositoryProvider);
    if (esEdicion) {
      await repo.actualizar(
        id: existente.id,
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
    } else {
      await repo.crear(
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
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo guardar: $e')));
    }
  }
}
