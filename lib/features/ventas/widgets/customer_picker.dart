import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../database/app_database.dart';
import '../controllers/sale_cart_controller.dart';

/// Botón/chip para asociar un cliente a la venta en progreso. No
/// interrumpe el flujo de venta rápida: sin cliente, no se muestra nada
/// más que un texto secundario para abrirlo cuando haga falta.
class CustomerPicker extends ConsumerWidget {
  const CustomerPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carrito = ref.watch(saleCartControllerProvider);

    if (carrito.clienteId == null) {
      return TextButton.icon(
        onPressed: () => _abrirSelector(context, ref),
        icon: const Icon(Icons.person_add_alt_outlined, size: 18),
        label: const Text('Asociar cliente (opcional)'),
      );
    }

    return Chip(
      avatar: const Icon(Icons.person, size: 18),
      label: Text(carrito.clienteNombre ?? 'Cliente'),
      onDeleted: () => ref.read(saleCartControllerProvider.notifier).quitarCliente(),
    );
  }

  Future<void> _abrirSelector(BuildContext context, WidgetRef ref) async {
    final seleccionado = await showDialog<ClienteData>(
      context: context,
      builder: (_) => const _CustomerPickerDialog(),
    );
    if (seleccionado != null) {
      ref
          .read(saleCartControllerProvider.notifier)
          .asociarCliente(id: seleccionado.id, nombre: seleccionado.nombre);
    }
  }
}

class _CustomerPickerDialog extends ConsumerStatefulWidget {
  const _CustomerPickerDialog();

  @override
  ConsumerState<_CustomerPickerDialog> createState() => _CustomerPickerDialogState();
}

class _CustomerPickerDialogState extends ConsumerState<_CustomerPickerDialog> {
  final _busqueda = TextEditingController();
  String _texto = '';

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Asociar cliente'),
      content: SizedBox(
        width: 360,
        height: 360,
        child: Column(
          children: [
            TextField(
              controller: _busqueda,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Buscar cliente por nombre',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (texto) => setState(() => _texto = texto),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<ClienteData>>(
                future: ref.read(clienteRepositoryProvider).buscarPorNombre(_texto),
                builder: (context, snapshot) {
                  final clientes = snapshot.data ?? const [];
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (clientes.isEmpty) {
                    return const Center(child: Text('Sin coincidencias'));
                  }
                  return ListView.builder(
                    itemCount: clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clientes[index];
                      return ListTile(
                        title: Text(cliente.nombre),
                        subtitle: cliente.telefono != null ? Text(cliente.telefono!) : null,
                        onTap: () => Navigator.of(context).pop(cliente),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _crearClienteNuevo(context),
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('Crear cliente nuevo'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  Future<void> _crearClienteNuevo(BuildContext context) async {
    final nombreController = TextEditingController(text: _texto);
    final telefonoController = TextEditingController();

    final crear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nuevo cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono (opcional)'),
              ),
            ],
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

    if (crear != true || nombreController.text.trim().isEmpty) return;
    if (!context.mounted) return;

    final id = await ref.read(clienteRepositoryProvider).crear(
      nombre: nombreController.text.trim(),
      telefono: telefonoController.text.trim().isEmpty ? null : telefonoController.text.trim(),
    );
    if (!context.mounted) return;
    Navigator.of(context).pop(
      ClienteData(
        id: id,
        nombre: nombreController.text.trim(),
        telefono: telefonoController.text.trim().isEmpty ? null : telefonoController.text.trim(),
        activo: 1,
        creadoEn: DateTime.now().toIso8601String(),
      ),
    );
  }
}
