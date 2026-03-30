// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element_parameter

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';
import 'dart:convert';

import 'openapi.models.swagger.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'openapi.metadata.swagger.dart';
export 'openapi.models.swagger.dart';

part 'openapi.swagger.chopper.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Openapi extends ChopperService {
  static Openapi create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Openapi(client);
    }

    final newClient = ChopperClient(
      services: [_$Openapi()],
      converter: converter ?? $JsonSerializableConverter(),
      interceptors: interceptors ?? [],
      client: httpClient,
      authenticator: authenticator,
      errorConverter: errorConverter,
      baseUrl: baseUrl ?? Uri.parse('http://'),
    );
    return _$Openapi(newClient);
  }

  ///Register User
  Future<chopper.Response<UserResponse>> apiV1AuthRegisterPost({
    required UserCreate? body,
  }) {
    generatedMapping.putIfAbsent(
      UserResponse,
      () => UserResponse.fromJsonFactory,
    );

    return _apiV1AuthRegisterPost(body: body);
  }

  ///Register User
  @POST(path: '/api/v1/auth/register', optionalBody: true)
  Future<chopper.Response<UserResponse>> _apiV1AuthRegisterPost({
    @Body() required UserCreate? body,
    @chopper.Tag()
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
  });

  ///Login For Access Token
  Future<chopper.Response<Token>> apiV1AuthLoginPost({
    required Map<String, String> body,
  }) {
    generatedMapping.putIfAbsent(Token, () => Token.fromJsonFactory);

    return _apiV1AuthLoginPost(body: body);
  }

  ///Login For Access Token
  @POST(
    path: '/api/v1/auth/login',
    headers: {contentTypeKey: formEncodedHeaders},
  )
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<chopper.Response<Token>> _apiV1AuthLoginPost({
    @Body() required Map<String, String> body,
    @chopper.Tag()
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
  });

  ///Read Users Me
  Future<chopper.Response<UserResponse>> apiV1UsersMeGet() {
    generatedMapping.putIfAbsent(
      UserResponse,
      () => UserResponse.fromJsonFactory,
    );

    return _apiV1UsersMeGet();
  }

  ///Read Users Me
  @GET(path: '/api/v1/users/me')
  Future<chopper.Response<UserResponse>> _apiV1UsersMeGet({
    @chopper.Tag()
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
  });

  ///Health Check
  Future<chopper.Response> get() {
    return _get();
  }

  ///Health Check
  @GET(path: '/')
  Future<chopper.Response> _get({
    @chopper.Tag()
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
  });
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
    chopper.Response response,
  ) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
        body:
            DateTime.parse((response.body as String).replaceAll('"', ''))
                as ResultType,
      );
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
      body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType,
    );
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);
