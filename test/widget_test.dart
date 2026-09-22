import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pos_mg/app/app.dart';
import 'package:pos_mg/app/providers.dart';
import 'package:pos_mg/app/session_providers.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:pos_mg/features/compras/controllers/compra_controllers.dart';
import 'package:pos_mg/features/historial/controllers/sale_history_controllers.dart';

void main() {
  testWidgets('El shell de navegación muestra Ventas por defecto', (
    WidgetTester tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          // Los smoke tests de UI no necesitan ejercitar los streams
          // reactivos de Drift (ya cubiertos por los tests de
          // repositorio) — se sustituyen por streams estáticos para
          // evitar un Timer interno de Drift que `flutter_test` marca
          // como pendiente al desmontar el árbol de widgets.
          sesionCajaAbiertaProvider.overrideWith((ref) => Stream.value(null)),
          ventasHistorialProvider.overrideWith((ref) => Stream.value(const [])),
          comprasHistorialProvider.overrideWith((ref) => Stream.value(const [])),
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
  });
}
