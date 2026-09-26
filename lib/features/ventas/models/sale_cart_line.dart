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
    this.operacionesEnvase = const [],
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

  /// Operaciones de envase asociadas a esta línea, si el cajero las
  /// configuró — puede haber varias combinadas para la misma línea (ej.
  /// 2 envases entregados en intercambio + 1 con depósito cobrado, para
  /// cubrir 3 unidades del producto). Lista vacía = sin operación de
  /// envase configurada (el caso más común).
  final List<OperacionEnvaseVenta> operacionesEnvase;

  int get subtotalCentavos => esPorPeso
      ? subtotalPorPeso(precioPorKiloCentavos: precioUnitarioCentavos, gramos: cantidad)
      : subtotalPorPieza(precioUnitarioCentavos: precioUnitarioCentavos, piezas: cantidad);

  SaleCartLine copyWith({
    int? cantidad,
    List<OperacionEnvaseVenta>? operacionesEnvase,
  }) {
    return SaleCartLine(
      productoId: productoId,
      nombre: nombre,
      esPorPeso: esPorPeso,
      cantidad: cantidad ?? this.cantidad,
      precioUnitarioCentavos: precioUnitarioCentavos,
      costoReferenciaCentavos: costoReferenciaCentavos,
      tipoEnvaseId: tipoEnvaseId,
      operacionesEnvase: operacionesEnvase ?? this.operacionesEnvase,
    );
  }
}
