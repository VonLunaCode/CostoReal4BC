import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppFlavor { dev, prod }

class AppConfig {
  final String baseUrl;
  final AppFlavor flavor;

  AppConfig({required this.baseUrl, required this.flavor});
}

/// Provider que maneja la configuración del entorno.
/// Para el emulador Samsung S25 Ultra (Android), usamos 10.0.2.2 para conectar al Docker local.
final appConfigProvider = Provider<AppConfig>((ref) {
  // TODO: Implementar lógica de alternancia real (dart-define) si es necesario.
  return AppConfig(
    baseUrl: 'http://10.0.2.2:8000', 
    flavor: AppFlavor.dev,
  );
});
