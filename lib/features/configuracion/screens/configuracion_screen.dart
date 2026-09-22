import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/money.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/catalogo_repository.dart';

final _categoriasProvider = FutureProvider<List<CategoriaData>>(
  (ref) => ref.watch(categoriaRepositoryProvider).listarTodas(),
);
final _tiposEnvaseProvider = FutureProvider<List<TipoEnvaseData>>(
  (ref) => ref.watch(tipoEnvaseRepositoryProvider).listarActivos(),
);
final _usuariosProvider = FutureProvider<List<UsuarioData>>(
  (ref) => ref.watch(usuarioRepositoryProvider).listarActivos(),
);
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
        children: const [
          _CategoriasSection(),
          Divider(height: 32),
          _TiposEnvaseSection(),
          Divider(height: 32),
          _UsuariosSection(),
          Divider(height: 32),
          _TerminalesSection(),
        ],
      ),
    );
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
    return _Section(
      titulo: 'Usuarios',
      onAgregar: () async {
        final nombre = await _pedirTexto(context, 'Nuevo usuario', 'Nombre');
        if (nombre == null || nombre.isEmpty) return;
        await ref.read(usuarioRepositoryProvider).crear(nombre: nombre, rol: RolUsuario.cajero);
        ref.invalidate(_usuariosProvider);
      },
      child: usuariosAsync.when(
        data: (usuarios) => Column(
          children: [
            for (final usuario in usuarios)
              ListTile(dense: true, title: Text(usuario.nombre), subtitle: Text(usuario.rol)),
          ],
        ),
        loading: () => const LinearProgressIndicator(),
        error: (error, _) => Text('Error: $error'),
      ),
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
