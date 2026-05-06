import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../services/cache_service.dart';

/// Provider para la lista completa de recetas
final recetasProvider = FutureProvider.autoDispose<List<RecetaResponse>>((ref) async {
  final api = ref.watch(apiProvider);
  try {
    final response = await api.apiV1RecetasGet();
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Error al obtener recetas');
    }
    final recetas = response.body ?? [];
    await CacheService.instance.cacheRecetas(recetas);
    return recetas;
  } catch (_) {
    final cached = CacheService.instance.getRecetasOffline();
    if (cached.isNotEmpty) return cached;
    rethrow;
  }
});

/// Provider para una receta individual por ID
final recetaDetailProvider = FutureProvider.autoDispose.family<RecetaResponse, String>((ref, id) async {
  final api = ref.watch(apiProvider);
  try {
    final response = await api.apiV1RecetasIdGet(id: id);
    if (!response.isSuccessful) {
      throw Exception(response.error ?? 'Error al obtener el detalle de la receta');
    }
    if (response.body == null) throw Exception('Receta no encontrada');
    return response.body!;
  } catch (_) {
    final cached = CacheService.instance.getRecetaOffline(id);
    if (cached != null) return cached;
    rethrow;
  }
});
