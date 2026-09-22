import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/repositories/catalogo_repository.dart';
import 'providers.dart';

/// El proyecto todavía no tiene login: se bootstrapea un terminal y un
/// usuario por defecto la primera vez que se usa la app (si ya existen,
/// se reutiliza el primero). Cuando exista un módulo de login/usuarios,
/// esto se reemplaza por la sesión real autenticada.
final currentTerminalProvider = FutureProvider<TerminalData>((ref) async {
  final repo = ref.watch(terminalRepositoryProvider);
  final activos = await repo.listarActivos();
  if (activos.isNotEmpty) return activos.first;
  final id = await repo.crear(nombre: 'Mostrador 1', codigo: 'T1');
  return (await repo.listarActivos()).firstWhere((t) => t.id == id);
});

final currentUsuarioProvider = FutureProvider<UsuarioData>((ref) async {
  final repo = ref.watch(usuarioRepositoryProvider);
  final activos = await repo.listarActivos();
  if (activos.isNotEmpty) return activos.first;
  final id = await repo.crear(nombre: 'Cajero', rol: RolUsuario.cajero);
  return (await repo.listarActivos()).firstWhere((u) => u.id == id);
});

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
