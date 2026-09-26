import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/money.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/envase_repository.dart';

/// Configura las operaciones de envase de una línea del carrito. A
/// diferencia de una elección única, las 4 cantidades son independientes
/// y combinables entre sí — un cliente puede traer 2 envases a
/// intercambiar y dejar depósito por 1 más, o traer 1 y pedir que se le
/// preste otro, todo en la misma línea. Solo se ofrece para productos
/// con `tipoEnvaseId`.
class EnvaseDialog extends ConsumerStatefulWidget {
  const EnvaseDialog({
    super.key,
    required this.tipoEnvaseId,
    required this.cantidadSugerida,
    required this.hayCliente,
    this.inicial = const [],
  });

  final int tipoEnvaseId;
  final int cantidadSugerida;
  final bool hayCliente;
  final List<OperacionEnvaseVenta> inicial;

  /// Devuelve `true` si el cajero confirmó con "Guardar" (aunque haya
  /// dejado las 4 cantidades en 0, equivalente a "sin operación de
  /// envase") y `false` si canceló o cerró el diálogo sin resolverlo —
  /// distinción que el llamador necesita para decidir si debe revertir
  /// algo hecho antes de abrir el diálogo (ver `product_search.dart`).
  static Future<bool> show(
    BuildContext context, {
    required int tipoEnvaseId,
    required int cantidadSugerida,
    required bool hayCliente,
    List<OperacionEnvaseVenta> inicial = const [],
    required void Function(List<OperacionEnvaseVenta> operaciones) onGuardar,
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
      if (resultado is _Resultado) {
        onGuardar(resultado.operaciones);
        return true;
      }
      return false;
    });
  }

  @override
  ConsumerState<EnvaseDialog> createState() => _EnvaseDialogState();
}

class _Resultado {
  const _Resultado(this.operaciones);
  final List<OperacionEnvaseVenta> operaciones;
}

class _EnvaseDialogState extends ConsumerState<EnvaseDialog> {
  late final TextEditingController _depositoController;
  late final TextEditingController _prestamoController;
  late final TextEditingController _entregadoController;
  late final TextEditingController _recibidoController;
  late final TextEditingController _montoController;
  late final Future<TipoEnvaseData?> _tipoEnvaseFuture;

