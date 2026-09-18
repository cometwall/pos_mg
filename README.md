# POS MG

Aplicación de punto de venta (POS) desarrollada en Flutter, con soporte multiplataforma (Windows, Linux) y persistencia local mediante Drift (SQLite).

## Características principales

El proyecto está organizado por módulos (feature-first), cada uno con sus propios controllers, screens y widgets:

- **Caja**: apertura/cierre de caja y control de movimientos.
- **Clientes**: gestión de clientes.
- **Compras**: registro de compras a proveedores.
- **Configuración**: ajustes generales de la aplicación.
- **Inventario**: control de stock de productos.
- **Login**: autenticación de usuarios.
- **Productos**: gestión del catálogo de productos.
- **Ventas**: registro y gestión de ventas.

## Tecnologías

- [Flutter](https://flutter.dev/) (Dart SDK ^3.13.0)
- [Drift](https://drift.simonbinder.eu/) + `drift_flutter` para la base de datos local (SQLite)
- `path_provider` para el acceso al sistema de archivos
- `cupertino_icons` para íconos de estilo iOS

### Dependencias de desarrollo

- `drift_dev` + `build_runner` para generar el código de la base de datos
- `flutter_lints` para reglas de análisis estático
- `flutter_test` para pruebas

## Estructura del proyecto

```
lib/
  app/            # Configuración raíz de la app
  core/           # Constantes, errores, extensiones y servicios comunes
  database/        # Definición de la base de datos (schema.drift) y código generado por Drift
  features/        # Módulos de la aplicación (caja, clientes, compras, etc.)
  shared/          # Widgets, diálogos y layouts reutilizables
```

## Primeros pasos

1. Instala las dependencias:

   ```powershell
   flutter pub get
   ```

2. Genera el código de la base de datos (Drift) si modificas `schema.drift` o los DAOs:

   ```powershell
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Ejecuta la aplicación (Windows):

   ```powershell
   flutter run -d windows
   ```

## Recursos de Flutter

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de Drift](https://drift.simonbinder.eu/docs/)
