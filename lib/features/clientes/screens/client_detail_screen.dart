import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session_providers.dart';
import '../../../core/money.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/cuentas_queries.dart';
import '../../../database/repositories/envase_repository.dart';
import '../controllers/client_detail_controllers.dart';

/// Ficha de un cliente: envases prestados y depósitos pendientes en TODA
/// su historia (no atados a una venta puntual), con acciones para
/// resolverlos directamente desde aquí.
class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({super.key, required this.cliente});

  final ClienteData cliente;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prestamosAsync = ref.watch(envasesPendientesClienteProvider(cliente.id));
    final depositosAsync = ref.watch(depositosPendientesClienteProvider(cliente.id));

    return Scaffold(
      appBar: AppBar(title: Text(cliente.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (cliente.telefono != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(cliente.telefono!, style: const TextStyle(color: Colors.black54)),
            ),
          const Text('Envases prestados pendientes', style: TextStyle(fontWeight: FontWeight.w700)),
          const Divider(),
          prestamosAsync.when(
            data: (pendientes) => pendientes.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Sin préstamos pendientes', style: TextStyle(color: Colors.black45)),
                  )
                : Column(
                    children: [
                      for (final pendiente in pendientes)
                        _PrestamoTile(cliente: cliente, pendiente: pendiente),
                    ],
                  ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LinearProgressIndicator(),
            ),
            error: (error, _) => Text('Error: $error'),
          ),
          const SizedBox(height: 24),
          const Text('Depósitos pendientes', style: TextStyle(fontWeight: FontWeight.w700)),
          const Divider(),
          depositosAsync.when(
            data: (pendientes) => pendientes.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Sin depósitos pendientes', style: TextStyle(color: Colors.black45)),
                  )
                : Column(
                    children: [
                      for (final pendiente in pendientes)
                        _DepositoTile(cliente: cliente, pendiente: pendiente),
                    ],
                  ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LinearProgressIndicator(),
            ),
            error: (error, _) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}

class _PrestamoTile extends ConsumerWidget {
  const _PrestamoTile({required this.cliente, required this.pendiente});

  final ClienteData cliente;
  final PendienteEnvaseCliente pendiente;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreAsync = ref.watch(nombreTipoEnvaseProvider(pendiente.tipoEnvaseId));

    return ListTile(
      title: Text(nombreAsync.value ?? 'Envase #${pendiente.tipoEnvaseId}'),
      subtitle: Text('Pendientes: ${pendiente.cantidadPendiente} · Venta #${pendiente.ventaId}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => _devolverFisico(context, ref),
            child: const Text('Devolver físico'),
          ),
          TextButton(
            onPressed: () => _cobrarReposicion(context, ref),
            child: const Text('Cobrar reposición'),
          ),
        ],
      ),
    );
  }

  Future<void> _devolverFisico(BuildContext context, WidgetRef ref) async {
    final cantidad = await _pedirCantidad(
      context,
      titulo: 'Devolver envase',
      maximo: pendiente.cantidadPendiente,
    );
    if (cantidad == null) return;

    final usuario = await ref.read(currentUsuarioProvider.future);
    try {
      await ref
          .read(envaseRepositoryProvider)
          .devolverEnvasePrestado(
            ventaOriginalId: pendiente.ventaId,
            clienteId: cliente.id,
            tipoEnvaseId: pendiente.tipoEnvaseId,
            cantidad: cantidad,
            usuarioId: usuario.id,
          );
      ref.invalidate(envasesPendientesClienteProvider(cliente.id));
    } catch (e) {
      if (context.mounted) _mostrarError(context, e);
    }
  }

  Future<void> _cobrarReposicion(BuildContext context, WidgetRef ref) async {
    final sesion = ref.read(sesionCajaAbiertaProvider).value;
    if (sesion == null) {
      _mostrarError(context, 'Necesitas abrir la caja para cobrar una reposición en efectivo.');
      return;
    }

    final tipoEnvase = await ref.read(tipoEnvaseRepositoryProvider).obtenerPorId(pendiente.tipoEnvaseId);
    if (!context.mounted) return;

    final cantidadController = TextEditingController(text: '${pendiente.cantidadPendiente}');
    final montoController = TextEditingController(
      text: tipoEnvase?.valorReposicionCentavos != null
          ? ((tipoEnvase!.valorReposicionCentavos! * pendiente.cantidadPendiente) / 100)
                .toStringAsFixed(2)
          : '',
    );

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cobrar reposición'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            TextField(
              controller: montoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Monto total a cobrar', prefixText: r'$'),
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
            child: const Text('Cobrar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    final cantidad = int.tryParse(cantidadController.text);
    final monto = parseCentavosDesdeTexto(montoController.text);
    if (cantidad == null ||
        cantidad <= 0 ||
        cantidad > pendiente.cantidadPendiente ||
        monto == null) {
      if (context.mounted) {
        _mostrarError(context, 'Cantidad o monto inválido.');
      }
      return;
    }

    final usuario = await ref.read(currentUsuarioProvider.future);
    try {
      await ref
          .read(envaseRepositoryProvider)
          .pagarEnvasePrestado(
            ventaOriginalId: pendiente.ventaId,
            clienteId: cliente.id,
            tipoEnvaseId: pendiente.tipoEnvaseId,
            cantidad: cantidad,
            montoCentavos: monto,
            usuarioId: usuario.id,
            cajaSesionId: sesion.id,
          );
      ref.invalidate(envasesPendientesClienteProvider(cliente.id));
    } catch (e) {
      if (context.mounted) _mostrarError(context, e);
    }
  }
}

