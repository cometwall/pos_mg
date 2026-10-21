import 'package:flutter/material.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pos_mg/app/app.dart';
import 'package:pos_mg/app/providers.dart';
import 'package:pos_mg/app/session_providers.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/features/auth/controllers/auth_controller.dart';
import 'package:pos_mg/features/auth/services/auth_service.dart';
import 'package:pos_mg/features/compras/controllers/compra_controllers.dart';
import 'package:pos_mg/features/historial/controllers/sale_history_controllers.dart';
import 'package:pos_mg/features/productos/screens/product_list_screen.dart';
import 'package:pos_mg/features/ventas/controllers/sale_cart_controller.dart';

/// Arranca con una sesión ya iniciada para no depender del backend.
class _SesionIniciada extends AuthController {
  _SesionIniciada(this.sesion);

  final SesionUsuario sesion;

  @override
  SesionUsuario? build() => sesion;
}

void main() {
  testWidgets('sin sesión se muestra el login', (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          dispositivoConfigProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const PosApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Inicia sesión para continuar'), findsOneWidget);
    expect(find.text('Historial'), findsNothing);
  });

  testWidgets('El shell de navegación muestra Ventas por defecto', (
    WidgetTester tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final usuario = await tester.runAsync(() async {
      final id = await db
          .into(db.usuario)
          .insert(UsuarioCompanion.insert(nombre: 'ana', rol: 'CAJERO'));
      return (db.select(db.usuario)..where((u) => u.id.equals(id))).getSingle();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          authControllerProvider.overrideWith(
            () => _SesionIniciada(
              SesionUsuario(usuario: usuario!, modo: ModoSesion.offline),
            ),
          ),
          dispositivoConfigProvider.overrideWith((ref) => Stream.value(null)),
          // Los smoke tests de UI no necesitan ejercitar los streams
          // reactivos de Drift (ya cubiertos por los tests de
          // repositorio) — se sustituyen por streams estáticos para
          // evitar un Timer interno de Drift que `flutter_test` marca
          // como pendiente al desmontar el árbol de widgets.
          sesionCajaAbiertaProvider.overrideWith((ref) => Stream.value(null)),
          ventasHistorialProvider.overrideWith((ref) => Stream.value(const [])),
          comprasHistorialProvider.overrideWith((ref) => Stream.value(const [])),
          resultadosBusquedaProductoProvider.overrideWith((ref) => Stream.value(const [])),
          productosActivosProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const PosApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Buscar producto o escanear código de barras'), findsOneWidget);

    await tester.tap(find.text('Historial'));
    await tester.pumpAndSettle();

    expect(find.text('Buscar por folio'), findsOneWidget);
    expect(find.text('Sin ventas todavía'), findsOneWidget);
    expect(find.text('Sin conexión'), findsOneWidget);

    // Un usuario común no ve la gestión de usuarios.
    await tester.tap(find.text('Configuración'));
    await tester.pumpAndSettle();
    expect(find.text('Equipo'), findsOneWidget);
    expect(find.text('Usuarios'), findsNothing);

    await tester.ensureVisible(find.byTooltip('Cerrar sesión'));
    await tester.tap(find.byTooltip('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Inicia sesión para continuar'), findsOneWidget);
  });

  testWidgets('cerrar sesión con la caja abierta pide confirmación', (
    WidgetTester tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final usuario = await tester.runAsync(() async {
      final id = await db
          .into(db.usuario)
          .insert(UsuarioCompanion.insert(nombre: 'ana', rol: 'CAJERO'));
      return (db.select(db.usuario)..where((u) => u.id.equals(id))).getSingle();
    });
    const cajaAbierta = CajaSesionData(
      id: 1,
      terminalId: 1,
      usuarioAperturaId: 1,
      fechaApertura: '2026-10-20 08:00:00',
      efectivoInicialCentavos: 50000,
      estado: 'ABIERTA',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          authControllerProvider.overrideWith(
            () => _SesionIniciada(
              SesionUsuario(usuario: usuario!, modo: ModoSesion.online),
            ),
          ),
          sesionCajaAbiertaProvider.overrideWith(
            (ref) => Stream.value(cajaAbierta),
          ),
          dispositivoConfigProvider.overrideWith((ref) => Stream.value(null)),
          ventasHistorialProvider.overrideWith((ref) => Stream.value(const [])),
          comprasHistorialProvider.overrideWith((ref) => Stream.value(const [])),
          resultadosBusquedaProductoProvider.overrideWith((ref) => Stream.value(const [])),
          productosActivosProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const PosApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byTooltip('Cerrar sesión'));
    await tester.tap(find.byTooltip('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('La caja sigue abierta'), findsOneWidget);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Inicia sesión para continuar'), findsNothing);

    await tester.tap(find.byTooltip('Cerrar sesión'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Inicia sesión para continuar'), findsOneWidget);

    // Con la caja abierta, Caja escucha streams de Drift que no vale la
    // pena sustituir aquí: se desmonta el árbol y se deja correr el
    // Timer(0) con el que Drift cierra sus streams.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  });

  testWidgets('un admin ve la sección Usuarios en Configuración', (
    WidgetTester tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final admin = await tester.runAsync(() async {
      final id = await db
          .into(db.usuario)
          .insert(UsuarioCompanion.insert(nombre: 'jefa', rol: 'DUEÑO'));
      return (db.select(db.usuario)..where((u) => u.id.equals(id))).getSingle();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          authControllerProvider.overrideWith(
            () => _SesionIniciada(
              SesionUsuario(usuario: admin!, modo: ModoSesion.online),
            ),
          ),
          dispositivoConfigProvider.overrideWith((ref) => Stream.value(null)),
          sesionCajaAbiertaProvider.overrideWith((ref) => Stream.value(null)),
          ventasHistorialProvider.overrideWith((ref) => Stream.value(const [])),
          comprasHistorialProvider.overrideWith((ref) => Stream.value(const [])),
          resultadosBusquedaProductoProvider.overrideWith((ref) => Stream.value(const [])),
          productosActivosProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const PosApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Configuración'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Usuarios'),
      200,
      scrollable: find
          .ancestor(of: find.text('Equipo'), matching: find.byType(Scrollable))
          .first,
    );
    expect(find.text('Usuarios'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  });
}
