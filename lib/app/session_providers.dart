import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../features/auth/controllers/auth_controller.dart';
import 'providers.dart';

/// Todavía no hay gestión de terminales: se bootstrapea un terminal por
/// defecto la primera vez que se usa la app (si ya existe, se reutiliza
/// el primero).
final currentTerminalProvider = FutureProvider<TerminalData>((ref) async {
  final repo = ref.watch(terminalRepositoryProvider);
  final activos = await repo.listarActivos();
  if (activos.isNotEmpty) return activos.first;
  final id = await repo.crear(nombre: 'Mostrador 1', codigo: 'T1');
  return (await repo.listarActivos()).firstWhere((t) => t.id == id);
});

/// Usuario de la sesión iniciada en el login. Las pantallas solo son
/// alcanzables con sesión activa, así que no debería fallar en la
/// práctica.
final currentUsuarioProvider = FutureProvider<UsuarioData>((ref) async {
  final sesion = ref.watch(authControllerProvider);
  if (sesion == null) {
    throw StateError('No hay una sesión de usuario iniciada');
  }
  return sesion.usuario;
});

final esAdminProvider = Provider<bool>(
  (ref) => ref.watch(authControllerProvider)?.esAdmin ?? false,
);

/// Sesión de caja ABIERTA del terminal actual, o `null` si no hay
/// ninguna. Es estado global transversal: Ventas la consulta para saber
/// si puede cobrar en efectivo: Caja la consulta para saber si debe
/// mostrar "abrir sesión" o el panel de la sesión activa.
final sesionCajaAbiertaProvider = StreamProvider<CajaSesionData?>((ref) {
  final terminalAsync = ref.watch(currentTerminalProvider);
  final terminal = terminalAsync.value;
  if (terminal == null) {
    return const Stream<CajaSesionData?>.empty();
  }
  return ref.watch(cajaRepositoryProvider).observarSesionAbierta(terminal.id);
});
