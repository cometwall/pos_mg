import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session_providers.dart';
import '../../../core/money.dart';
import '../../../core/quantity.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/compra_repository.dart';
import '../../../shared/widgets/money_display.dart';
import '../controllers/compra_controllers.dart';

class _ItemCompraUi {
  const _ItemCompraUi({
    required this.productoId,
    required this.nombre,
    required this.esPorPeso,
    required this.cantidad,
    required this.costoUnitarioCentavos,
  });

  final int productoId;
  final String nombre;

  /// `false` = pieza (cantidad en piezas). `true` = peso (cantidad en
  /// GRAMOS; `costoUnitarioCentavos` es el costo por KILOGRAMO que
  /// escribió el cajero, no por gramo — igual convención que
  /// `SaleCartLine` en Ventas).
  final bool esPorPeso;

  final int cantidad;
  final int costoUnitarioCentavos;

  int get subtotalCentavos => esPorPeso
      ? subtotalPorPeso(precioPorKiloCentavos: costoUnitarioCentavos, gramos: cantidad)
      : cantidad * costoUnitarioCentavos;
}

/// Alta de una compra a proveedor: cabecera + líneas, todo en una
/// transacción atómica (`CompraRepository.registrarCompra`).
class NewCompraScreen extends ConsumerStatefulWidget {
  const NewCompraScreen({super.key});

  @override
  ConsumerState<NewCompraScreen> createState() => _NewCompraScreenState();
}

class _NewCompraScreenState extends ConsumerState<NewCompraScreen> {
  int? _proveedorId;
  final _items = <_ItemCompraUi>[];
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final proveedoresAsync = ref.watch(proveedoresProvider);
    final total = _items.fold<int>(0, (acc, item) => acc + item.subtotalCentavos);

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva compra')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            proveedoresAsync.when(
              data: (proveedores) => Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: _proveedorId,
                      decoration: const InputDecoration(labelText: 'Proveedor'),
                      items: [
                        for (final proveedor in proveedores)
                          DropdownMenuItem(value: proveedor.id, child: Text(proveedor.nombre)),
                      ],
                      onChanged: (valor) => setState(() => _proveedorId = valor),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: 'Nuevo proveedor',
                    onPressed: _crearProveedor,
                  ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (error, _) => Text('Error: $error'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Productos', style: TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton.icon(
                  onPressed: _agregarItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar producto'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Sin productos agregados'))
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        final cantidadTexto = item.esPorPeso
                            ? '${gramosAKilogramos(item.cantidad).toStringAsFixed(3)} kg'
                            : '${item.cantidad}';
                        final costoTexto = item.esPorPeso
                            ? '${formatCentavos(item.costoUnitarioCentavos)}/kg'
                            : formatCentavos(item.costoUnitarioCentavos);
                        return ListTile(
                          title: Text(item.nombre),
                          subtitle: Text('$cantidadTexto x $costoTexto'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MoneyDisplay(item.subtotalCentavos),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => setState(() => _items.removeAt(index)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                MoneyDisplay(total, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _proveedorId != null && _items.isNotEmpty && !_guardando
                  ? _registrarCompra
                  : null,
              child: _guardando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Registrar compra'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _crearProveedor() async {
    final nombreController = TextEditingController();
    final crear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuevo proveedor'),
        content: TextField(
          controller: nombreController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nombre'),
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
      ),
    );
    if (crear != true || nombreController.text.trim().isEmpty) return;
    final id = await ref.read(proveedorRepositoryProvider).crear(nombre: nombreController.text.trim());
    ref.invalidate(proveedoresProvider);
    setState(() => _proveedorId = id);
  }

  Future<void> _agregarItem() async {
    final busquedaController = TextEditingController();
    final cantidadController = TextEditingController(text: '1');
    final costoController = TextEditingController();
    ProductoData? seleccionado;

    final agregar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Agregar producto'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: busquedaController,
                      autofocus: true,
                      decoration: const InputDecoration(labelText: 'Buscar producto'),
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(
                      height: 160,
                      child: RadioGroup<ProductoData>(
                        groupValue: seleccionado,
                        onChanged: (valor) => setState(() => seleccionado = valor),
                        child: FutureBuilder<List<ProductoData>>(
                          future: ref
                              .read(productoRepositoryProvider)
                              .buscar(busquedaController.text),
                          builder: (context, snapshot) {
                            final productos = snapshot.data ?? const [];
                            return ListView.builder(
                              itemCount: productos.length,
                              itemBuilder: (context, index) {
                                final producto = productos[index];
                                return RadioListTile<ProductoData>(
                                  dense: true,
                                  title: Text(producto.nombre),
                                  value: producto,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    TextField(
                      controller: cantidadController,
                      keyboardType: seleccionado?.unidad == 'peso'
                          ? const TextInputType.numberWithOptions(decimal: true)
                          : TextInputType.number,
                      decoration: InputDecoration(
                        labelText: seleccionado?.unidad == 'peso' ? 'Cantidad (kg)' : 'Cantidad (piezas)',
                      ),
                    ),
                    TextField(
                      controller: costoController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: seleccionado?.unidad == 'peso'
                            ? 'Costo por kilogramo'
                            : 'Costo unitario',
                        prefixText: r'$',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (agregar != true || seleccionado == null) return;
    final esPorPeso = seleccionado!.unidad == 'peso';
    final costo = parseCentavosDesdeTexto(costoController.text);

    int? cantidad;
    if (esPorPeso) {
      final kilos = double.tryParse(cantidadController.text.replaceAll(',', '.'));
      if (kilos != null && kilos > 0) cantidad = kilogramosAGramos(kilos);
    } else {
      cantidad = int.tryParse(cantidadController.text);
    }

    if (cantidad == null || cantidad <= 0 || costo == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cantidad y costo son obligatorios')));
      }
      return;
    }

    setState(() {
      _items.add(
        _ItemCompraUi(
          productoId: seleccionado!.id,
          nombre: seleccionado!.nombre,
          esPorPeso: esPorPeso,
          cantidad: cantidad!,
          costoUnitarioCentavos: costo,
        ),
      );
    });
  }

  Future<void> _registrarCompra() async {
    setState(() => _guardando = true);
    try {
      final terminal = await ref.read(currentTerminalProvider.future);
      final usuario = await ref.read(currentUsuarioProvider.future);
      final sesion = ref.read(sesionCajaAbiertaProvider).value;
      final folio = 'C${DateTime.now().microsecondsSinceEpoch}';

      await ref.read(compraRepositoryProvider).registrarCompra(
        terminalId: terminal.id,
        folio: folio,
        proveedorId: _proveedorId!,
        usuarioId: usuario.id,
        cajaSesionId: sesion?.id,
        items: [
          for (final item in _items)
            ItemCompra(
              productoId: item.productoId,
              cantidad: item.cantidad,
              // Igual convención que en Ventas: para peso, `cantidad` son
              // gramos, así que el costo guardado por unidad debe ser por
              // gramo (no por kilogramo); el subtotal real ya viene
              // calculado con precisión aparte.
              costoUnitarioCentavos: item.esPorPeso
                  ? item.costoUnitarioCentavos ~/ 1000
                  : item.costoUnitarioCentavos,
              subtotalCentavos: item.subtotalCentavos,
            ),
        ],
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No se pudo registrar la compra: $e')));
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }
}
