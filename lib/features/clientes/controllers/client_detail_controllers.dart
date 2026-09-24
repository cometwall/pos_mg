import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../database/repositories/cuentas_queries.dart';

final envasesPendientesClienteProvider = FutureProvider.family<List<PendienteEnvaseCliente>, int>(
  (ref, clienteId) => ref.watch(cuentasQueriesProvider).envasesPendientesPorCliente(clienteId),
);

final depositosPendientesClienteProvider = FutureProvider.family<List<PendienteEnvaseCliente>, int>(
  (ref, clienteId) => ref.watch(cuentasQueriesProvider).depositosPendientesPorCliente(clienteId),
);

final nombreTipoEnvaseProvider = FutureProvider.family<String, int>((ref, tipoEnvaseId) async {
  final tipo = await ref.watch(tipoEnvaseRepositoryProvider).obtenerPorId(tipoEnvaseId);
  return tipo?.nombre ?? 'Envase #$tipoEnvaseId';
});
