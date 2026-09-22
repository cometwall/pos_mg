import '../../../core/quantity.dart';
import '../../../database/repositories/envase_repository.dart';

/// Una línea del carrito de venta en progreso. Vive 100% en memoria hasta
/// que la venta se cobra — no corresponde a ninguna fila de `detalle_venta`
/// todavía.
class SaleCartLine {
  const SaleCartLine({
    required this.productoId,
    required this.nombre,
    required this.esPorPeso,
    required this.cantidad,
    required this.precioUnitarioCentavos,
    this.costoReferenciaCentavos,
    this.tipoEnvaseId,
    this.operacionEnvase,
  });

  final int productoId;
  final String nombre;

  /// `false` = pieza (cantidad en piezas). `true` = peso (cantidad en
  /// GRAMOS; [precioUnitarioCentavos] es el precio de catálogo por
  /// KILOGRAMO, no por gramo).
  final bool esPorPeso;

  final int cantidad;
  final int precioUnitarioCentavos;
  final int? costoReferenciaCentavos;
  final int? tipoEnvaseId;

  /// Depósito cobrado o préstamo de envase asociado a esta línea, si el
  /// cajero lo configuró. `null` = sin operación de envase para esta
  /// línea (el caso más común).
  final OperacionEnvaseVenta? operacionEnvase;

  int get subtotalCentavos => esPorPeso
      ? subtotalPorPeso(precioPorKiloCentavos: precioUnitarioCentavos, gramos: cantidad)
      : subtotalPorPieza(precioUnitarioCentavos: precioUnitarioCentavos, piezas: cantidad);

  SaleCartLine copyWith({
    int? cantidad,
    OperacionEnvaseVenta? operacionEnvase,
    bool limpiarOperacionEnvase = false,
  }) {
    return SaleCartLine(
      productoId: productoId,
      nombre: nombre,
      esPorPeso: esPorPeso,
      cantidad: cantidad ?? this.cantidad,
      precioUnitarioCentavos: precioUnitarioCentavos,
      costoReferenciaCentavos: costoReferenciaCentavos,
      tipoEnvaseId: tipoEnvaseId,
      operacionEnvase: limpiarOperacionEnvase ? null : (operacionEnvase ?? this.operacionEnvase),
    );
  }
}
