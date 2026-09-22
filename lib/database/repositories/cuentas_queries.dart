import 'package:drift/drift.dart';

import '../app_database.dart';

/// Las "funciones clave" de saldo pendiente que varios repositories
/// necesitan (venta, compra, devolución, envase). No tiene estado propio:
/// solo agrupa consultas de solo lectura sobre el mismo [AppDatabase] que
/// ya usa el repository que la instancia, para no duplicar el SQL que
/// espeja cada trigger de tope (sección 10.6 de schema.drift).
class CuentasQueries {
  const CuentasQueries(this._db);

  final AppDatabase _db;

  /// Espeja trg_monetaria_no_excede_pendiente: SUM(CARGO) - SUM(ABONO) -
  /// SUM(CANCELACION) para esa venta. 0 si no hay movimientos.
  Future<int> deudaPendienteVenta(int ventaId) async {
    final fila = await _db.customSelect(
      '''
      SELECT COALESCE(SUM(CASE tipo WHEN 'CARGO' THEN monto_centavos ELSE -monto_centavos END), 0) AS pendiente
      FROM cuenta_monetaria_mov WHERE venta_id = ?
      ''',
      variables: [Variable.withInt(ventaId)],
      readsFrom: {_db.cuentaMonetariaMov},
    ).getSingle();
    return fila.read<int>('pendiente');
  }

  /// Espeja trg_envase_no_excede_prestamo para esa venta + tipo de envase.
  Future<int> envasePendienteVenta(int ventaId, int tipoEnvaseId) async {
    final fila = await _db.customSelect(
      '''
      SELECT COALESCE(SUM(CASE tipo WHEN 'PRESTAMO' THEN cantidad ELSE -cantidad END), 0) AS pendiente
      FROM cuenta_envase_mov WHERE venta_id = ? AND tipo_envase_id = ?
      ''',
      variables: [Variable.withInt(ventaId), Variable.withInt(tipoEnvaseId)],
      readsFrom: {_db.cuentaEnvaseMov},
    ).getSingle();
    return fila.read<int>('pendiente');
  }

  /// Espeja trg_deposito_no_excede_cobrado para esa venta + tipo de envase.
  Future<int> depositoPendienteVenta(int ventaId, int tipoEnvaseId) async {
    final fila = await _db.customSelect(
      '''
      SELECT COALESCE(SUM(CASE tipo WHEN 'COBRADO' THEN cantidad ELSE -cantidad END), 0) AS pendiente
      FROM cuenta_deposito_envase_mov WHERE venta_id = ? AND tipo_envase_id = ?
      ''',
      variables: [Variable.withInt(ventaId), Variable.withInt(tipoEnvaseId)],
      readsFrom: {_db.cuentaDepositoEnvaseMov},
    ).getSingle();
    return fila.read<int>('pendiente');
  }

  /// detalle.cantidad - SUM(devolucion.cantidad) para esa línea. No hay
  /// trigger que lo respalde: es responsabilidad 100% de esta capa.
  Future<int> cantidadActivaDetalle(int detalleVentaId) async {
    final detalle = await (_db.select(
      _db.detalleVenta,
    )..where((d) => d.id.equals(detalleVentaId))).getSingle();

    final devuelta = await _db.customSelect(
      'SELECT COALESCE(SUM(cantidad), 0) AS total FROM devolucion WHERE detalle_venta_id = ?',
      variables: [Variable.withInt(detalleVentaId)],
      readsFrom: {_db.devolucion},
    ).getSingle();

    return detalle.cantidad - devuelta.read<int>('total');
  }

  /// tipo_envase_id distintos con algún movimiento de depósito en esa
  /// venta (para poder iterarlos al cancelar).
  Future<List<int>> tiposEnvaseConDepositoEnVenta(int ventaId) async {
    final filas = await _db.customSelect(
      'SELECT DISTINCT tipo_envase_id FROM cuenta_deposito_envase_mov WHERE venta_id = ?',
      variables: [Variable.withInt(ventaId)],
      readsFrom: {_db.cuentaDepositoEnvaseMov},
    ).get();
    return filas.map((f) => f.read<int>('tipo_envase_id')).toList();
  }

  /// tipo_envase_id distintos con algún préstamo en esa venta.
  Future<List<int>> tiposEnvaseConPrestamoEnVenta(int ventaId) async {
    final filas = await _db.customSelect(
      'SELECT DISTINCT tipo_envase_id FROM cuenta_envase_mov WHERE venta_id = ?',
      variables: [Variable.withInt(ventaId)],
      readsFrom: {_db.cuentaEnvaseMov},
    ).get();
    return filas.map((f) => f.read<int>('tipo_envase_id')).toList();
  }

  /// SUM(cantidad) de envase_inventario_mov para un tipo de envase. No
  /// existe una tabla materializada de saldo de envase (a diferencia de
  /// inventario_saldo para producto), así que esto recorre el historial
  /// completo cada vez.
  Future<int> saldoFisicoEnvase(int tipoEnvaseId) async {
    final fila = await _db.customSelect(
      'SELECT COALESCE(SUM(cantidad), 0) AS total FROM envase_inventario_mov WHERE tipo_envase_id = ?',
      variables: [Variable.withInt(tipoEnvaseId)],
      readsFrom: {_db.envaseInventarioMov},
    ).getSingle();
    return fila.read<int>('total');
  }
}
