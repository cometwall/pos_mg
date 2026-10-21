import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/session_providers.dart';
import '../../../core/money.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/catalogo_repository.dart';
import '../../auth/controllers/auth_controller.dart';

final _categoriasProvider = FutureProvider<List<CategoriaData>>(
  (ref) => ref.watch(categoriaRepositoryProvider).listarTodas(),
);
final _tiposEnvaseProvider = FutureProvider<List<TipoEnvaseData>>(
  (ref) => ref.watch(tipoEnvaseRepositoryProvider).listarActivos(),
);
/// Usuarios del backend de la sucursal de este equipo que este equipo
/// conoce (no hay endpoint para listar todos los del backend).
final _usuariosProvider = StreamProvider<List<UsuarioData>>((ref) {
  final config = ref.watch(dispositivoConfigProvider).value;
  if (config == null) return Stream.value(const []);
  return ref
      .watch(usuarioAuthRepositoryProvider)
      .observarDeSucursal(config.sucursalId);
});
final _terminalesProvider = FutureProvider<List<TerminalData>>(
  (ref) => ref.watch(terminalRepositoryProvider).listarActivos(),
);

/// Catálogos de soporte: categorías, tipos de envase, usuarios y
/// terminales. Menor jerarquía visual en la navegación — se configura
/// una vez y se toca poco después.
class ConfiguracionScreen extends ConsumerWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _EquipoSection(),
          const Divider(height: 32),
          const _CategoriasSection(),
          const Divider(height: 32),
          const _TiposEnvaseSection(),
          // Gestión de usuarios: única sección restringida a admins.
          if (ref.watch(esAdminProvider)) ...[
            const Divider(height: 32),
            const _UsuariosSection(),
          ],
          const Divider(height: 32),
          const _TerminalesSection(),
        ],
      ),
    );
  }
}

/// Sucursal vinculada a este equipo. Solo un admin con sesión online
/// puede desvincularlo (el próximo admin que entre lo vuelve a vincular
/// a su propia sucursal).
class _EquipoSection extends ConsumerWidget {
  const _EquipoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(dispositivoConfigProvider).value;
    final sesion = ref.watch(authControllerProvider);
    final puedeDesvincular =
        ref.watch(esAdminProvider) && sesion != null && !sesion.esOffline;
    return _Section(
      titulo: 'Equipo',
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.store_outlined),
        title: Text(
          config == null
              ? 'Sin sucursal vinculada'
              : 'Sucursal: ${config.sucursalNombre ?? '#${config.sucursalId}'}',
        ),
        subtitle: config == null ? null : Text('Vinculado el ${config.vinculadoEn}'),
        trailing: puedeDesvincular && config != null
            ? TextButton(
                onPressed: () => _desvincular(context, ref),
                child: const Text('Desvincular equipo'),
              )
            : null,
      ),
    );
  }

  Future<void> _desvincular(BuildContext context, WidgetRef ref) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desvincular equipo'),
        content: const Text(
          'Se cerrará la sesión y el equipo quedará sin sucursal. Nadie podrá '
          'entrar hasta que un administrador inicie sesión con conexión y lo '
          'vincule a su sucursal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;
    await ref.read(authControllerProvider.notifier).desvincularEquipo();
  }
}

class _CategoriasSection extends ConsumerWidget {
  const _CategoriasSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriasAsync = ref.watch(_categoriasProvider);
    return _Section(
      titulo: 'Categorías',
      onAgregar: () async {
        final nombre = await _pedirTexto(context, 'Nueva categoría', 'Nombre');
        if (nombre == null || nombre.isEmpty) return;
        await ref.read(categoriaRepositoryProvider).crear(nombre: nombre);
        ref.invalidate(_categoriasProvider);
      },
      child: categoriasAsync.when(
        data: (categorias) => Wrap(
          spacing: 8,
          children: [for (final categoria in categorias) Chip(label: Text(categoria.nombre))],
        ),
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }
}

class _TiposEnvaseSection extends ConsumerWidget {
  const _TiposEnvaseSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tiposAsync = ref.watch(_tiposEnvaseProvider);
    return _Section(
      titulo: 'Tipos de envase',
      onAgregar: () async {
        final resultado = await _pedirTipoEnvase(context);
        if (resultado == null) return;
        await ref
            .read(tipoEnvaseRepositoryProvider)
            .crear(nombre: resultado.$1, valorDepositoCentavos: resultado.$2);
        ref.invalidate(_tiposEnvaseProvider);
      },
      child: tiposAsync.when(
        data: (tipos) => Column(
          children: [
            for (final tipo in tipos)
              ListTile(
                dense: true,
                title: Text(tipo.nombre),
                trailing: Text('Depósito: ${formatCentavos(tipo.valorDepositoCentavos)}'),
              ),
          ],
        ),
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }
}

class _UsuariosSection extends ConsumerWidget {
  const _UsuariosSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuariosAsync = ref.watch(_usuariosProvider);
    final sesion = ref.watch(authControllerProvider);
    final conConexion = sesion != null && !sesion.esOffline;
    return _Section(
      titulo: 'Usuarios',
      onAgregar: conConexion ? () => _registrar(context) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!conConexion)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Registrar usuarios requiere conexión con el servidor.'),
            ),
          usuariosAsync.when(
            data: (usuarios) => usuarios.isEmpty
                ? const Text('Ningún usuario de esta sucursal ha usado este equipo.')
                : Column(
                    children: [
                      for (final usuario in usuarios)
                        ListTile(
                          dense: true,
                          leading: Icon(
                            usuario.rol == RolUsuario.dueno.valorDb
                                ? Icons.admin_panel_settings_outlined
                                : Icons.person_outline,
                          ),
                          title: Text(usuario.nombreUsuario ?? usuario.nombre),
                          subtitle: Text(
                            usuario.rol == RolUsuario.dueno.valorDb
                                ? 'Administrador'
                                : 'Usuario',
                          ),
                        ),
                    ],
                  ),
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }

