import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppFlavor { dev, prod }

class AppConfig {
  final String baseUrl;
  final AppFlavor flavor;

  AppConfig({required this.baseUrl, required this.flavor});
}

// Emulador: flutter run
// Dispositivo físico: flutter run --dart-define=API_HOST=192.168.100.50
const _apiHost = String.fromEnvironment('API_HOST', defaultValue: '10.0.2.2');

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig(
    baseUrl: 'http://$_apiHost:8000/',
    flavor: AppFlavor.dev,
  );
});
