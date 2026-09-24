import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../database/repositories/envase_repository.dart';
import '../../../database/repositories/venta_repository.dart';
import '../models/sale_cart_line.dart';

/// Resultado de intentar cobrar una venta: éxito con los datos para la
/// pantalla de "venta completada", o fallo con un mensaje ya traducido a
/// español listo para mostrarse al cajero (nunca una excepción cruda).
sealed class CheckoutResultado {
  const CheckoutResultado();
}

class CheckoutExitoso extends CheckoutResultado {
  const CheckoutExitoso({
    required this.ventaId,
    required this.folio,
    required this.totalCentavos,
  });

  final int ventaId;
  final String folio;
  final int totalCentavos;
}

class CheckoutFallido extends CheckoutResultado {
  const CheckoutFallido(this.mensaje);

  final String mensaje;
}

class SaleCheckoutService {
  SaleCheckoutService(this._ventaRepo);

  final VentaRepository _ventaRepo;

  Future<CheckoutResultado> cobrar({
    required int terminalId,
    required int usuarioId,
    required int? cajaSesionId,
    required int? clienteId,
    required List<SaleCartLine> lineas,
    required List<Cobro> cobros,
  }) async {
    final folio = 'V${DateTime.now().microsecondsSinceEpoch}';
    final items = [
      for (final linea in lineas)
        ItemVenta(
          productoId: linea.productoId,
          cantidad: linea.cantidad,
          // Para peso, `cantidad` son gramos: `precioUnitarioCentavos` y
          // `costoUnitarioCentavos` deben guardarse por gramo (no por
          // kilogramo) para que devoluciones/cancelaciones futuras —que
          // multiplican cantidad activa * precio guardado— den el monto
          // correcto. El subtotal real de la venta no depende de esto:
          // va aparte, ya calculado con precisión, en `subtotalCentavos`.
          precioUnitarioCentavos: linea.esPorPeso
              ? linea.precioUnitarioCentavos ~/ 1000
              : linea.precioUnitarioCentavos,
          costoUnitarioCentavos: linea.esPorPeso
              ? (linea.costoReferenciaCentavos ?? 0) ~/ 1000
              : (linea.costoReferenciaCentavos ?? 0),
          subtotalCentavos: linea.subtotalCentavos,
        ),
    ];
    final operacionesEnvase = [
      for (final linea in lineas)
        if (linea.operacionEnvase != null) linea.operacionEnvase!,
    ];

    try {
      final ventaId = await _ventaRepo.registrarVentaConPago(
        terminalId: terminalId,
        folio: folio,
        usuarioId: usuarioId,
        items: items,
        cobros: cobros,
        clienteId: clienteId,
        cajaSesionId: cajaSesionId,
        operacionesEnvase: operacionesEnvase,
      );
      final total = items.fold<int>(0, (acc, item) => acc + item.subtotalCentavos);
      return CheckoutExitoso(ventaId: ventaId, folio: folio, totalCentavos: total);
    } on StockInsuficienteException catch (e) {
      return CheckoutFallido(
        'No hay suficiente stock disponible (pediste ${e.solicitado}, hay ${e.disponible}). '
        'Ajusta la cantidad en el carrito.',
      );
    } on PagoIncompletoException catch (_) {
      return const CheckoutFallido('El cobro no cubre exactamente el total de la venta.');
    } on EnvasePrestadoSinClienteException catch (_) {
      return const CheckoutFallido(
        'Prestar un envase requiere asociar un cliente a la venta.',
      );
    } on DepositoSinMontoException catch (_) {
      return const CheckoutFallido('Falta el monto del depósito de envase.');
    } on StockEnvaseInsuficienteException catch (e) {
      return CheckoutFallido(
        'No hay suficientes envases disponibles (pediste ${e.solicitado}, hay ${e.disponible}).',
      );
    } on ArgumentError catch (e) {
      return CheckoutFallido(e.message?.toString() ?? 'Datos de cobro inválidos.');
    }
  }
}

final saleCheckoutServiceProvider = Provider<SaleCheckoutService>(
  (ref) => SaleCheckoutService(ref.watch(ventaRepositoryProvider)),
);
