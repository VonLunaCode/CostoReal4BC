import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_interceptor.dart';
import '../core/app_config.dart';
import 'api_generated/openapi.swagger.dart';
import 'storage_service.dart';

/// Provider que instancia el cliente de la API con los interceptores necesarios.
final apiProvider = Provider<Openapi>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(storageServiceProvider);

  return Openapi.create(
    baseUrl: Uri.parse(config.baseUrl),
    interceptors: [
      AuthInterceptor(storage),
    ],
  );
});
