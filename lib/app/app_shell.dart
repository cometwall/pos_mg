import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/caja/screens/caja_screen.dart';
import '../features/clientes/screens/client_list_screen.dart';
import '../features/compras/screens/compras_screen.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/configuracion/screens/configuracion_screen.dart';
import '../features/historial/screens/sales_history_screen.dart';
import '../features/inventario/screens/envase_stock_screen.dart';
import '../features/productos/screens/product_list_screen.dart';
import '../features/ventas/screens/sales_screen.dart';
import 'session_providers.dart';

/// Shell de navegación principal: un rail lateral persistente con
/// "Ventas" siempre como primera sección (la pantalla de inicio del
/// POS), más las secciones secundarias ordenadas por frecuencia de uso
/// real. `IndexedStack` mantiene vivo el estado de cada sección al
/// cambiar entre ellas (p. ej. no se pierde el carrito de Ventas si el
/// cajero revisa Historial a media venta) — pero como consecuencia,
/// TODAS las secciones están montadas en todo momento (no solo la
/// visible). Por eso cualquier `FloatingActionButton` en una pantalla de
/// sección necesita su propio `heroTag` explícito: sin él, Flutter les
/// asigna a todos el mismo tag por defecto y la animación Hero de
/// cualquier navegación revienta con "multiple heroes share the same
/// tag" en cuanto hay más de un FAB en el árbol simultáneamente.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _seccionActiva = 0;

  static const _secciones = <_SeccionNav>[
    _SeccionNav(
      etiqueta: 'Ventas',
      icono: Icons.point_of_sale_outlined,
      iconoSeleccionado: Icons.point_of_sale,
      screen: SalesScreen(),
    ),
    _SeccionNav(
      etiqueta: 'Historial',
      icono: Icons.history_outlined,
      iconoSeleccionado: Icons.history,
      screen: SalesHistoryScreen(),
    ),
    _SeccionNav(
      etiqueta: 'Caja',
      icono: Icons.point_of_sale_outlined,
      iconoSeleccionado: Icons.savings,
      screen: CajaScreen(),
    ),
    _SeccionNav(
      etiqueta: 'Productos',
      icono: Icons.inventory_2_outlined,
      iconoSeleccionado: Icons.inventory_2,
      screen: ProductListScreen(),
    ),
    _SeccionNav(
      etiqueta: 'Clientes',
      icono: Icons.people_outline,
      iconoSeleccionado: Icons.people,
      screen: ClientListScreen(),
    ),
    _SeccionNav(
      etiqueta: 'Inventario',
      icono: Icons.inventory_outlined,
      iconoSeleccionado: Icons.inventory,
      screen: EnvaseStockScreen(),
    ),
    _SeccionNav(
      etiqueta: 'Compras',
      icono: Icons.local_shipping_outlined,
      iconoSeleccionado: Icons.local_shipping,
      screen: ComprasScreen(),
    ),
    _SeccionNav(
      etiqueta: 'Configuración',
      icono: Icons.settings_outlined,
      iconoSeleccionado: Icons.settings,
      screen: ConfiguracionScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _seccionActiva,
            onDestinationSelected: (indice) {
              setState(() => _seccionActiva = indice);
            },
            labelType: NavigationRailLabelType.all,
            // Con el bloque de sesión al final, las 8 secciones ya no
            // caben en ventanas bajas.
            scrollable: true,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'POS MG',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            trailing: const _SesionActual(),
            destinations: [
              for (final seccion in _secciones)
                NavigationRailDestination(
                  icon: Icon(seccion.icono),
                  selectedIcon: Icon(seccion.iconoSeleccionado),
                  label: Text(seccion.etiqueta),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: _seccionActiva,
              children: [for (final seccion in _secciones) seccion.screen],
            ),
          ),
        ],
      ),
    );
  }
}

/// Usuario de la sesión, aviso de modo offline y botón para salir.
class _SesionActual extends ConsumerWidget {
  const _SesionActual();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesion = ref.watch(authControllerProvider);
    if (sesion == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          const SizedBox(width: 56, child: Divider()),
          Icon(
            sesion.esAdmin
                ? Icons.admin_panel_settings_outlined
                : Icons.person_outline,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 80,
            child: Text(
              sesion.usuario.nombre,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
          ),
          if (sesion.esOffline)
            Tooltip(
              message:
                  'Sesión iniciada sin conexión con el servidor. Las funciones '
                  'de administrador no están disponibles.',
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 14,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Sin conexión',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => _cerrarSesion(context, ref),
          ),
        ],
      ),
    );
  }

  /// Con la caja abierta se permite salir, pero se avisa: el siguiente
  /// usuario seguirá operando sobre esa misma sesión de caja.
  Future<void> _cerrarSesion(BuildContext context, WidgetRef ref) async {
    final cajaAbierta = ref.read(sesionCajaAbiertaProvider).value != null;
    if (cajaAbierta) {
      final confirmado = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('La caja sigue abierta'),
          content: const Text(
            'Si cierras sesión sin hacer el corte, el siguiente usuario '
            'continuará esta misma sesión de caja. ¿Cerrar sesión de todos '
            'modos?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      );
      if (confirmado != true) return;
    }
    ref.read(authControllerProvider.notifier).cerrarSesion();
  }
}

class _SeccionNav {
  const _SeccionNav({
    required this.etiqueta,
    required this.icono,
    required this.iconoSeleccionado,
    required this.screen,
  });

  final String etiqueta;
  final IconData icono;
  final IconData iconoSeleccionado;
  final Widget screen;
}
