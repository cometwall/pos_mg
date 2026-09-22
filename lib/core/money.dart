/// Utilidades para trabajar con montos en centavos (INTEGER en SQLite).
///
/// Todo el dinero en el dominio se guarda como centavos enteros; estas
/// funciones son el único lugar donde se formatea o se interpreta texto
/// escrito por el usuario para convertirlo a centavos.
library;

/// Formatea centavos como texto de moneda, p. ej. `15250` -> `$152.50`.
String formatCentavos(int centavos) {
  final signo = centavos < 0 ? '-' : '';
  final absolutos = centavos.abs();
  final pesos = absolutos ~/ 100;
  final restoCentavos = absolutos % 100;
  final pesosTexto = _conSeparadorDeMiles(pesos);
  return '$signo\$$pesosTexto.${restoCentavos.toString().padLeft(2, '0')}';
}

String _conSeparadorDeMiles(int valor) {
  final digitos = valor.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digitos.length; i++) {
    final posicionDesdeElFinal = digitos.length - i;
    if (i > 0 && posicionDesdeElFinal % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digitos[i]);
  }
  return buffer.toString();
}

/// Interpreta texto escrito por el usuario (p. ej. `"152.5"`, `"152"`,
/// `"152,50"`) como centavos. Devuelve `null` si el texto no es un monto
/// válido. No acepta negativos: los montos que el usuario teclea en la UI
/// (cobro, efectivo inicial, etc.) siempre son cantidades positivas.
int? parseCentavosDesdeTexto(String texto) {
  final normalizado = texto.trim().replaceAll(',', '.');
  if (normalizado.isEmpty) return null;
  final valor = double.tryParse(normalizado);
  if (valor == null || valor < 0) return null;
  return (valor * 100).round();
}
