import 'dart:async';
import 'package:chopper/chopper.dart';
import '../data/storage_service.dart';

/// Interceptor que inyecta automáticamente el token JWT en las peticiones.
class AuthInterceptor implements Interceptor {
  final StorageService _storage;

  AuthInterceptor(this._storage);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    final request = chain.request;

    // Si la ruta es pública (login/register), no añadimos el token.
    if (request.uri.path.contains('auth/login') || request.uri.path.contains('auth/register')) {
      return chain.proceed(request);
    }

    final token = await _storage.getToken();

    if (token != null && token.isNotEmpty) {
      final newRequest = applyHeader(request, 'Authorization', 'Bearer $token');
      return chain.proceed(newRequest);
    }
    
    return chain.proceed(request);
  }
}