class _DepositoTile extends ConsumerWidget {
  const _DepositoTile({required this.cliente, required this.pendiente});

  final ClienteData cliente;
  final PendienteEnvaseCliente pendiente;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreAsync = ref.watch(nombreTipoEnvaseProvider(pendiente.tipoEnvaseId));

    return ListTile(
      title: Text(nombreAsync.value ?? 'Envase #${pendiente.tipoEnvaseId}'),
      subtitle: Text('Pendientes: ${pendiente.cantidadPendiente} · Venta #${pendiente.ventaId}'),
      trailing: TextButton(
        onPressed: () => _devolverDeposito(context, ref),
        child: const Text('Devolver depósito'),
      ),
    );
  }

  Future<void> _devolverDeposito(BuildContext context, WidgetRef ref) async {
    final sesion = ref.read(sesionCajaAbiertaProvider).value;
    if (sesion == null) {
      _mostrarError(context, 'Necesitas abrir la caja para devolver un depósito en efectivo.');
      return;
    }

    final cantidad = await _pedirCantidad(
      context,
      titulo: 'Devolver depósito',
      maximo: pendiente.cantidadPendiente,
    );
    if (cantidad == null) return;

    final usuario = await ref.read(currentUsuarioProvider.future);
    try {
      await ref
          .read(envaseRepositoryProvider)
          .devolverDeposito(
            ventaOriginalId: pendiente.ventaId,
            tipoEnvaseId: pendiente.tipoEnvaseId,
            cantidad: cantidad,
            usuarioId: usuario.id,
            cajaSesionId: sesion.id,
          );
      ref.invalidate(depositosPendientesClienteProvider(cliente.id));
    } catch (e) {
      if (context.mounted) _mostrarError(context, e);
    }
  }
}

Future<int?> _pedirCantidad(BuildContext context, {required String titulo, required int maximo}) {
  final controller = TextEditingController(text: '$maximo');
  return showDialog<int>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(titulo),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Cantidad (máximo $maximo)'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final cantidad = int.tryParse(controller.text);
            if (cantidad == null || cantidad <= 0 || cantidad > maximo) return;
            Navigator.of(dialogContext).pop(cantidad);
          },
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}

void _mostrarError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_mensajeError(error))));
}

String _mensajeError(Object error) {
  if (error is CantidadExcedePendienteEnvaseException) {
    return 'Solo hay ${error.pendiente} pendiente; se pidieron ${error.solicitada}.';
  }
  if (error is VentaOriginalNoCompletadaException) {
    return 'La venta original ya no está COMPLETADA, no se puede liquidar contra ella.';
  }
  if (error is String) return error;
  return 'No se pudo completar la operación: $error';
}
