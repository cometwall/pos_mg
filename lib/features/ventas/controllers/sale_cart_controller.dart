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

  /// Suma de los depósitos de envase configurados en las líneas
  /// (`TipoOperacionEnvase.depositoCobrado`). El préstamo sin depósito y
  /// entregar/recibir no suman aquí porque no implican cobrar dinero.
  /// No forma parte de `subtotalCentavos`/`venta.total_centavos` (el
  /// esquema los trata como conceptos independientes — ver
  /// schema.drift), pero sí debe sumarse al monto que el cajero cobra
  /// físicamente al cliente.
  int get depositoEnvaseCentavos => lineas.fold<int>(0, (acc, linea) {
    return linea.operacionesEnvase
        .where((o) => o.tipo == TipoOperacionEnvase.depositoCobrado)
        .fold(acc, (acc, o) => acc + o.cantidad * (o.montoUnitarioCentavos ?? 0));
  });

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

  /// Reemplaza el cuadro completo de operaciones de envase de una línea
  /// (depósito cobrado, préstamo, entregado, recibido — puede haber
  /// varias combinadas). Lista vacía = sin operación. No aplica a
  /// productos sin `tipoEnvaseId`.
  void configurarEnvase(int productoId, List<OperacionEnvaseVenta> operaciones) {
    state = state.copyWith(
      lineas: [
        for (final linea in state.lineas)
          if (linea.productoId == productoId)
            linea.copyWith(operacionesEnvase: operaciones)
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

  /// Quita el cliente asociado. "Prestar sin depósito" y "Cobrar
  /// depósito" exigen cliente (ver `EnvaseSinClienteException`), así que
  /// cualquier línea configurada con esas operaciones queda huérfana sin
  /// cliente — se limpia aquí mismo para que el carrito nunca muestre una
  /// operación que ya no se puede cobrar.
  void quitarCliente() {
    state = SaleCartState(
      lineas: [
        for (final linea in state.lineas)
          linea.copyWith(
            operacionesEnvase: linea.operacionesEnvase
                .where(
                  (o) =>
                      o.tipo != TipoOperacionEnvase.prestado &&
                      o.tipo != TipoOperacionEnvase.depositoCobrado,
                )
                .toList(),
          ),
      ],
    );
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
///
/// Es un `StreamProvider` (no `FutureProvider`) a propósito: usa
/// `ProductoRepository.observarBusqueda`, reactivo a cualquier alta o
/// edición de producto — sin esto, un precio o nombre editado en
/// Productos se seguía viendo desactualizado en la búsqueda de Ventas.
final resultadosBusquedaProductoProvider = StreamProvider<List<ProductoData>>((ref) {
  final query = ref.watch(busquedaProductoProvider);
  return ref.watch(productoRepositoryProvider).observarBusqueda(query);
});
