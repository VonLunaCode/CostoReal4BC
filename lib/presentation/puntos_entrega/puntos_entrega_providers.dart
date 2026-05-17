import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';

/// Provider que obtiene la lista de puntos de entrega activos.
final puntosEntregaProvider = FutureProvider.autoDispose<List<PuntoEntregaRead>>((ref) async {
  final api = ref.watch(apiProvider);
  
  final response = await api.apiV1PuntosEntregaGet();
  if (response.isSuccessful && response.body != null) {
    return response.body!;
  } else {
    throw Exception('Error al cargar puntos de entrega: ${response.error}');
  }
});

/// Notifier para manejar las operaciones CRUD de puntos de entrega.
class PuntoEntregaNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  PuntoEntregaNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> create(PuntoEntregaCreate data) async {
    state = const AsyncValue.loading();
    final api = ref.read(apiProvider);
    try {
      final response = await api.apiV1PuntosEntregaPost(body: data);
      if (response.isSuccessful) {
        state = const AsyncValue.data(null);
        ref.invalidate(puntosEntregaProvider);
      } else {
        state = AsyncValue.error(
          response.error ?? 'Error al crear punto de entrega',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update(String id, PuntoEntregaUpdate data) async {
    state = const AsyncValue.loading();
    final api = ref.read(apiProvider);
    try {
      final response = await api.apiV1PuntosEntregaPuntoEntregaIdPut(
        puntoEntregaId: id,
        body: data,
      );
      if (response.isSuccessful) {
        state = const AsyncValue.data(null);
        ref.invalidate(puntosEntregaProvider);
      } else {
        state = AsyncValue.error(
          response.error ?? 'Error al actualizar punto de entrega',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> delete(String id) async {
    state = const AsyncValue.loading();
    final api = ref.read(apiProvider);
    try {
      final response = await api.apiV1PuntosEntregaPuntoEntregaIdDelete(
        puntoEntregaId: id,
      );
      if (response.isSuccessful) {
        state = const AsyncValue.data(null);
        ref.invalidate(puntosEntregaProvider);
      } else {
        state = AsyncValue.error(
          response.error ?? 'Error al eliminar punto de entrega',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final puntoEntregaNotifierProvider =
    StateNotifierProvider<PuntoEntregaNotifier, AsyncValue<void>>((ref) {
  return PuntoEntregaNotifier(ref);
});
