import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/money.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/envase_repository.dart';

enum _Opcion { ninguno, deposito, prestamo, entregado, recibido }

/// Configura la operación de envase (depósito cobrado, préstamo sin
/// depósito, o intercambio inmediato en el mostrador) de una línea del
/// carrito. Solo se ofrece para productos con `tipoEnvaseId`.
class EnvaseDialog extends ConsumerStatefulWidget {
  const EnvaseDialog({
    super.key,
    required this.tipoEnvaseId,
    required this.cantidadSugerida,
    required this.hayCliente,
    this.inicial,
  });

  final int tipoEnvaseId;
  final int cantidadSugerida;
  final bool hayCliente;
  final OperacionEnvaseVenta? inicial;

  static Future<void> show(
    BuildContext context, {
    required int tipoEnvaseId,
    required int cantidadSugerida,
    required bool hayCliente,
    OperacionEnvaseVenta? inicial,
    required void Function(OperacionEnvaseVenta? operacion) onGuardar,
  }) {
    return showDialog(
      context: context,
      builder: (_) => EnvaseDialog(
        tipoEnvaseId: tipoEnvaseId,
        cantidadSugerida: cantidadSugerida,
        hayCliente: hayCliente,
        inicial: inicial,
      ),
    ).then((resultado) {
      if (resultado is _Resultado) onGuardar(resultado.operacion);
    });
  }

  @override
  ConsumerState<EnvaseDialog> createState() => _EnvaseDialogState();
}

class _Resultado {
  const _Resultado(this.operacion);
  final OperacionEnvaseVenta? operacion;
}

class _EnvaseDialogState extends ConsumerState<EnvaseDialog> {
  late _Opcion _opcion;
  late final TextEditingController _cantidadController;
  late final TextEditingController _montoController;
  late final Future<TipoEnvaseData?> _tipoEnvaseFuture;

  @override
  void initState() {
    super.initState();
    _tipoEnvaseFuture = ref.read(tipoEnvaseRepositoryProvider).obtenerPorId(widget.tipoEnvaseId);
    final inicial = widget.inicial;
    _opcion = switch (inicial?.tipo) {
      TipoOperacionEnvase.depositoCobrado => _Opcion.deposito,
      TipoOperacionEnvase.prestado => _Opcion.prestamo,
      TipoOperacionEnvase.entregado => _Opcion.entregado,
      TipoOperacionEnvase.recibido => _Opcion.recibido,
      null => _Opcion.ninguno,
    };
    _cantidadController = TextEditingController(
      text: '${inicial?.cantidad ?? widget.cantidadSugerida}',
    );
    _montoController = TextEditingController(
      text: inicial?.montoUnitarioCentavos != null
          ? (inicial!.montoUnitarioCentavos! / 100).toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TipoEnvaseData?>(
      future: _tipoEnvaseFuture,
      builder: (context, snapshot) {
        final tipoEnvase = snapshot.data;
        if (_montoController.text.isEmpty && tipoEnvase != null) {
          _montoController.text = (tipoEnvase.valorDepositoCentavos / 100).toStringAsFixed(2);
        }

        return AlertDialog(
          title: Text('Envase${tipoEnvase != null ? ' · ${tipoEnvase.nombre}' : ''}'),
          content: RadioGroup<_Opcion>(
            groupValue: _opcion,
            onChanged: (valor) => setState(() => _opcion = valor!),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile<_Opcion>(
                dense: true,
                title: const Text('Sin operación de envase'),
                value: _Opcion.ninguno,
              ),
              RadioListTile<_Opcion>(
                dense: true,
                title: const Text('Cobrar depósito (retornable)'),
                value: _Opcion.deposito,
              ),
              RadioListTile<_Opcion>(
                dense: true,
                title: const Text('Prestar sin depósito'),
                subtitle: !widget.hayCliente
                    ? const Text('Requiere asociar un cliente a la venta')
                    : null,
                value: _Opcion.prestamo,
                enabled: widget.hayCliente,
              ),
              RadioListTile<_Opcion>(
                dense: true,
                title: const Text('Entregar envase'),
                subtitle: const Text('Sale sin depósito ni préstamo (intercambio en el momento)'),
                value: _Opcion.entregado,
              ),
              RadioListTile<_Opcion>(
                dense: true,
                title: const Text('Recibir envase vacío del cliente'),
                value: _Opcion.recibido,
              ),
              if (_opcion != _Opcion.ninguno) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cantidad de envases'),
                ),
                if (_opcion == _Opcion.deposito)
                  TextField(
                    controller: _montoController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Depósito por unidad',
                      prefixText: r'$',
                    ),
                  ),
              ],
            ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(const _Resultado(null)),
              child: const Text('Cancelar'),
            ),
            FilledButton(onPressed: () => _confirmar(context), child: const Text('Guardar')),
          ],
        );
      },
    );
  }

  void _confirmar(BuildContext context) {
    if (_opcion == _Opcion.ninguno) {
      Navigator.of(context).pop(const _Resultado(null));
      return;
    }

    final cantidad = int.tryParse(_cantidadController.text);
    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cantidad de envase inválida')));
      return;
    }

    if (_opcion == _Opcion.deposito) {
      final monto = parseCentavosDesdeTexto(_montoController.text);
      if (monto == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Monto de depósito inválido')));
        return;
      }
      Navigator.of(context).pop(
        _Resultado(
          OperacionEnvaseVenta(
            tipoEnvaseId: widget.tipoEnvaseId,
            tipo: TipoOperacionEnvase.depositoCobrado,
            cantidad: cantidad,
            montoUnitarioCentavos: monto,
          ),
        ),
      );
      return;
    }

    final tipo = switch (_opcion) {
      _Opcion.prestamo => TipoOperacionEnvase.prestado,
      _Opcion.entregado => TipoOperacionEnvase.entregado,
      _Opcion.recibido => TipoOperacionEnvase.recibido,
      _Opcion.ninguno || _Opcion.deposito => throw StateError('Caso ya manejado arriba'),
    };

    Navigator.of(context).pop(
      _Resultado(
        OperacionEnvaseVenta(
          tipoEnvaseId: widget.tipoEnvaseId,
          tipo: tipo,
          cantidad: cantidad,
        ),
      ),
    );
  }
}