  @override
  void initState() {
    super.initState();
    _tipoEnvaseFuture = ref.read(tipoEnvaseRepositoryProvider).obtenerPorId(widget.tipoEnvaseId);

    int cantidadDe(TipoOperacionEnvase tipo) => widget.inicial
        .where((o) => o.tipo == tipo)
        .fold(0, (acc, o) => acc + o.cantidad);

    // Sin operaciones previas, se asume el caso más común: intercambio
    // inmediato en el mostrador, sin depósito ni préstamo.
    final entregadoInicial = widget.inicial.isEmpty
        ? widget.cantidadSugerida
        : cantidadDe(TipoOperacionEnvase.entregado);

    _depositoController = TextEditingController(
      text: '${cantidadDe(TipoOperacionEnvase.depositoCobrado)}',
    );
    _prestamoController = TextEditingController(
      text: '${cantidadDe(TipoOperacionEnvase.prestado)}',
    );
    _entregadoController = TextEditingController(text: '$entregadoInicial');
    _recibidoController = TextEditingController(
      text: '${cantidadDe(TipoOperacionEnvase.recibido)}',
    );

    final montoExistente = widget.inicial
        .where((o) => o.tipo == TipoOperacionEnvase.depositoCobrado)
        .map((o) => o.montoUnitarioCentavos)
        .whereType<int>()
        .firstOrNull;
    _montoController = TextEditingController(
      text: montoExistente != null ? (montoExistente / 100).toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _depositoController.dispose();
    _prestamoController.dispose();
    _entregadoController.dispose();
    _recibidoController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  /// Vacío = "no seleccionado" (0, no es error). Texto inválido o
  /// negativo = `null` (error real). `TextInputType.number` solo sugiere
  /// el teclado; sin `inputFormatters` un teclado físico puede escribir
  /// "-", así que este parseo sigue siendo necesario aunque los campos
  /// ya filtren solo dígitos.
  int? _parsearCantidad(String texto) {
    final t = texto.trim();
    if (t.isEmpty) return 0;
    final v = int.tryParse(t);
    if (v == null || v < 0) return null;
    return v;
  }

  int _leer(TextEditingController c) => _parsearCantidad(c.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TipoEnvaseData?>(
      future: _tipoEnvaseFuture,
      builder: (context, snapshot) {
        final tipoEnvase = snapshot.data;
        if (_montoController.text.isEmpty && tipoEnvase != null) {
          _montoController.text = (tipoEnvase.valorDepositoCentavos / 100).toStringAsFixed(2);
        }

        final deposito = _leer(_depositoController);
        final prestamo = _leer(_prestamoController);
        final entregado = _leer(_entregadoController);
        final cubiertas = deposito + prestamo + entregado;
        final cubreTodo = cubiertas == widget.cantidadSugerida;

        return AlertDialog(
          title: Text('Envase${tipoEnvase != null ? ' · ${tipoEnvase.nombre}' : ''}'),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.hayCliente) ...[
                  const Text(
                    'Cobrar depósito o prestar sin depósito requiere asociar un '
                    'cliente a la venta.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                ],
                _CantidadRow(
                  label: 'Cobrar depósito (retornable)',
                  controller: _depositoController,
                  enabled: widget.hayCliente,
                  onChanged: () => setState(() {}),
                ),
                if (deposito > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _montoController,
                      enabled: widget.hayCliente,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Depósito por unidad',
                        prefixText: r'$',
                        isDense: true,
                      ),
                    ),
                  ),
                _CantidadRow(
                  label: 'Prestar sin depósito',
                  controller: _prestamoController,
                  enabled: widget.hayCliente,
                  onChanged: () => setState(() {}),
                ),
                _CantidadRow(
                  label: 'Entregar envase',
                  controller: _entregadoController,
                  onChanged: () => setState(() {}),
                ),
                _CantidadRow(
                  label: 'Recibir envase vacío',
                  controller: _recibidoController,
                  onChanged: () => setState(() {}),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cubre $cubiertas de ${widget.cantidadSugerida} unidad'
                  '${widget.cantidadSugerida == 1 ? '' : 'es'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cubreTodo ? Colors.green.shade700 : Colors.amber.shade800,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              // Sin resultado (no un `_Resultado([])`): cancelar debe
              // significar "no cambiar nada", igual que cerrar el diálogo
              // tocando fuera de él — a diferencia de dejar las 4
              // cantidades en 0 y dar Guardar, que sí es una decisión
              // explícita de limpiar las operaciones configuradas.
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(onPressed: () => _confirmar(context), child: const Text('Guardar')),
          ],
        );
      },
    );
  }

  void _confirmar(BuildContext context) {
    final deposito = _parsearCantidad(_depositoController.text);
    final prestamo = _parsearCantidad(_prestamoController.text);
    final entregado = _parsearCantidad(_entregadoController.text);
    final recibido = _parsearCantidad(_recibidoController.text);

    if (deposito == null || prestamo == null || entregado == null || recibido == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cantidad de envase inválida')));
      return;
    }

    int? monto;
    if (deposito > 0 && widget.hayCliente) {
      monto = parseCentavosDesdeTexto(_montoController.text);
      if (monto == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Monto de depósito inválido')));
        return;
      }
    }

    final operaciones = <OperacionEnvaseVenta>[
      // El filtro por `hayCliente` es cinturón y tirantes: los campos ya
      // están deshabilitados sin cliente y `quitarCliente()` en el
      // carrito garantiza que un `inicial` con depósito/préstamo nunca
      // llega aquí sin cliente — esto solo cubre el caso de que ese
      // invariante se rompiera en el futuro.
      if (deposito > 0 && widget.hayCliente)
        OperacionEnvaseVenta(
          tipoEnvaseId: widget.tipoEnvaseId,
          tipo: TipoOperacionEnvase.depositoCobrado,
          cantidad: deposito,
          montoUnitarioCentavos: monto,
        ),
      if (prestamo > 0 && widget.hayCliente)
        OperacionEnvaseVenta(
          tipoEnvaseId: widget.tipoEnvaseId,
          tipo: TipoOperacionEnvase.prestado,
          cantidad: prestamo,
        ),
      if (entregado > 0)
        OperacionEnvaseVenta(
          tipoEnvaseId: widget.tipoEnvaseId,
          tipo: TipoOperacionEnvase.entregado,
          cantidad: entregado,
        ),
      if (recibido > 0)
        OperacionEnvaseVenta(
          tipoEnvaseId: widget.tipoEnvaseId,
          tipo: TipoOperacionEnvase.recibido,
          cantidad: recibido,
        ),
    ];

    Navigator.of(context).pop(_Resultado(operaciones));
  }
}

class _CantidadRow extends StatelessWidget {
  const _CantidadRow({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: enabled ? null : Colors.black38),
            ),
          ),
          SizedBox(
            width: 64,
            child: TextField(
              controller: controller,
              enabled: enabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(isDense: true),
              onChanged: (_) => onChanged(),
            ),
          ),
        ],
      ),
    );
  }
}
