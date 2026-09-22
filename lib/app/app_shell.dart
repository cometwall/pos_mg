import 'package:flutter/material.dart';

import '../features/caja/screens/caja_screen.dart';
import '../features/clientes/screens/client_list_screen.dart';
import '../features/compras/screens/compras_screen.dart';
import '../features/configuracion/screens/configuracion_screen.dart';
import '../features/historial/screens/sales_history_screen.dart';
import '../features/productos/screens/product_list_screen.dart';
import '../features/ventas/screens/sales_screen.dart';

/// Shell de navegación principal: un rail lateral persistente con
/// "Ventas" siempre como primera sección (la pantalla de inicio del
/// POS), más las secciones secundarias ordenadas por frecuencia de uso
/// real. `IndexedStack` mantiene vivo el estado de cada sección al
/// cambiar entre ellas (p. ej. no se pierde el carrito de Ventas si el
/// cajero revisa Historial a media venta).
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
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'POS MG',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
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