  Future<void> _registrar(BuildContext context) async {
    final registrado = await showDialog<UsuarioData>(
      context: context,
      builder: (context) => const _RegistroUsuarioDialog(),
    );
    if (registrado == null || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuario "${registrado.nombreUsuario}" registrado.')),
    );
  }
}

/// Alta de un usuario común vía `/registro`, en la sucursal del equipo.
/// Las reglas replican las del backend para avisar antes de enviar.
class _RegistroUsuarioDialog extends ConsumerStatefulWidget {
  const _RegistroUsuarioDialog();

  @override
  ConsumerState<_RegistroUsuarioDialog> createState() =>
      _RegistroUsuarioDialogState();
}

class _RegistroUsuarioDialogState extends ConsumerState<_RegistroUsuarioDialog> {
  static final _formatoUsuario = RegExp(r'^[a-z0-9._-]{3,32}$');

  final _formKey = GlobalKey<FormState>();
  final _usuario = TextEditingController();
  final _password = TextEditingController();
  final _confirmacion = TextEditingController();
  bool _enviando = false;
  String? _error;

  @override
  void dispose() {
    _usuario.dispose();
    _password.dispose();
    _confirmacion.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_enviando || !_formKey.currentState!.validate()) return;
    setState(() {
      _enviando = true;
      _error = null;
    });
    try {
      final usuario = await ref
          .read(authControllerProvider.notifier)
          .registrarUsuario(nombreUsuario: _usuario.text, password: _password.text);
      if (mounted) Navigator.of(context).pop(usuario);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _enviando = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo usuario'),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usuario,
                autofocus: true,
                enabled: !_enviando,
                decoration: const InputDecoration(
                  labelText: 'Nombre de usuario',
                  helperText: '3 a 32: letras, números, punto, guion o guion bajo',
                ),
                validator: (v) =>
                    _formatoUsuario.hasMatch((v ?? '').trim().toLowerCase())
                    ? null
                    : 'Formato de usuario no válido',
              ),
              TextFormField(
                controller: _password,
                enabled: !_enviando,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (v) => (v ?? '').length < 8 ? 'Mínimo 8 caracteres' : null,
              ),
              TextFormField(
                controller: _confirmacion,
                enabled: !_enviando,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirmar contraseña'),
                validator: (v) =>
                    v != _password.text ? 'Las contraseñas no coinciden' : null,
                onFieldSubmitted: (_) => _enviar(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _enviando ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _enviando ? null : _enviar,
          child: _enviando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Registrar'),
        ),
      ],
    );
  }
}

class _TerminalesSection extends ConsumerWidget {
  const _TerminalesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminalesAsync = ref.watch(_terminalesProvider);
    return _Section(
      titulo: 'Terminales',
      onAgregar: null,
      child: terminalesAsync.when(
        data: (terminales) => Column(
          children: [
            for (final terminal in terminales)
              ListTile(dense: true, title: Text(terminal.nombre), subtitle: Text(terminal.codigo)),
          ],
        ),
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.titulo, required this.child, this.onAgregar});

  final String titulo;
  final Widget child;
  final Future<void> Function()? onAgregar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const Spacer(),
            if (onAgregar != null)
              TextButton.icon(
                onPressed: onAgregar,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Agregar'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

Future<String?> _pedirTexto(BuildContext context, String titulo, String etiqueta) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(titulo),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(labelText: etiqueta),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

Future<(String, int)?> _pedirTipoEnvase(BuildContext context) {
  final nombreController = TextEditingController();
  final depositoController = TextEditingController(text: '0.00');
  return showDialog<(String, int)>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Nuevo tipo de envase'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nombreController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: depositoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Valor del depósito', prefixText: r'$'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final nombre = nombreController.text.trim();
            final deposito = parseCentavosDesdeTexto(depositoController.text) ?? 0;
            if (nombre.isEmpty) {
              Navigator.of(dialogContext).pop();
              return;
            }
            Navigator.of(dialogContext).pop((nombre, deposito));
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}
