import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/screens/login_screen.dart';
import '../shared/theme/app_theme.dart';
import 'app_shell.dart';

class PosApp extends ConsumerWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesion = ref.watch(authControllerProvider);
    return MaterialApp(
      title: 'POS MG',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // Al cerrar sesión se desmonta el shell completo: el siguiente
      // usuario no hereda carrito ni pantallas a medio llenar.
      home: sesion == null ? const LoginScreen() : const AppShell(),
    );
  }
}
