import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api_provider.dart';
import 'dart:async';
import '../data/storage_service.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState({required this.status, this.errorMessage});

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Inicializa chequeando el token de manera asíncrona
    Future.microtask(() => _checkStatus());
    return AuthState(status: AuthStatus.loading);
  }

  /// Verifica si hay un token persistente y si es válido.
  Future<void> _checkStatus() async {
    final storage = ref.read(storageServiceProvider);
    final api = ref.read(apiProvider);
    final token = await storage.getToken();
    
    if (token != null) {
      final response = await api.apiV1UsersMeGet();
      if (response.isSuccessful) {
        state = AuthState(status: AuthStatus.authenticated);
        return;
      }
    }
    state = AuthState(status: AuthStatus.unauthenticated);
  }

  /// Proceso de Login.
  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    final storage = ref.read(storageServiceProvider);
    final api = ref.read(apiProvider);
    
    // FastAPI OAuth2PasswordRequestForm espera 'username' y 'password'
    final response = await api.apiV1AuthLoginPost(
      body: {'username': email, 'password': password},
    );

    if (response.isSuccessful && response.body != null) {
      final token = response.body?.accessToken;
      if (token != null) {
        await storage.saveToken(token);
      }
      state = AuthState(status: AuthStatus.authenticated);
    } else {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Error en Login: Comprueba tus credenciales',
      );
    }
  }

  /// Proceso de Cierre de Sesión.
  Future<void> logout() async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteToken();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

/// Provider para manejar el estado de autenticación de la app.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
