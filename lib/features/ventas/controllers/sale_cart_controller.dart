import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../database/app_database.dart';
import '../../../database/repositories/envase_repository.dart';
import '../models/sale_cart_line.dart';

/// Estado en memoria de la venta en progreso: líneas del carrito y el
/// cliente opcionalmente asociado. Nada de esto se persiste hasta que la
/// venta se cobra (`SaleCheckoutService`); abandonar la venta simplemente
/// descarta este estado.
class SaleCartState {
  const SaleCartState({this.lineas = const [], this.clienteId, this.clienteNombre});

  final List<SaleCartLine> lineas;
  final int? clienteId;
  final String? clienteNombre;

  bool get estaVacio => lineas.isEmpty;

  int get subtotalCentavos =>
      lineas.fold<int>(0, (acc, linea) => acc + linea.subtotalCentavos);

  SaleCartState copyWith({List<SaleCartLine>? lineas}) {
    return SaleCartState(
      lineas: lineas ?? this.lineas,
      clienteId: clienteId,
      clienteNombre: clienteNombre,
    );
  }
}

class SaleCartController extends Notifier<SaleCartState> {
  @override
  SaleCartState build() => const SaleCartState();

  /// Agrega un producto al carrito. Si ya existe una línea para ese
  /// producto, suma la cantidad en vez de crear una línea duplicada
  /// (piezas repetidas se acumulan; peso repetido suma gramos).
  void agregarProducto(ProductoData producto, {required int cantidadInicial}) {
    final esPorPeso = producto.unidad == 'peso';
    final indiceExistente = state.lineas.indexWhere(
      (l) => l.productoId == producto.id,
    );

    if (indiceExistente != -1) {
      final actual = state.lineas[indiceExistente];
      final nuevas = [...state.lineas];
      nuevas[indiceExistente] = actual.copyWith(
        cantidad: actual.cantidad + cantidadInicial,
      );
      state = state.copyWith(lineas: nuevas);
      return;
    }

    final nuevaLinea = SaleCartLine(
      productoId: producto.id,
      nombre: producto.nombre,
      esPorPeso: esPorPeso,
      cantidad: cantidadInicial,
      precioUnitarioCentavos: producto.precioVentaCentavos,
      costoReferenciaCentavos: producto.costoReferenciaCentavos,
      tipoEnvaseId: producto.tipoEnvaseId,
    );
    state = state.copyWith(lineas: [...state.lineas, nuevaLinea]);
  }

  void actualizarCantidad(int productoId, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      eliminarLinea(productoId);
      return;
    }
    state = state.copyWith(
      lineas: [
        for (final linea in state.lineas)
          if (linea.productoId == productoId)
            linea.copyWith(cantidad: nuevaCantidad)
          else
            linea,
      ],
    );
  }

  /// Configura (o quita, con `operacion: null`) la operación de envase
  /// de una línea (depósito cobrado o préstamo). No aplica a productos
  /// sin `tipoEnvaseId`.
  void configurarEnvase(int productoId, OperacionEnvaseVenta? operacion) {
    state = state.copyWith(
      lineas: [
        for (final linea in state.lineas)
          if (linea.productoId == productoId)
            linea.copyWith(operacionEnvase: operacion, limpiarOperacionEnvase: operacion == null)
          else
            linea,
      ],
    );
  }

  void eliminarLinea(int productoId) {
    state = state.copyWith(
      lineas: state.lineas.where((l) => l.productoId != productoId).toList(),
    );
  }

  void asociarCliente({required int id, required String nombre}) {
    state = SaleCartState(lineas: state.lineas, clienteId: id, clienteNombre: nombre);
  }

  void quitarCliente() {
    state = SaleCartState(lineas: state.lineas);
  }

  void limpiar() {
    state = const SaleCartState();
  }
}

final saleCartControllerProvider = NotifierProvider<SaleCartController, SaleCartState>(
  SaleCartController.new,
);

/// Texto de búsqueda de producto (estado de pantalla puro, no persiste).
class BusquedaProductoController extends Notifier<String> {
  @override
  String build() => '';

  void actualizar(String texto) => state = texto;
}

final busquedaProductoProvider = NotifierProvider<BusquedaProductoController, String>(
  BusquedaProductoController.new,
);

/// Resultados de búsqueda: coincidencia parcial por nombre o exacta por
/// código de barras/código interno (ver `ProductoRepository.buscar`).
/// Con texto vacío, muestra el catálogo activo completo — es la
/// aproximación más simple a la "grid de productos frecuentes" del
/// diseño mientras no exista conteo de frecuencia de venta.
final resultadosBusquedaProductoProvider = FutureProvider<List<ProductoData>>((ref) {
  final query = ref.watch(busquedaProductoProvider);
  return ref.watch(productoRepositoryProvider).buscar(query);
});
