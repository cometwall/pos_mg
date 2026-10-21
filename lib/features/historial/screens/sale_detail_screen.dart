import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session_providers.dart';
import '../../../core/money.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/devolucion_repository.dart';
import '../../../database/repositories/envase_repository.dart';
import '../../../database/repositories/venta_repository.dart';
import '../../../shared/widgets/money_display.dart';
import '../controllers/sale_history_controllers.dart';

/// Detalle de una venta histórica: consultar → solicitar
/// devolución/cancelación → confirmar. Nunca "editar líneas y guardar"
/// (el esquema no lo permite: `venta`/`detalle_venta` son append-only).
class SaleDetailScreen extends ConsumerWidget {
  const SaleDetailScreen({super.key, required this.ventaId});

  final int ventaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventaAsync = ref.watch(ventaPorIdProvider(ventaId));

    return Scaffold(
      appBar: AppBar(title: Text('Venta #$ventaId')),
      body: ventaAsync.when(
        data: (venta) {
          if (venta == null) return const Center(child: Text('Venta no encontrada'));
          return _SaleDetailBody(venta: venta);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _SaleDetailBody extends ConsumerWidget {
  const _SaleDetailBody({required this.venta});

  final VentaData venta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detalleAsync = ref.watch(detalleVentaProvider(venta.id));
    final pagosAsync = ref.watch(pagosVentaProvider(venta.id));
    final operacionesEnvaseAsync = ref.watch(operacionesEnvaseVentaProvider(venta.id));
    final tieneTarjetaAsync = ref.watch(tienePagoTarjetaProvider(venta.id));
    final clienteAsync = venta.clienteId != null
        ? ref.watch(nombreClienteProvider(venta.clienteId!))
        : null;

    final esCancelada = venta.estado == 'CANCELADA';
    final tieneTarjeta = tieneTarjetaAsync.value ?? true; // conservador mientras carga

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Chip(
              label: Text(venta.estado),
              backgroundColor: esCancelada ? Colors.red.shade50 : Colors.green.shade50,
              labelStyle: TextStyle(color: esCancelada ? Colors.red.shade700 : Colors.green.shade700),
            ),
            const SizedBox(width: 12),
            Text(venta.fecha, style: const TextStyle(color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          clienteAsync?.value ?? (venta.clienteId != null ? 'Cargando cliente…' : 'Sin cliente'),
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        const Text('Productos', style: TextStyle(fontWeight: FontWeight.w700)),
        const Divider(),
        detalleAsync.when(
          data: (detalles) => Column(
            children: [
              for (final detalle in detalles)
                _DetalleLineaTile(
                  ventaId: venta.id,
                  detalle: detalle,
                  puedeDevolver: !esCancelada && !tieneTarjeta,
                ),
            ],
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Text('Error: $error'),
        ),
        operacionesEnvaseAsync.when(
          data: (operaciones) {
            if (operaciones.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text('Envases', style: TextStyle(fontWeight: FontWeight.w700)),
                const Divider(),
                for (final operacion in operaciones)
                  _OperacionEnvaseTile(ventaId: venta.id, operacion: operacion),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),
        const Text('Pagos', style: TextStyle(fontWeight: FontWeight.w700)),
        const Divider(),
        pagosAsync.when(
          data: (pagos) => Column(
            children: [
              for (final pago in pagos)
                ListTile(
                  dense: true,
                  title: Text(pago.metodo),
                  trailing: MoneyDisplay(pago.montoCentavos),
                ),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Error: $error'),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (tieneTarjeta)
              const Tooltip(
                message:
                    'Esta venta incluye un pago con tarjeta. Las cancelaciones y '
                    'devoluciones con tarjeta deben resolverse manualmente en la '
                    'terminal bancaria.',
                child: Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.info_outline, color: Colors.black38),
                ),
              ),
            OutlinedButton(
              onPressed: !esCancelada && !tieneTarjeta ? () => _cancelarVenta(context, ref) : null,
              child: const Text('Cancelar venta'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _cancelarVenta(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Cancelar esta venta?'),
        content: const Text(
          'Se repondrá al inventario la cantidad activa, se revertirán depósitos/préstamos de '
          'envase pendientes y, si aplica, se reembolsará en efectivo. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Volver'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancelar venta'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    final usuario = await ref.read(currentUsuarioProvider.future);
    final sesion = ref.read(sesionCajaAbiertaProvider).value;

    try {
      await ref
          .read(ventaRepositoryProvider)
          .cancelarVenta(ventaId: venta.id, usuarioId: usuario.id, cajaSesionId: sesion?.id);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_mensajeError(e))));
    }
  }
}

class _DetalleLineaTile extends ConsumerWidget {
  const _DetalleLineaTile({
    required this.ventaId,
    required this.detalle,
    required this.puedeDevolver,
  });

  final int ventaId;
  final DetalleVentaData detalle;
  final bool puedeDevolver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreAsync = ref.watch(nombreProductoProvider(detalle.productoId));
    final activaAsync = ref.watch(cantidadActivaDetalleProvider(detalle.id));
    final productoAsync = ref.watch(productoPorIdProvider(detalle.productoId));

    return ListTile(
      dense: true,
      title: Text(nombreAsync.value ?? 'Producto #${detalle.productoId}'),
      subtitle: activaAsync.when(
        data: (activa) => Text(
          activa < detalle.cantidad
              ? 'Cantidad: ${detalle.cantidad} · Activa: $activa'
              : 'Cantidad: ${detalle.cantidad}',
        ),
        loading: () => Text('Cantidad: ${detalle.cantidad}'),
        error: (_, _) => Text('Cantidad: ${detalle.cantidad}'),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MoneyDisplay(detalle.subtotalCentavos),
          if (puedeDevolver)
            IconButton(
              icon: const Icon(Icons.assignment_return_outlined),
              tooltip: 'Devolver',
              onPressed: (activaAsync.value ?? 0) > 0
                  ? () => _devolverProducto(
                      context,
                      ref,
                      activaAsync.value!,
                      productoAsync.value?.tipoEnvaseId,
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  Future<void> _devolverProducto(
    BuildContext context,
    WidgetRef ref,
    int activa,
    int? tipoEnvaseId,
  ) async {
    // Si el producto tiene envase, se consulta cuánto depósito/préstamo
    // sigue pendiente en ESTA venta para ofrecer liquidarlo junto con la
    // devolución (ver doc de `DevolucionRepository.registrarDevolucion`
    // sobre por qué reutiliza devolverDeposito/devolverEnvasePrestado en
    // vez de un movimiento nuevo).
    var depositoPendiente = 0;
    var prestamoPendiente = 0;
    if (tipoEnvaseId != null) {
      final cuentas = ref.read(cuentasQueriesProvider);
      depositoPendiente = await cuentas.depositoPendienteVenta(ventaId, tipoEnvaseId);
      prestamoPendiente = await cuentas.envasePendienteVenta(ventaId, tipoEnvaseId);
    }
    if (!context.mounted) return;

    final cantidadController = TextEditingController(text: '1');
    final envaseDepositoController = TextEditingController(text: '0');
    final envasePrestamoController = TextEditingController(text: '0');
    var condicion = CondicionDevolucion.bueno;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text('Devolver producto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cantidad activa disponible: $activa'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad a devolver'),
                  ),
                  const SizedBox(height: 12),
                  RadioGroup<CondicionDevolucion>(
                    groupValue: condicion,
                    onChanged: (valor) => setState(() => condicion = valor!),
                    child: Column(
                      children: [
                        RadioListTile<CondicionDevolucion>(
                          dense: true,
                          title: const Text('Bueno (reingresa a inventario)'),
                          value: CondicionDevolucion.bueno,
                        ),
                        RadioListTile<CondicionDevolucion>(
                          dense: true,
                          title: const Text('Dañado (no reingresa)'),
                          value: CondicionDevolucion.danado,
                        ),
                      ],
                    ),
                  ),
                  if (depositoPendiente > 0 || prestamoPendiente > 0) ...[
                    const Divider(),
                    const Text(
                      '¿El envase también regresa?',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      'Independiente de la condición del producto — el envase puede '
                      'estar bien aunque el producto no.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    if (depositoPendiente > 0)
                      TextField(
                        controller: envaseDepositoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Regresa con depósito (pendiente: $depositoPendiente)',
                        ),
                      ),
                    if (prestamoPendiente > 0)
                      TextField(
                        controller: envasePrestamoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Regresa de préstamo (pendiente: $prestamoPendiente)',
                        ),
                      ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Devolver'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmar != true) return;
    final cantidad = int.tryParse(cantidadController.text);
    final envaseDeposito = int.tryParse(envaseDepositoController.text) ?? 0;
    final envasePrestamo = int.tryParse(envasePrestamoController.text) ?? 0;
    if (cantidad == null ||
        cantidad <= 0 ||
        cantidad > activa ||
        envaseDeposito < 0 ||
        envasePrestamo < 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cantidad inválida')));
      }
      return;
    }

    final usuario = await ref.read(currentUsuarioProvider.future);
    final sesion = ref.read(sesionCajaAbiertaProvider).value;

    try {
      await ref
          .read(devolucionRepositoryProvider)
          .registrarDevolucion(
            ventaId: ventaId,
            detalleVentaId: detalle.id,
            productoId: detalle.productoId,
            cantidad: cantidad,
            condicion: condicion,
            usuarioId: usuario.id,
            cajaSesionId: sesion?.id,
            tipoEnvaseId: tipoEnvaseId,
            envaseDepositoRegresa: envaseDeposito,
            envasePrestamoRegresa: envasePrestamo,
          );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_mensajeError(e))));
    }
  }
}

String _mensajeError(Object error) {
  if (error is ReembolsoTarjetaNoSoportadoException) {
    return 'Esta venta tiene un pago con tarjeta: resuélvelo manualmente en la terminal bancaria.';
  }
  if (error is CantidadExcedeActivaException) {
    return 'Solo quedan ${error.activa} unidades activas para devolver en esa línea.';
  }
  if (error is VentaNoCancelableException) {
    return 'Esta venta ya no se puede cancelar (estado actual: ${error.estadoActual}).';
  }
  if (error is TerminalCajaNoCoincideException) {
    return 'La sesión de caja no corresponde al terminal de esta venta, o no está abierta.';
  }
  if (error is EnvaseRegresaExcedeCantidadException) {
    return 'Se marcaron ${error.solicitado} envases como regresados pero solo se '
        'están devolviendo ${error.cantidadDevuelta} unidades de producto.';
  }
  if (error is CantidadExcedePendienteEnvaseException) {
    return 'Se pidió regresar ${error.solicitada} envases pero solo hay '
        '${error.pendiente} pendientes en esa venta.';
  }
  if (error is ArgumentError) {
    return error.message?.toString() ?? 'Se necesita abrir la caja para completar el reembolso en efectivo.';
  }
  return 'No se pudo completar la operación: $error';
}

/// Fila de una operación de envase registrada en la venta original
/// (depósito, préstamo, entregado o recibido). Para depósito/préstamo
/// muestra además cuánto sigue pendiente en esta venta — así una
/// devolución que liquidó parte de ese pendiente (ver
/// `DevolucionRepository.registrarDevolucion`) se refleja aquí sin tener
/// que ir a la ficha del cliente a comprobarlo.
class _OperacionEnvaseTile extends StatelessWidget {
  const _OperacionEnvaseTile({required this.ventaId, required this.operacion});

  final int ventaId;
  final OperacionEnvaseData operacion;

  @override
  Widget build(BuildContext context) {
    final esDeposito = operacion.tipo == 'DEPOSITO_COBRADO';
    final esPrestamo = operacion.tipo == 'PRESTADO';

    return ListTile(
      dense: true,
      title: Text('${_etiquetaOperacionEnvase(operacion.tipo)}: ${operacion.cantidad}'),
      subtitle: operacion.montoUnitarioCentavos != null
          ? Text('Depósito unitario: ${formatCentavos(operacion.montoUnitarioCentavos!)}')
          : null,
      trailing: esDeposito || esPrestamo
          ? _PendienteEnvaseBadge(
              ventaId: ventaId,
              tipoEnvaseId: operacion.tipoEnvaseId,
              esDeposito: esDeposito,
            )
          : null,
    );
  }
}

class _PendienteEnvaseBadge extends ConsumerWidget {
  const _PendienteEnvaseBadge({
    required this.ventaId,
    required this.tipoEnvaseId,
    required this.esDeposito,
  });

  final int ventaId;
  final int tipoEnvaseId;
  final bool esDeposito;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendienteAsync = esDeposito
        ? ref.watch(depositoPendienteVentaProvider((ventaId, tipoEnvaseId)))
        : ref.watch(prestamoPendienteVentaProvider((ventaId, tipoEnvaseId)));

    return pendienteAsync.when(
      data: (pendiente) => Text(
        pendiente > 0 ? 'Pendiente: $pendiente' : 'Liquidado',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: pendiente > 0 ? Colors.amber.shade800 : Colors.green.shade700,
        ),
      ),
      loading: () => const SizedBox(
        height: 12,
        width: 12,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

String _etiquetaOperacionEnvase(String tipo) => switch (tipo) {
  'DEPOSITO_COBRADO' => 'Depósito cobrado',
  'PRESTADO' => 'Prestado',
  'ENTREGADO' => 'Entregado',
  'RECIBIDO' => 'Recibido',
  _ => tipo,
};
