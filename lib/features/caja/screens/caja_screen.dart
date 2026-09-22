import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session_providers.dart';
import '../../../core/money.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/caja_repository.dart';
import '../../../shared/widgets/money_display.dart';

/// Caja: `movimiento_caja` es exclusivamente efectivo físico — esta
/// pantalla nunca mezcla tarjeta con efectivo. Sin sesión abierta, guía
/// a abrirla; con sesión abierta, muestra el efectivo esperado (derivado
/// en vivo) y el historial de movimientos.
class CajaScreen extends ConsumerWidget {
  const CajaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesionAsync = ref.watch(sesionCajaAbiertaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Caja')),
      body: sesionAsync.when(
        data: (sesion) =>
            sesion == null ? const _AbrirSesionForm() : _SesionActivaView(sesion: sesion),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _AbrirSesionForm extends ConsumerStatefulWidget {
  const _AbrirSesionForm();

  @override
  ConsumerState<_AbrirSesionForm> createState() => _AbrirSesionFormState();
}

class _AbrirSesionFormState extends ConsumerState<_AbrirSesionForm> {
  final _montoController = TextEditingController(text: '0.00');
  bool _abriendo = false;

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _abrir() async {
    final monto = parseCentavosDesdeTexto(_montoController.text);
    if (monto == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ingresa un efectivo inicial válido')));
      return;
    }
    setState(() => _abriendo = true);
    try {
      final terminal = await ref.read(currentTerminalProvider.future);
      final usuario = await ref.read(currentUsuarioProvider.future);
      await ref
          .read(cajaRepositoryProvider)
          .abrirSesion(
            terminalId: terminal.id,
            usuarioAperturaId: usuario.id,
            efectivoInicialCentavos: monto,
          );
    } finally {
      if (mounted) setState(() => _abriendo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 360,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Abrir caja',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _montoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Efectivo inicial',
                    prefixText: r'$',
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _abriendo ? null : _abrir,
                  child: _abriendo
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Abrir caja'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SesionActivaView extends ConsumerWidget {
  const _SesionActivaView({required this.sesion});

  final CajaSesionData sesion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final esperadoAsync = ref.watch(_efectivoEsperadoProvider(sesion.id));
    final movimientosAsync = ref.watch(_movimientosCajaProvider(sesion.id));

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sesión #${sesion.id} · ABIERTA',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('EFECTIVO ESPERADO', style: TextStyle(fontWeight: FontWeight.w600)),
                  esperadoAsync.when(
                    data: (monto) => MoneyDisplay(
                      monto,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    loading: () => const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (error, _) => Text('Error: $error'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _registrarMovimiento(context, ref, TipoMovimientoManual.entrada),
                icon: const Icon(Icons.add),
                label: const Text('Registrar entrada'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _registrarMovimiento(context, ref, TipoMovimientoManual.retiro),
                icon: const Icon(Icons.remove),
                label: const Text('Registrar retiro'),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _cerrarCaja(context, ref),
                icon: const Icon(Icons.lock_outline),
                label: const Text('Cerrar caja'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Movimientos', style: TextStyle(fontWeight: FontWeight.w700)),
          const Divider(),
          Expanded(
            child: movimientosAsync.when(
              data: (movimientos) {
                if (movimientos.isEmpty) {
                  return const Center(child: Text('Sin movimientos todavía'));
                }
                return ListView.separated(
                  itemCount: movimientos.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final movimiento = movimientos[index];
                    final esPositivo = movimiento.montoCentavos >= 0;
                    return ListTile(
                      dense: true,
                      title: Text(movimiento.tipo),
                      subtitle: movimiento.motivo != null ? Text(movimiento.motivo!) : null,
                      trailing: MoneyDisplay(
                        movimiento.montoCentavos,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: esPositivo ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _registrarMovimiento(
    BuildContext context,
    WidgetRef ref,
    TipoMovimientoManual tipo,
  ) async {
    final montoController = TextEditingController();
    final motivoController = TextEditingController();
    final titulo = tipo == TipoMovimientoManual.entrada ? 'Registrar entrada' : 'Registrar retiro';

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(titulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: montoController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Monto', prefixText: r'$'),
            ),
            TextField(
              controller: motivoController,
              decoration: const InputDecoration(labelText: 'Motivo'),
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
            child: const Text('Registrar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;
    final monto = parseCentavosDesdeTexto(montoController.text);
    if (monto == null || monto <= 0 || motivoController.text.trim().isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Monto y motivo son obligatorios')));
      }
      return;
    }

    final usuario = await ref.read(currentUsuarioProvider.future);
    await ref
        .read(cajaRepositoryProvider)
        .registrarMovimientoManual(
          cajaSesionId: sesion.id,
          tipo: tipo,
          montoCentavos: monto,
          motivo: motivoController.text.trim(),
          usuarioId: usuario.id,
        );
  }

  Future<void> _cerrarCaja(BuildContext context, WidgetRef ref) async {
    final esperado = await ref.read(cajaRepositoryProvider).efectivoEsperado(sesion.id);
    if (!context.mounted) return;

    final contadoController = TextEditingController(text: (esperado / 100).toStringAsFixed(2));

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            final contado = parseCentavosDesdeTexto(contadoController.text) ?? 0;
            final diferencia = contado - esperado;
            return AlertDialog(
              title: const Text('Cerrar caja'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Efectivo esperado'), MoneyDisplay(esperado)],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contadoController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Efectivo contado',
                      prefixText: r'$',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        diferencia == 0
                            ? 'Sin diferencia'
                            : diferencia > 0
                            ? 'Sobrante'
                            : 'Faltante',
                      ),
                      MoneyDisplay(
                        diferencia,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: diferencia == 0
                              ? Colors.black87
                              : diferencia > 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ],
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
                  child: const Text('Confirmar cierre'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmar != true) return;
    final contado = parseCentavosDesdeTexto(contadoController.text);
    if (contado == null) return;

    final usuario = await ref.read(currentUsuarioProvider.future);
    await ref
        .read(cajaRepositoryProvider)
        .cerrarSesion(
          cajaSesionId: sesion.id,
          usuarioCierreId: usuario.id,
          efectivoContadoCentavos: contado,
        );
  }
}

final _efectivoEsperadoProvider = StreamProvider.family<int, int>(
  (ref, cajaSesionId) => ref.watch(cajaRepositoryProvider).observarEfectivoEsperado(cajaSesionId),
);

final _movimientosCajaProvider = StreamProvider.family<List<MovimientoCajaData>, int>(
  (ref, cajaSesionId) => ref.watch(cajaRepositoryProvider).observarMovimientos(cajaSesionId),
);
