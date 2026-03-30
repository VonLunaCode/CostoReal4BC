// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

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
  Future<Response<UserResponse>> _apiV1AuthRegisterPost({
    required UserCreate? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Registra un nuevo usuario en Kitchy.',
      summary: 'Register User',
      operationId: 'register_user_api_v1_auth_register_post',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Autenticación"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/v1/auth/register');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<UserResponse, UserResponse>($request);
  }

  @override
  Future<Response<Token>> _apiV1AuthLoginPost({
    required Map<String, String> body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Inicia sesión y devuelve un Token JWT.
OAuth2 espera que el correo venga en el campo \'username\'.''',
      summary: 'Login For Access Token',
      operationId: 'login_for_access_token_api_v1_auth_login_post',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Autenticación"],
      deprecated: false,
    ),
  }) {
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
      tag: swaggerMetaData,
    );
    return client.send<Token, Token>(
      $request,
      requestConverter: FormUrlEncodedConverter.requestFactory,
    );
  }

  @override
  Future<Response<UserResponse>> _apiV1UsersMeGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          'Ruta protegida que devuelve los datos del usuario dueño del token.',
      summary: 'Read Users Me',
      operationId: 'read_users_me_api_v1_users_me_get',
      consumes: [],
      produces: [],
      security: ["OAuth2PasswordBearer"],
      tags: ["Usuarios"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/api/v1/users/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<UserResponse, UserResponse>($request);
  }

  @override
  Future<Response<dynamic>> _get({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Health Check',
      operationId: 'health_check__get',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Health Check"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
