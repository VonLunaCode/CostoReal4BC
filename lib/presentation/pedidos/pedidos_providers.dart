import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../services/cache_service.dart';

/// Provider que guarda el estado del filtro actual ('pendiente', 'en_preparacion', 'listo', o nulo para todos).
final pedidosFilterProvider = StateProvider<String?>((ref) => null);

/// Provider que obtiene la lista de pedidos de la API, reaccionando a cambios en el filtro.
final pedidosProvider = FutureProvider.autoDispose<List<PedidoResponse>>((ref) async {
  final api = ref.watch(apiProvider);
  final estadoFilter = ref.watch(pedidosFilterProvider);

  try {
    final response = await api.apiV1PedidosGet(estado: estadoFilter);
    if (response.isSuccessful && response.body != null) {
      final pedidos = response.body!;
      pedidos.sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
      if (estadoFilter == null) {
        await CacheService.instance.cachePedidos(pedidos);
      }
      return pedidos;
    } else {
      throw Exception('Error al cargar pedidos: ${response.error}');
    }
  } catch (_) {
    final cached = CacheService.instance.getPedidosOffline();
    if (cached.isNotEmpty) return cached;
    rethrow;
  }
});

/// Provider para obtener el detalle de un pedido
final pedidoDetailProvider = FutureProvider.autoDispose.family<PedidoResponse, String>((ref, id) async {
  final api = ref.watch(apiProvider);
  try {
    final response = await api.apiV1PedidosPedidoIdGet(pedidoId: id);
    if (response.isSuccessful && response.body != null) return response.body!;
    throw Exception('Error al cargar detalle del pedido: ${response.error}');
  } catch (_) {
    final cached = CacheService.instance.getPedidoOffline(id);
    if (cached != null) return cached;
    rethrow;
  }
});
