import 'package:drift/drift.dart';

import '../app_database.dart';

/// Espeja el CHECK (metodo IN ('EFECTIVO','TARJETA')) de la tabla `pago`.
enum MetodoPago {
  efectivo,
  tarjeta;

  String get valorDb => switch (this) {
    MetodoPago.efectivo => 'EFECTIVO',
    MetodoPago.tarjeta => 'TARJETA',
  };
}

class PagoRepository {
  PagoRepository(this._db);

  final AppDatabase _db;

  /// Registra un pago contra una venta ya existente. `pago` no maneja
  /// efectivo físico (eso es `movimiento_caja`, exclusivo de
  /// tarjeta/efectivo aplicado a la venta): esta llamada por sí sola
  /// NO mueve caja aunque el método sea EFECTIVO — para el flujo de
  /// cobro completo (pago + caja en una sola transacción) usa
  /// `VentaRepository.registrarVentaConPago`.
  ///
  /// La base rechaza el insert si la venta está CANCELADA o si la
  /// suma de pagos excedería `venta.total_centavos`.
  Future<int> registrarPago({
    required int ventaId,
    required MetodoPago metodo,
    required int montoCentavos,
    int ivaCentavos = 0,
  }) {
    return _db.into(_db.pago).insert(
      PagoCompanion.insert(
        ventaId: ventaId,
        metodo: metodo.valorDb,
        montoCentavos: montoCentavos,
        ivaCentavos: Value(ivaCentavos),
      ),
    );
  }

  Future<List<PagoData>> listarPagos(int ventaId) {
    return (_db.select(
      _db.pago,
    )..where((p) => p.ventaId.equals(ventaId))).get();
  }
}
