import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session_providers.dart';
import '../../../core/money.dart';
import '../../../database/app_database.dart';

/// Stock físico de envases. Se organiza por TIPO de envase —la unidad
/// real de stock en el esquema (`envase_inventario_mov.tipo_envase_id`)—
/// en vez de por producto: varios productos pueden compartir el mismo
/// tipo de envase, así que agruparlo por producto duplicaría o
/// confundiría el stock. Cada tarjeta muestra, como referencia, los
/// productos del catálogo que usan ese envase.
class EnvaseStockScreen extends ConsumerWidget {
  const EnvaseStockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tiposAsync = ref.watch(_tiposEnvaseProvider);
    final productosAsync = ref.watch(_productosConEnvaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stock de envases')),
      body: tiposAsync.when(
        data: (tipos) {
          if (tipos.isEmpty) {
            return const Center(
              child: Text('Sin tipos de envase. Créalos primero en Configuración.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tipos.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tipo = tipos[index];
              final productos =
                  productosAsync.value
                      ?.where((p) => p.tipoEnvaseId == tipo.id)
                      .toList() ??
                  const <ProductoData>[];
              return _TipoEnvaseCard(tipo: tipo, productos: productos);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _TipoEnvaseCard extends ConsumerWidget {
  const _TipoEnvaseCard({required this.tipo, required this.productos});

  final TipoEnvaseData tipo;
  final List<ProductoData> productos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saldoAsync = ref.watch(_saldoFisicoProvider(tipo.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tipo.nombre,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                saldoAsync.when(
                  data: (saldo) => Text(
                    '$saldo en stock',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: saldo > 0 ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                  loading: () => const SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (error, _) => const Text('Error'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Depósito: ${formatCentavos(tipo.valorDepositoCentavos)}',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
            const SizedBox(height: 8),
            if (productos.isEmpty)
              Text(
                'Ningún producto usa este envase todavía',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final producto in productos)
                    Chip(
                      label: Text(producto.nombre, style: const TextStyle(fontSize: 11)),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => _registrarEntrada(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Registrar entrada de stock'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registrarEntrada(BuildContext context, WidgetRef ref) async {
    final resultado = await showDialog<_EntradaEnvaseResultado>(
      context: context,
      builder: (_) => _EntradaEnvaseDialog(tipoEnvase: tipo),
    );
    if (resultado == null) return;

    final usuario = await ref.read(currentUsuarioProvider.future);
    final envases = ref.read(envaseRepositoryProvider);

    try {
      if (resultado.origen == _OrigenEntrada.proveedor) {
        await envases.registrarCompraAProveedor(
          tipoEnvaseId: tipo.id,
          cantidad: resultado.cantidad,
          usuarioId: usuario.id,
        );
      } else {
        final sesion = await ref.read(sesionCajaAbiertaProvider.future);
        if (sesion == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Se requiere una sesión de caja abierta')),
            );
          }
          return;
        }
        await envases.comprarEnvaseACliente(
          tipoEnvaseId: tipo.id,
          cantidad: resultado.cantidad,
          montoCentavos: resultado.montoCentavos!,
          usuarioId: usuario.id,
          cajaSesionId: sesion.id,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

enum _OrigenEntrada { proveedor, cliente }

class _EntradaEnvaseResultado {
  const _EntradaEnvaseResultado({required this.origen, required this.cantidad, this.montoCentavos});

  final _OrigenEntrada origen;
  final int cantidad;
  final int? montoCentavos;
}

class _EntradaEnvaseDialog extends StatefulWidget {
  const _EntradaEnvaseDialog({required this.tipoEnvase});

  final TipoEnvaseData tipoEnvase;

  @override
  State<_EntradaEnvaseDialog> createState() => _EntradaEnvaseDialogState();
}

class _EntradaEnvaseDialogState extends State<_EntradaEnvaseDialog> {
  _OrigenEntrada _origen = _OrigenEntrada.proveedor;
  final _cantidadController = TextEditingController();
  final _montoController = TextEditingController();

  @override
  void dispose() {
    _cantidadController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Entrada de stock · ${widget.tipoEnvase.nombre}'),
      content: RadioGroup<_OrigenEntrada>(
        groupValue: _origen,
        onChanged: (valor) => setState(() => _origen = valor!),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<_OrigenEntrada>(
              dense: true,
              title: const Text('Compra a proveedor'),
              subtitle: const Text('Envases vacíos nuevos, sin movimiento de caja'),
              value: _OrigenEntrada.proveedor,
            ),
            RadioListTile<_OrigenEntrada>(
              dense: true,
              title: const Text('Compra a un cliente'),
              subtitle: const Text('Recompra suelta, sin relación a ningún préstamo previo'),
              value: _OrigenEntrada.cliente,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cantidadController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cantidad'),
            ),
            if (_origen == _OrigenEntrada.cliente)
              TextField(
                controller: _montoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto total pagado',
                  prefixText: r'$',
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
        FilledButton(onPressed: _confirmar, child: const Text('Registrar')),
      ],
    );
  }

  void _confirmar() {
    final cantidad = int.tryParse(_cantidadController.text);
    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cantidad inválida')));
      return;
    }

    if (_origen == _OrigenEntrada.proveedor) {
      Navigator.of(
        context,
      ).pop(_EntradaEnvaseResultado(origen: _origen, cantidad: cantidad));
      return;
    }

    final monto = parseCentavosDesdeTexto(_montoController.text);
    if (monto == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Monto inválido')));
      return;
    }
    Navigator.of(context).pop(
      _EntradaEnvaseResultado(origen: _origen, cantidad: cantidad, montoCentavos: monto),
    );
  }
}

final _tiposEnvaseProvider = FutureProvider<List<TipoEnvaseData>>(
  (ref) => ref.watch(tipoEnvaseRepositoryProvider).listarActivos(),
);

final _productosConEnvaseProvider = FutureProvider<List<ProductoData>>(
  (ref) => ref.watch(productoRepositoryProvider).listarActivos(),
);

final _saldoFisicoProvider = StreamProvider.family<int, int>(
  (ref, tipoEnvaseId) => ref.watch(envaseRepositoryProvider).observarSaldoFisico(tipoEnvaseId),
);
