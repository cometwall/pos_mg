# POS MG

Aplicación de punto de venta (POS) desarrollada en Flutter, con soporte multiplataforma (Windows, Linux) y persistencia local mediante Drift (SQLite).

## Características principales

El proyecto está organizado por módulos (feature-first), cada uno con sus propios controllers, screens y widgets:

- **Autenticación (auth)**: login de usuarios contra Supabase Edge Functions, con caída automática a modo offline si no hay red o el backend no está configurado.
- **Caja**: apertura/cierre de caja y control de movimientos.
- **Clientes**: gestión de clientes.
- **Compras**: registro de compras a proveedores, incluyendo cancelaciones.
- **Configuración**: ajustes generales de la aplicación.
- **Historial**: historial de ventas y detalle de cada venta.
- **Inventario**: control de stock de productos, envases y devoluciones.
- **Productos**: gestión del catálogo de productos.
- **Ventas**: registro y gestión de ventas (por unidad, peso y envase), pagos y cancelaciones.

## Tecnologías

- [Flutter](https://flutter.dev/) (Dart SDK ^3.13.0)
- [Drift](https://drift.simonbinder.eu/) + `drift_flutter` para la base de datos local (SQLite)
- `flutter_riverpod` para el manejo de estado
- `dio` para las llamadas HTTP al backend (Supabase Edge Functions)
- `cryptography` para el hashing/verificación de credenciales
- `path_provider` para el acceso al sistema de archivos
- `cupertino_icons` para íconos de estilo iOS

### Dependencias de desarrollo

- `drift_dev` + `build_runner` para generar el código de la base de datos
- `flutter_lints` para reglas de análisis estático
- `flutter_test` para pruebas
- `sqlite3` para ejecutar la base de datos en los tests

## Estructura del proyecto

```
lib/
  app/            # Configuración raíz de la app y providers de Riverpod
  core/           # Tipos comunes (money, quantity) y configuración del backend (backend_config, dio_provider)
  database/        # Definición de la base de datos (schema.drift), código generado por Drift y repositorios
  features/        # Módulos de la aplicación (auth, caja, clientes, compras, etc.)
  shared/          # Widgets, diálogos, layouts y tema reutilizables
```

## Primeros pasos

1. Instala las dependencias:

   ```powershell
   flutter pub get
   ```

2. Configura las credenciales del backend copiando `env.json.example` a `env.json` y completando los valores de tu proyecto de Supabase (este archivo está ignorado por git):

   ```powershell
   Copy-Item env.json.example env.json
   ```

   Sin este archivo, la app sigue funcionando pero el login opera en modo offline.

3. Genera el código de la base de datos (Drift) si modificas `schema.drift` o los DAOs:

   ```powershell
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Ejecuta la aplicación (Windows), pasando las credenciales del backend con `--dart-define-from-file`:

   ```powershell
   flutter run -d windows --dart-define-from-file=env.json
   ```

   También puedes usar la configuración de lanzamiento "pos_mg (env.json)" incluida en `.vscode/launch.json`.

## Tests

El proyecto cuenta con pruebas de los repositorios, de autenticación (con un backend falso en `test/support`) y de flujos completos (ventas por peso/envase, pagos, cancelaciones, devoluciones, migraciones, etc.) en la carpeta `test/`:

```powershell
flutter test
```

## Recursos de Flutter

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de Drift](https://drift.simonbinder.eu/docs/)
