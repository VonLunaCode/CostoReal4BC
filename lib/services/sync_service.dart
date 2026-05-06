import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../core/app_config.dart';
import '../data/storage_service.dart';

class SyncService {
  static final SyncService instance = SyncService._();
  SyncService._();

  String? _baseUrl;
  StorageService? _storage;
  StreamSubscription? _subscription;
  bool _syncing = false;

  void init(String baseUrl, StorageService storage) {
    if (_subscription != null) return;
    _baseUrl = baseUrl;
    _storage = storage;

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasNetwork = results.any((r) =>
          r == ConnectivityResult.wifi || r == ConnectivityResult.mobile);
      if (hasNetwork) syncPendingChanges();
    });
  }

  Future<void> agregarACola(
      String endpoint, Map<String, dynamic> body, String method) async {
    final box = Hive.box('offline_queue');
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await box.put(
        key,
        jsonEncode({
          'endpoint': endpoint,
          'body': body,
          'method': method,
          'timestamp': key,
        }));
  }

  Future<void> syncPendingChanges() async {
    if (_syncing || _baseUrl == null || _storage == null) return;
    _syncing = true;

    try {
      final box = Hive.box('offline_queue');
      final keys = box.keys.cast<String>().toList()..sort();
      if (keys.isEmpty) return;

      final token = await _storage!.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      for (final key in keys) {
        final stored = box.get(key) as String?;
        if (stored == null) continue;

        final item = jsonDecode(stored) as Map<String, dynamic>;
        final uri = Uri.parse('$_baseUrl${item['endpoint']}');
        final bodyStr = jsonEncode(item['body']);

        try {
          final response = await _send(
            method: item['method'] as String,
            uri: uri,
            headers: headers,
            body: bodyStr,
          );

          if (response == null) continue; // unknown method

          if (response.statusCode >= 200 && response.statusCode < 300) {
            await box.delete(key);
          } else if (response.statusCode >= 400 && response.statusCode < 500) {
            await box.delete(key); // datos inválidos, no reintentable
          }
          // 5xx: se mantiene en cola
        } catch (_) {
          // timeout o sin red: se mantiene en cola
        }
      }
    } finally {
      _syncing = false;
    }
  }

  Future<http.Response?> _send({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    required String body,
  }) {
    const timeout = Duration(seconds: 10);
    switch (method.toUpperCase()) {
      case 'POST':
        return http.post(uri, headers: headers, body: body).timeout(timeout);
      case 'PUT':
        return http.put(uri, headers: headers, body: body).timeout(timeout);
      case 'PATCH':
        return http.patch(uri, headers: headers, body: body).timeout(timeout);
      default:
        return Future.value(null);
    }
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(storageServiceProvider);
  SyncService.instance.init(config.baseUrl, storage);
  return SyncService.instance;
});
