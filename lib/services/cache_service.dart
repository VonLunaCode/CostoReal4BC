import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/api_generated/openapi.models.swagger.dart';

class CacheService {
  static final CacheService instance = CacheService._();
  CacheService._();

  static const _keyPedidos = 'pedidos_list';
  static const _keyRecetas = 'recetas_list';
  static const _keyInsumos = 'insumos_list';

  Future<void> cachePedidos(List<PedidoResponse> pedidos) async {
    final box = Hive.box('pedidos');
    await box.put(_keyPedidos, jsonEncode(pedidos.map((e) => e.toJson()).toList()));
  }

  Future<void> cacheRecetas(List<RecetaResponse> recetas) async {
    final box = Hive.box('recetas');
    await box.put(_keyRecetas, jsonEncode(recetas.map((e) => e.toJson()).toList()));
  }

  Future<void> cacheInsumos(List<InsumoResponse> insumos) async {
    final box = Hive.box('insumos');
    await box.put(_keyInsumos, jsonEncode(insumos.map((e) => e.toJson()).toList()));
  }

  List<PedidoResponse> getPedidosOffline() {
    final box = Hive.box('pedidos');
    final stored = box.get(_keyPedidos) as String?;
    if (stored == null) return [];
    return (jsonDecode(stored) as List)
        .map((j) => PedidoResponse.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  List<RecetaResponse> getRecetasOffline() {
    final box = Hive.box('recetas');
    final stored = box.get(_keyRecetas) as String?;
    if (stored == null) return [];
    return (jsonDecode(stored) as List)
        .map((j) => RecetaResponse.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  List<InsumoResponse> getInsumosOffline() {
    final box = Hive.box('insumos');
    final stored = box.get(_keyInsumos) as String?;
    if (stored == null) return [];
    return (jsonDecode(stored) as List)
        .map((j) => InsumoResponse.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> cacheMovimientos(String insumoId, List<MovimientoResponse> movimientos) async {
    final box = Hive.box('movimientos');
    await box.put(insumoId, jsonEncode(movimientos.map((e) => e.toJson()).toList()));
  }

  List<MovimientoResponse> getMovimientosOffline(String insumoId) {
    final box = Hive.box('movimientos');
    final stored = box.get(insumoId) as String?;
    if (stored == null) return [];
    return (jsonDecode(stored) as List)
        .map((j) => MovimientoResponse.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  RecetaResponse? getRecetaOffline(String id) {
    final list = getRecetasOffline();
    try {
      return list.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  PedidoResponse? getPedidoOffline(String id) {
    final list = getPedidosOffline();
    try {
      return list.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  InsumoResponse? getInsumoOffline(String id) {
    final list = getInsumosOffline();
    try {
      return list.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
  }
}
