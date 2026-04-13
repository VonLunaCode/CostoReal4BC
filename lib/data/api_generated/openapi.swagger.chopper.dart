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
