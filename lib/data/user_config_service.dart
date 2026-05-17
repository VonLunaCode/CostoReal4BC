import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../core/app_config.dart';
import 'storage_service.dart';

class UserConfigData {
  final String id;
  final String email;
  final String plan;
  final double empaqueDefault;
  final double desgasteDefault;

  const UserConfigData({
    required this.id,
    required this.email,
    required this.plan,
    required this.empaqueDefault,
    required this.desgasteDefault,
  });

  factory UserConfigData.fromJson(Map<String, dynamic> json) {
    return UserConfigData(
      id: json['id'] as String,
      email: json['email'] as String,
      plan: json['plan'] as String? ?? 'free',
      empaqueDefault: double.tryParse(json['empaque_mxn_default']?.toString() ?? '') ?? 0.0,
      desgasteDefault: double.tryParse(json['desgaste_pct_default']?.toString() ?? '') ?? 0.0,
    );
  }
}

class UserConfigService {
  final String _baseUrl;
  final StorageService _storage;

  UserConfigService({required String baseUrl, required StorageService storage})
      : _baseUrl = baseUrl,
        _storage = storage;

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<UserConfigData> getUserConfig() async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${_baseUrl}api/v1/users/me');
    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Error al cargar la configuración del usuario');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return UserConfigData.fromJson(json);
  }

  Future<void> updateConfig({
    required double empaqueMxnDefault,
    required double desgastePctDefault,
  }) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('${_baseUrl}api/v1/users/config');
    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode({
        'empaque_mxn_default': empaqueMxnDefault,
        'desgaste_pct_default': desgastePctDefault,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al guardar la configuración');
    }
  }
}

final userConfigServiceProvider = Provider<UserConfigService>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(storageServiceProvider);
  return UserConfigService(baseUrl: config.baseUrl, storage: storage);
});

final userConfigProvider = FutureProvider.autoDispose<UserConfigData>((ref) {
  final service = ref.watch(userConfigServiceProvider);
  return service.getUserConfig();
});
