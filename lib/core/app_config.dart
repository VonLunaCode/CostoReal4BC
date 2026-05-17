import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppFlavor { dev, prod }

class AppConfig {
  final String baseUrl;
  final AppFlavor flavor;

  AppConfig({required this.baseUrl, required this.flavor});
}

// Permite cambiar de entorno fácilmente con: --dart-define=ENV=entorno
// Opciones: emu, home, uni, prod. (Vacio = automático)
const _env = String.fromEnvironment('ENV', defaultValue: '');

String _getBaseUrl() {
  // MAGIA ACÁ: Si no pasaste ningún flag y es un build release, asume 'prod'. Si no, 'emu'.
  final envToUse = _env.isEmpty ? (kReleaseMode ? 'prod' : 'emu') : _env;

  switch (envToUse) {
    case 'prod':
      // API en producción (Cloudflare Tunnel)
      return 'https://kitchy.vonlunant.site/';
    case 'home':
      // IP de tu red en casa
      return 'http://192.168.100.50:8000/';
    case 'uni':
      // IP que te da el teléfono al compartir datos en la uni
      return 'http://192.168.43.1:8000/';
    case 'emu':
    default:
      // Emulador de Android
      return 'http://10.0.2.2:8000/';
  }
}

final appConfigProvider = Provider<AppConfig>((ref) {
  final isProd = _env == 'prod' || (kReleaseMode && _env.isEmpty);
  
  return AppConfig(
    baseUrl: _getBaseUrl(),
    flavor: isProd ? AppFlavor.prod : AppFlavor.dev,
  );
});
