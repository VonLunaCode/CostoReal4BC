import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../core/api_interceptor.dart';
import '../core/app_config.dart';
import 'api_generated/openapi.swagger.dart';
import 'storage_service.dart';

class _TimeoutClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _inner.send(request).timeout(const Duration(seconds: 3));
}

final apiProvider = Provider<Openapi>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(storageServiceProvider);

  return Openapi.create(
    baseUrl: Uri.parse(config.baseUrl),
    interceptors: [AuthInterceptor(storage)],
    httpClient: _TimeoutClient(),
  );
});
