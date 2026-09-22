import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../database/app_database.dart';

final _clientesActivosProvider = FutureProvider<List<ClienteData>>(
  (ref) => ref.watch(clienteRepositoryProvider).listarActivos(),
);

/// Catálogo de clientes: alta y listado. La resolución de envases
/// prestados/depósitos pendientes por cliente (fuera del contexto de una
/// venta reciente) queda como extensión futura — ver riesgo M-3 de la
/// arquitectura aprobada, que requiere una consulta de agregación por
/// cliente que `CuentasQueries` todavía no expone.
class ClientListScreen extends ConsumerWidget {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientesAsync = ref.watch(_clientesActivosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormularioNuevoCliente(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo cliente'),
      ),
      body: clientesAsync.when(
        data: (clientes) {
          if (clientes.isEmpty) {
            return const Center(child: Text('Sin clientes todavía'));
          }
          return ListView.separated(
            itemCount: clientes.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cliente = clientes[index];
              return ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(cliente.nombre),
                subtitle: cliente.telefono != null ? Text(cliente.telefono!) : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _abrirFormularioNuevoCliente(BuildContext context, WidgetRef ref) async {
    final nombreController = TextEditingController();
    final telefonoController = TextEditingController();

    final crear = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
      ),
    );

    if (crear != true || nombreController.text.trim().isEmpty) return;

    await ref.read(clienteRepositoryProvider).crear(
      nombre: nombreController.text.trim(),
      telefono: telefonoController.text.trim().isEmpty ? null : telefonoController.text.trim(),
    );
    ref.invalidate(_clientesActivosProvider);
  }
}
