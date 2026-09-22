import 'package:drift/drift.dart';

import '../app_database.dart';
import 'cuentas_queries.dart';
import 'venta_repository.dart' show ReembolsoTarjetaNoSoportadoException;

/// Espeja el CHECK (condicion IN ('BUENO','DAÑADO')) de la tabla `devolucion`.
enum CondicionDevolucion {
  bueno,
  danado;

  String get valorDb => switch (this) {
    CondicionDevolucion.bueno => 'BUENO',
    CondicionDevolucion.danado => 'DAÑADO',
  };
}

class CantidadExcedeActivaException implements Exception {
  CantidadExcedeActivaException({
    required this.detalleVentaId,
    required this.solicitada,
    required this.activa,
  });

  final int detalleVentaId;
  final int solicitada;
  final int activa;

  @override
  String toString() =>
      'Se pidió devolver $solicitada pero solo quedan $activa unidades activas '
      'en la línea $detalleVentaId (ya devueltas antes o venta con menos cantidad)';
}

class DevolucionRepository {
  DevolucionRepository(this._db);

  final AppDatabase _db;
  late final CuentasQueries _cuentas = CuentasQueries(_db);

  /// Registra la devolución de [cantidad] unidades de [productoId] en la
  /// línea [detalleVentaId] de [ventaId]. Si [condicion] es BUENO, el
  /// producto reingresa a inventario; si es DAÑADO, no. El monto
  /// devuelto es `cantidad * precio_unitario_centavos` de esa línea
  /// (snapshot histórico, no ajustable en esta versión). Primero abona
  /// la deuda pendiente de esa venta (si existiera); el remanente se
  /// devuelve en efectivo vía [cajaSesionId]. Rechaza la operación si la
  /// venta tuvo algún pago con tarjeta.
  Future<int> registrarDevolucion({
    required int ventaId,
    required int detalleVentaId,
    required int productoId,
    required int cantidad,
    required CondicionDevolucion condicion,
    required int usuarioId,
    int? cajaSesionId,
  }) {
    if (cantidad <= 0) {
      throw ArgumentError.value(cantidad, 'cantidad', 'Debe ser mayor que 0');
    }

    return _db.transaction(() async {
      final pagoTarjeta = await (_db.select(_db.pago)..where(
        (p) => p.ventaId.equals(ventaId) & p.metodo.equals('TARJETA'),
      )).getSingleOrNull();
      if (pagoTarjeta != null) {
        throw ReembolsoTarjetaNoSoportadoException(ventaId);
      }

      final detalle = await (_db.select(
        _db.detalleVenta,
      )..where((d) => d.id.equals(detalleVentaId))).getSingle();

      final activa = await _cuentas.cantidadActivaDetalle(detalleVentaId);
      if (cantidad > activa) {
        throw CantidadExcedeActivaException(
          detalleVentaId: detalleVentaId,
          solicitada: cantidad,
          activa: activa,
        );
      }

      final montoDevueltoCentavos = cantidad * detalle.precioUnitarioCentavos;

      final devolucionId = await _db.into(_db.devolucion).insert(
        DevolucionCompanion.insert(
          ventaId: ventaId,
          detalleVentaId: detalleVentaId,
          productoId: productoId,
          cantidad: cantidad,
          montoDevueltoCentavos: montoDevueltoCentavos,
          condicion: condicion.valorDb,
          usuarioId: usuarioId,
        ),
      );

      if (condicion == CondicionDevolucion.bueno) {
        await _db.into(_db.movimientoInventario).insert(
          MovimientoInventarioCompanion.insert(
            productoId: productoId,
            tipo: 'DEVOLUCION',
            cantidad: cantidad,
            referenciaTipo: const Value('DEVOLUCION'),
            referenciaId: Value(devolucionId),
            usuarioId: usuarioId,
          ),
        );
      }

      final deudaPendiente = await _cuentas.deudaPendienteVenta(ventaId);
      var restante = montoDevueltoCentavos;

      if (deudaPendiente > 0) {
        final venta = await (_db.select(
          _db.venta,
        )..where((v) => v.id.equals(ventaId))).getSingle();
        final abono = restante < deudaPendiente ? restante : deudaPendiente;
        await _db.into(_db.cuentaMonetariaMov).insert(
          CuentaMonetariaMovCompanion.insert(
            clienteId: venta.clienteId!,
            ventaId: Value(ventaId),
            tipo: 'ABONO',
            montoCentavos: abono,
            referenciaTipo: const Value('DEVOLUCION'),
            referenciaId: Value(devolucionId),
            usuarioId: usuarioId,
          ),
        );
        restante -= abono;
      }

      if (restante > 0) {
        if (cajaSesionId == null) {
          throw ArgumentError.value(
            cajaSesionId,
            'cajaSesionId',
            'Se requiere una sesión de caja abierta para reembolsar en efectivo',
          );
        }
        await _db.into(_db.movimientoCaja).insert(
          MovimientoCajaCompanion.insert(
            cajaSesionId: cajaSesionId,
            tipo: 'DEVOLUCION',
            montoCentavos: -restante,
            referenciaTipo: const Value('DEVOLUCION'),
            referenciaId: Value(devolucionId),
            usuarioId: usuarioId,
          ),
        );
      }

      return devolucionId;
    });
  }

  Future<List<DevolucionData>> listarPorVenta(int ventaId) {
    return (_db.select(
      _db.devolucion,
    )..where((d) => d.ventaId.equals(ventaId))).get();
  }
}
