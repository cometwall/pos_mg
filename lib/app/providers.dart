import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/repositories/caja_repository.dart';
import '../database/repositories/catalogo_repository.dart';
import '../database/repositories/cliente_repository.dart';
import '../database/repositories/compra_repository.dart';
import '../database/repositories/cuentas_queries.dart';
import '../database/repositories/devolucion_repository.dart';
import '../database/repositories/envase_repository.dart';
import '../database/repositories/inventario_repository.dart';
import '../database/repositories/pago_repository.dart';
import '../database/repositories/producto_repository.dart';
import '../database/repositories/venta_repository.dart';

/// Instancia única de la base de datos para toda la app. Se cierra
/// automáticamente cuando el provider deja de tener escuchas (nunca en
/// la práctica, ya que vive en el árbol raíz vía `ProviderScope`).
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final terminalRepositoryProvider = Provider<TerminalRepository>(
  (ref) => TerminalRepository(ref.watch(appDatabaseProvider)),
);

final usuarioRepositoryProvider = Provider<UsuarioRepository>(
  (ref) => UsuarioRepository(ref.watch(appDatabaseProvider)),
);

final categoriaRepositoryProvider = Provider<CategoriaRepository>(
  (ref) => CategoriaRepository(ref.watch(appDatabaseProvider)),
);

final tipoEnvaseRepositoryProvider = Provider<TipoEnvaseRepository>(
  (ref) => TipoEnvaseRepository(ref.watch(appDatabaseProvider)),
);

final proveedorRepositoryProvider = Provider<ProveedorRepository>(
  (ref) => ProveedorRepository(ref.watch(appDatabaseProvider)),
);

final productoRepositoryProvider = Provider<ProductoRepository>(
  (ref) => ProductoRepository(ref.watch(appDatabaseProvider)),
);

final inventarioRepositoryProvider = Provider<InventarioRepository>(
  (ref) => InventarioRepository(ref.watch(appDatabaseProvider)),
);

final clienteRepositoryProvider = Provider<ClienteRepository>(
  (ref) => ClienteRepository(ref.watch(appDatabaseProvider)),
);

final cajaRepositoryProvider = Provider<CajaRepository>(
  (ref) => CajaRepository(ref.watch(appDatabaseProvider)),
);

final pagoRepositoryProvider = Provider<PagoRepository>(
  (ref) => PagoRepository(ref.watch(appDatabaseProvider)),
);

final ventaRepositoryProvider = Provider<VentaRepository>(
  (ref) => VentaRepository(ref.watch(appDatabaseProvider)),
);

final compraRepositoryProvider = Provider<CompraRepository>(
  (ref) => CompraRepository(ref.watch(appDatabaseProvider)),
);

final devolucionRepositoryProvider = Provider<DevolucionRepository>(
  (ref) => DevolucionRepository(ref.watch(appDatabaseProvider)),
);

final envaseRepositoryProvider = Provider<EnvaseRepository>(
  (ref) => EnvaseRepository(ref.watch(appDatabaseProvider)),
);

final cuentasQueriesProvider = Provider<CuentasQueries>(
  (ref) => CuentasQueries(ref.watch(appDatabaseProvider)),
);
