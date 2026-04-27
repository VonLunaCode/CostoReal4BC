// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openapi.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Openapi extends Openapi {
  _$Openapi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Openapi;

  @override
  Future<Response<UserResponse>> _apiV1AuthRegisterPost(
      {required UserCreate? body}) {
    final Uri $url = Uri.parse('/api/v1/auth/register');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<UserResponse, UserResponse>($request);
  }

  @override
  Future<Response<Token>> _apiV1AuthLoginPost(
      {required Map<String, String> body}) {
    final Uri $url = Uri.parse('/api/v1/auth/login');
    final Map<String, String> $headers = {
      'content-type': 'application/x-www-form-urlencoded',
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<Token, Token>(
      $request,
      requestConverter: FormUrlEncodedConverter.requestFactory,
    );
  }

  @override
  Future<Response<UserResponse>> _apiV1UsersMeGet() {
    final Uri $url = Uri.parse('/api/v1/users/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<UserResponse, UserResponse>($request);
  }

  @override
  Future<Response<List<InsumoResponse>>> _apiV1InsumosGet() {
    final Uri $url = Uri.parse('/api/v1/insumos/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<InsumoResponse>, InsumoResponse>($request);
  }

  @override
  Future<Response<InsumoResponse>> _apiV1InsumosPost(
      {required InsumoCreate? body}) {
    final Uri $url = Uri.parse('/api/v1/insumos/');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<InsumoResponse, InsumoResponse>($request);
  }

  @override
  Future<Response<InsumoResponse>> _apiV1InsumosIdGet({required String? id}) {
    final Uri $url = Uri.parse('/api/v1/insumos/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<InsumoResponse, InsumoResponse>($request);
  }

  @override
  Future<Response<InsumoResponse>> _apiV1InsumosIdPut({
    required String? id,
    required InsumoUpdate? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/insumos/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<InsumoResponse, InsumoResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1InsumosIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/api/v1/insumos/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<InsumoResponse>> _apiV1InsumosIdMovimientosPost({
    required String? id,
    required MovimientoCreate? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/insumos/${id}/movimientos');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<InsumoResponse, InsumoResponse>($request);
  }

  @override
  Future<Response<List<MovimientoResponse>>> _apiV1InsumosIdMovimientosGet({
    required String? id,
    int? limit,
  }) {
    final Uri $url = Uri.parse('/api/v1/insumos/${id}/movimientos');
    final Map<String, dynamic> $params = <String, dynamic>{'limit': limit};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<MovimientoResponse>, MovimientoResponse>($request);
  }

  @override
  Future<Response<List<RecetaResponse>>> _apiV1RecetasGet() {
    final Uri $url = Uri.parse('/api/v1/recetas/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<RecetaResponse>, RecetaResponse>($request);
  }

  @override
  Future<Response<RecetaResponse>> _apiV1RecetasPost(
      {required RecetaCreate? body}) {
    final Uri $url = Uri.parse('/api/v1/recetas/');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<RecetaResponse, RecetaResponse>($request);
  }

  @override
  Future<Response<RecetaResponse>> _apiV1RecetasIdGet({required String? id}) {
    final Uri $url = Uri.parse('/api/v1/recetas/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<RecetaResponse, RecetaResponse>($request);
  }

  @override
  Future<Response<RecetaResponse>> _apiV1RecetasIdPut({
    required String? id,
    required RecetaUpdate? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/recetas/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<RecetaResponse, RecetaResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1RecetasIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/api/v1/recetas/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Object>> _apiV1RecetasIdCosteoGet({required String? id}) {
    final Uri $url = Uri.parse('/api/v1/recetas/${id}/costeo');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<GastoOcultoResponse>> _apiV1RecetasIdGastosOcultosPost({
    required String? id,
    required GastoOcultoCreate? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/recetas/${id}/gastos-ocultos');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<GastoOcultoResponse, GastoOcultoResponse>($request);
  }

  @override
  Future<Response<GastoOcultoResponse>>
      _apiV1RecetasIdGastosOcultosTipoTogglePatch({
    required String? id,
    required String? tipo,
    required ToggleGastoRequest? body,
  }) {
    final Uri $url =
        Uri.parse('/api/v1/recetas/${id}/gastos-ocultos/${tipo}/toggle');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<GastoOcultoResponse, GastoOcultoResponse>($request);
  }

  @override
  Future<Response<PedidoResponse>> _apiV1PedidosPost(
      {required PedidoCreate? body}) {
    final Uri $url = Uri.parse('/api/v1/pedidos/');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<PedidoResponse, PedidoResponse>($request);
  }

  @override
  Future<Response<List<PedidoResponse>>> _apiV1PedidosGet({
    String? estado,
    int? limit,
    int? offset,
  }) {
    final Uri $url = Uri.parse('/api/v1/pedidos/');
    final Map<String, dynamic> $params = <String, dynamic>{
      'estado': estado,
      'limit': limit,
      'offset': offset,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<PedidoResponse>, PedidoResponse>($request);
  }

  @override
  Future<Response<PedidoResponse>> _apiV1PedidosPedidoIdGet(
      {required String? pedidoId}) {
    final Uri $url = Uri.parse('/api/v1/pedidos/${pedidoId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<PedidoResponse, PedidoResponse>($request);
  }

  @override
  Future<Response<PedidoResponse>> _apiV1PedidosPedidoIdPut({
    required String? pedidoId,
    required dynamic body,
  }) {
    final Uri $url = Uri.parse('/api/v1/pedidos/${pedidoId}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<PedidoResponse, PedidoResponse>($request);
  }

  @override
  Future<Response<PedidoResponse>> _apiV1PedidosPedidoIdDelete(
      {required String? pedidoId}) {
    final Uri $url = Uri.parse('/api/v1/pedidos/${pedidoId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<PedidoResponse, PedidoResponse>($request);
  }

  @override
  Future<Response<PedidoResponse>> _apiV1PedidosPedidoIdEstadoPatch({
    required String? pedidoId,
    required String? nuevoEstado,
  }) {
    final Uri $url = Uri.parse('/api/v1/pedidos/${pedidoId}/estado');
    final Map<String, dynamic> $params = <String, dynamic>{
      'nuevo_estado': nuevoEstado
    };
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<PedidoResponse, PedidoResponse>($request);
  }

  @override
  Future<Response<dynamic>> _get() {
    final Uri $url = Uri.parse('/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
