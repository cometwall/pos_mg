/// Utilidades para cantidades de productos.
///
/// El esquema guarda `unidad='pieza'` en piezas enteras y `unidad='peso'`
/// en GRAMOS enteros (con `precio_venta_centavos` expresado por
/// kilogramo). La UI siempre trabaja con kilogramos hacia el usuario y
/// convierte a gramos solo al hablar con la base de datos.
library;

/// Convierte gramos (como se guardan en la base) a kilogramos para mostrar.
double gramosAKilogramos(int gramos) => gramos / 1000;

/// Convierte kilogramos escritos por el usuario a gramos enteros para
/// guardar. Redondea al gramo más cercano.
int kilogramosAGramos(double kilogramos) => (kilogramos * 1000).round();

/// Calcula el subtotal en centavos para una línea de producto por peso,
/// dado el precio por kilogramo y la cantidad en gramos.
int subtotalPorPeso({
  required int precioPorKiloCentavos,
  required int gramos,
}) {
  return (precioPorKiloCentavos * gramos) ~/ 1000;
}

/// Calcula el subtotal en centavos para una línea de producto por pieza.
int subtotalPorPieza({
  required int precioUnitarioCentavos,
  required int piezas,
}) {
  return precioUnitarioCentavos * piezas;
}
