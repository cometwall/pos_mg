import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';

/// Indicador persistente del estado de la sesión de caja del terminal
/// actual. Se usa tanto en Ventas (para anticipar si se puede cobrar en
/// efectivo) como en la propia pantalla de Caja.
class CashSessionStatusBadge extends ConsumerWidget {
  const CashSessionStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesionAsync = ref.watch(sesionCajaAbiertaProvider);

    return sesionAsync.when(
      data: (sesion) => _Badge(
        color: sesion != null ? Colors.green : Colors.grey,
        texto: sesion != null ? 'Caja abierta · Sesión #${sesion.id}' : 'Caja cerrada',
      ),
      loading: () => const _Badge(color: Colors.grey, texto: 'Caja…'),
      error: (_, _) => const _Badge(color: Colors.red, texto: 'Error de caja'),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.texto});

  final Color color;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 6),
          Text(texto, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
