import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usuarioController;
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _ocultarPassword = true;
  bool _cargando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final controller = ref.read(authControllerProvider.notifier);
    _usuarioController = TextEditingController(text: controller.ultimoUsuario);
    // Sesión cerrada por el sistema (token vencido, usuario revocado al
    // volver la conexión): se explica por qué se regresó al login.
    _error = controller.motivoCierre;
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (_cargando || !_formKey.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      final sesion = await ref
          .read(authControllerProvider.notifier)
          .iniciarSesion(_usuarioController.text, _passwordController.text);
      if (sesion.esOffline) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Sin conexión con el servidor: sesión iniciada en modo offline.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = e.toString();
      });
      _passwordController.clear();
      _passwordFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'POS MG',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Inicia sesión para continuar',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        const _SucursalDelEquipo(),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _usuarioController,
                          enabled: !_cargando,
                          autofocus: _usuarioController.text.isEmpty,
                          autofillHints: const [AutofillHints.username],
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Escribe tu usuario'
                              : null,
                          onFieldSubmitted: (_) =>
                              _passwordFocus.requestFocus(),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          enabled: !_cargando,
                          autofocus: _usuarioController.text.isNotEmpty,
                          obscureText: _ocultarPassword,
                          autofillHints: const [AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _ocultarPassword
                                  ? 'Mostrar contraseña'
                                  : 'Ocultar contraseña',
                              icon: Icon(
                                _ocultarPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () => setState(
                                () => _ocultarPassword = !_ocultarPassword,
                              ),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Escribe tu contraseña'
                              : null,
                          onFieldSubmitted: (_) => _iniciarSesion(),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _cargando ? null : _iniciarSesion,
                          child: _cargando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Iniciar sesión'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sucursal a la que está vinculado el equipo, o aviso de que falta
/// que un administrador lo configure.
class _SucursalDelEquipo extends ConsumerWidget {
  const _SucursalDelEquipo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final config = ref.watch(dispositivoConfigProvider).value;
    if (ref.watch(dispositivoConfigProvider).isLoading) {
      return const SizedBox.shrink();
    }
    if (config == null) {
      return Text(
        'Equipo sin configurar: inicia sesión como administrador para '
        'vincularlo a tu sucursal.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.tertiary,
        ),
      );
    }
    return Text(
      'Sucursal: ${config.sucursalNombre ?? '#${config.sucursalId}'}',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall,
    );
  }
}
