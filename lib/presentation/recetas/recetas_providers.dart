import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';

/// Provider para la lista completa de recetas
final recetasProvider = FutureProvider.autoDispose<List<RecetaResponse>>((ref) async {
  final api = ref.watch(apiProvider);
  final response = await api.apiV1RecetasGet();

  if (!response.isSuccessful) {
    throw Exception(response.error ?? 'Error al obtener recetas');
  }

  return response.body ?? [];
});

/// Provider para una receta individual por ID
final recetaDetailProvider = FutureProvider.autoDispose.family<RecetaResponse, String>((ref, id) async {
  final api = ref.watch(apiProvider);
  final response = await api.apiV1RecetasIdGet(id: id);
  
  if (!response.isSuccessful) {
    throw Exception(response.error ?? 'Error al obtener el detalle de la receta');
  }
  
  if (response.body == null) {
    throw Exception('Receta no encontrada');
  }
  
  return response.body!;
});
