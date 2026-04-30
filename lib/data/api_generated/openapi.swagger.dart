// ignore_for_file: type=lint

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
import 'openapi.enums.swagger.dart' as enums;
export 'openapi.enums.swagger.dart';
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
        baseUrl: baseUrl ?? Uri.parse('http://'));
    return _$Openapi(newClient);
  }

  ///Register User
  Future<chopper.Response<UserResponse>> apiV1AuthRegisterPost(
      {required UserCreate? body}) {
    generatedMapping.putIfAbsent(
        UserResponse, () => UserResponse.fromJsonFactory);

    return _apiV1AuthRegisterPost(body: body);
  }

  ///Register User
  @Post(
    path: '/api/v1/auth/register',
    optionalBody: true,
  )
  Future<chopper.Response<UserResponse>> _apiV1AuthRegisterPost(
      {@Body() required UserCreate? body});

  ///Login For Access Token
  Future<chopper.Response<Token>> apiV1AuthLoginPost(
      {required Map<String, String> body}) {
    generatedMapping.putIfAbsent(Token, () => Token.fromJsonFactory);

    return _apiV1AuthLoginPost(body: body);
  }

  ///Login For Access Token
  @Post(
    path: '/api/v1/auth/login',
    headers: {contentTypeKey: formEncodedHeaders},
  )
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<chopper.Response<Token>> _apiV1AuthLoginPost(
      {@Body() required Map<String, String> body});

  ///Read Users Me
  Future<chopper.Response<UserResponse>> apiV1UsersMeGet() {
    generatedMapping.putIfAbsent(
        UserResponse, () => UserResponse.fromJsonFactory);

    return _apiV1UsersMeGet();
  }

  ///Read Users Me
  @Get(path: '/api/v1/users/me')
  Future<chopper.Response<UserResponse>> _apiV1UsersMeGet();

  ///Get Insumos
  Future<chopper.Response<List<InsumoResponse>>> apiV1InsumosGet() {
    generatedMapping.putIfAbsent(
        InsumoResponse, () => InsumoResponse.fromJsonFactory);

    return _apiV1InsumosGet();
  }

  ///Get Insumos
  @Get(path: '/api/v1/insumos/')
  Future<chopper.Response<List<InsumoResponse>>> _apiV1InsumosGet();

  ///Create Insumo
  Future<chopper.Response<InsumoResponse>> apiV1InsumosPost(
      {required InsumoCreate? body}) {
    generatedMapping.putIfAbsent(
        InsumoResponse, () => InsumoResponse.fromJsonFactory);

    return _apiV1InsumosPost(body: body);
  }

  ///Create Insumo
  @Post(
    path: '/api/v1/insumos/',
    optionalBody: true,
  )
  Future<chopper.Response<InsumoResponse>> _apiV1InsumosPost(
      {@Body() required InsumoCreate? body});

  ///Get Insumo
  ///@param id
  Future<chopper.Response<InsumoResponse>> apiV1InsumosIdGet(
      {required String? id}) {
    generatedMapping.putIfAbsent(
        InsumoResponse, () => InsumoResponse.fromJsonFactory);

    return _apiV1InsumosIdGet(id: id);
  }

  ///Get Insumo
  ///@param id
  @Get(path: '/api/v1/insumos/{id}')
  Future<chopper.Response<InsumoResponse>> _apiV1InsumosIdGet(
      {@Path('id') required String? id});

  ///Update Insumo
  ///@param id
  Future<chopper.Response<InsumoResponse>> apiV1InsumosIdPut({
    required String? id,
    required InsumoUpdate? body,
  }) {
    generatedMapping.putIfAbsent(
        InsumoResponse, () => InsumoResponse.fromJsonFactory);

    return _apiV1InsumosIdPut(id: id, body: body);
  }

  ///Update Insumo
  ///@param id
  @Put(
    path: '/api/v1/insumos/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<InsumoResponse>> _apiV1InsumosIdPut({
    @Path('id') required String? id,
    @Body() required InsumoUpdate? body,
  });

  ///Delete Insumo
  ///@param id
  Future<chopper.Response> apiV1InsumosIdDelete({required String? id}) {
    return _apiV1InsumosIdDelete(id: id);
  }

  ///Delete Insumo
  ///@param id
  @Delete(path: '/api/v1/insumos/{id}')
  Future<chopper.Response> _apiV1InsumosIdDelete(
      {@Path('id') required String? id});

  ///Registrar Movimiento
  ///@param id
  Future<chopper.Response<InsumoResponse>> apiV1InsumosIdMovimientosPost({
    required String? id,
    required MovimientoCreate? body,
  }) {
    generatedMapping.putIfAbsent(
        InsumoResponse, () => InsumoResponse.fromJsonFactory);

    return _apiV1InsumosIdMovimientosPost(id: id, body: body);
  }

  ///Registrar Movimiento
  ///@param id
  @Post(
    path: '/api/v1/insumos/{id}/movimientos',
    optionalBody: true,
  )
  Future<chopper.Response<InsumoResponse>> _apiV1InsumosIdMovimientosPost({
    @Path('id') required String? id,
    @Body() required MovimientoCreate? body,
  });

  ///Get Historial Movimientos
  ///@param id
  ///@param limit
  Future<chopper.Response<List<MovimientoResponse>>>
      apiV1InsumosIdMovimientosGet({
    required String? id,
    int? limit,
  }) {
    generatedMapping.putIfAbsent(
        MovimientoResponse, () => MovimientoResponse.fromJsonFactory);

    return _apiV1InsumosIdMovimientosGet(id: id, limit: limit);
  }

  ///Get Historial Movimientos
  ///@param id
  ///@param limit
  @Get(path: '/api/v1/insumos/{id}/movimientos')
  Future<chopper.Response<List<MovimientoResponse>>>
      _apiV1InsumosIdMovimientosGet({
    @Path('id') required String? id,
    @Query('limit') int? limit,
  });

  ///Get Recetas
  Future<chopper.Response<List<RecetaResponse>>> apiV1RecetasGet() {
    generatedMapping.putIfAbsent(
        RecetaResponse, () => RecetaResponse.fromJsonFactory);

    return _apiV1RecetasGet();
  }

  ///Get Recetas
  @Get(path: '/api/v1/recetas/')
  Future<chopper.Response<List<RecetaResponse>>> _apiV1RecetasGet();

  ///Create Receta
  Future<chopper.Response<RecetaResponse>> apiV1RecetasPost(
      {required RecetaCreate? body}) {
    generatedMapping.putIfAbsent(
        RecetaResponse, () => RecetaResponse.fromJsonFactory);

    return _apiV1RecetasPost(body: body);
  }

  ///Create Receta
  @Post(
    path: '/api/v1/recetas/',
    optionalBody: true,
  )
  Future<chopper.Response<RecetaResponse>> _apiV1RecetasPost(
      {@Body() required RecetaCreate? body});

  ///Get Receta
  ///@param id
  Future<chopper.Response<RecetaResponse>> apiV1RecetasIdGet(
      {required String? id}) {
    generatedMapping.putIfAbsent(
        RecetaResponse, () => RecetaResponse.fromJsonFactory);

    return _apiV1RecetasIdGet(id: id);
  }

  ///Get Receta
  ///@param id
  @Get(path: '/api/v1/recetas/{id}')
  Future<chopper.Response<RecetaResponse>> _apiV1RecetasIdGet(
      {@Path('id') required String? id});

  ///Update Receta
  ///@param id
  Future<chopper.Response<RecetaResponse>> apiV1RecetasIdPut({
    required String? id,
    required RecetaUpdate? body,
  }) {
    generatedMapping.putIfAbsent(
        RecetaResponse, () => RecetaResponse.fromJsonFactory);

    return _apiV1RecetasIdPut(id: id, body: body);
  }

  ///Update Receta
  ///@param id
  @Put(
    path: '/api/v1/recetas/{id}',
    optionalBody: true,
  )
  Future<chopper.Response<RecetaResponse>> _apiV1RecetasIdPut({
    @Path('id') required String? id,
    @Body() required RecetaUpdate? body,
  });

  ///Delete Receta
  ///@param id
  Future<chopper.Response> apiV1RecetasIdDelete({required String? id}) {
    return _apiV1RecetasIdDelete(id: id);
  }

  ///Delete Receta
  ///@param id
  @Delete(path: '/api/v1/recetas/{id}')
  Future<chopper.Response> _apiV1RecetasIdDelete(
      {@Path('id') required String? id});

  ///Calcular Costo Receta
  ///@param id
  Future<chopper.Response<Object>> apiV1RecetasIdCosteoGet(
      {required String? id}) {
    return _apiV1RecetasIdCosteoGet(id: id);
  }

  ///Calcular Costo Receta
  ///@param id
  @Get(path: '/api/v1/recetas/{id}/costeo')
  Future<chopper.Response<Object>> _apiV1RecetasIdCosteoGet(
      {@Path('id') required String? id});

  ///Upsert Gasto Oculto
  ///@param id
  Future<chopper.Response<GastoOcultoResponse>>
      apiV1RecetasIdGastosOcultosPost({
    required String? id,
    required GastoOcultoCreate? body,
  }) {
    generatedMapping.putIfAbsent(
        GastoOcultoResponse, () => GastoOcultoResponse.fromJsonFactory);

    return _apiV1RecetasIdGastosOcultosPost(id: id, body: body);
  }

  ///Upsert Gasto Oculto
  ///@param id
  @Post(
    path: '/api/v1/recetas/{id}/gastos-ocultos',
    optionalBody: true,
  )
  Future<chopper.Response<GastoOcultoResponse>>
      _apiV1RecetasIdGastosOcultosPost({
    @Path('id') required String? id,
    @Body() required GastoOcultoCreate? body,
  });

  ///Toggle Gasto Oculto
  ///@param id
  ///@param tipo
  Future<chopper.Response<GastoOcultoResponse>>
      apiV1RecetasIdGastosOcultosTipoTogglePatch({
    required String? id,
    required enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo? tipo,
    required ToggleGastoRequest? body,
  }) {
    generatedMapping.putIfAbsent(
        GastoOcultoResponse, () => GastoOcultoResponse.fromJsonFactory);

    return _apiV1RecetasIdGastosOcultosTipoTogglePatch(
        id: id, tipo: tipo?.value?.toString(), body: body);
  }

  ///Toggle Gasto Oculto
  ///@param id
  ///@param tipo
  @Patch(
    path: '/api/v1/recetas/{id}/gastos-ocultos/{tipo}/toggle',
    optionalBody: true,
  )
  Future<chopper.Response<GastoOcultoResponse>>
      _apiV1RecetasIdGastosOcultosTipoTogglePatch({
    @Path('id') required String? id,
    @Path('tipo') required String? tipo,
    @Body() required ToggleGastoRequest? body,
  });

  ///Crear Pedido
  Future<chopper.Response<PedidoResponse>> apiV1PedidosPost(
      {required PedidoCreate? body}) {
    generatedMapping.putIfAbsent(
        PedidoResponse, () => PedidoResponse.fromJsonFactory);

    return _apiV1PedidosPost(body: body);
  }

  ///Crear Pedido
  @Post(
    path: '/api/v1/pedidos/',
    optionalBody: true,
  )
  Future<chopper.Response<PedidoResponse>> _apiV1PedidosPost(
      {@Body() required PedidoCreate? body});

  ///Listar Pedidos
  ///@param estado Filtrar por estado: pendiente, en_preparacion, listo, entregado, cancelado
  ///@param limit
  ///@param offset
  Future<chopper.Response<List<PedidoResponse>>> apiV1PedidosGet({
    String? estado,
    int? limit,
    int? offset,
  }) {
    generatedMapping.putIfAbsent(
        PedidoResponse, () => PedidoResponse.fromJsonFactory);

    return _apiV1PedidosGet(estado: estado, limit: limit, offset: offset);
  }

  ///Listar Pedidos
  ///@param estado Filtrar por estado: pendiente, en_preparacion, listo, entregado, cancelado
  ///@param limit
  ///@param offset
  @Get(path: '/api/v1/pedidos/')
  Future<chopper.Response<List<PedidoResponse>>> _apiV1PedidosGet({
    @Query('estado') String? estado,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  });

  ///Obtener Pedido
  ///@param pedido_id
  Future<chopper.Response<PedidoResponse>> apiV1PedidosPedidoIdGet(
      {required String? pedidoId}) {
    generatedMapping.putIfAbsent(
        PedidoResponse, () => PedidoResponse.fromJsonFactory);

    return _apiV1PedidosPedidoIdGet(pedidoId: pedidoId);
  }

  ///Obtener Pedido
  ///@param pedido_id
  @Get(path: '/api/v1/pedidos/{pedido_id}')
  Future<chopper.Response<PedidoResponse>> _apiV1PedidosPedidoIdGet(
      {@Path('pedido_id') required String? pedidoId});

  ///Actualizar Pedido
  ///@param pedido_id
  Future<chopper.Response<PedidoResponse>> apiV1PedidosPedidoIdPut({
    required String? pedidoId,
    required dynamic body,
  }) {
    generatedMapping.putIfAbsent(
        PedidoResponse, () => PedidoResponse.fromJsonFactory);

    return _apiV1PedidosPedidoIdPut(pedidoId: pedidoId, body: body);
  }

  ///Actualizar Pedido
  ///@param pedido_id
  @Put(
    path: '/api/v1/pedidos/{pedido_id}',
    optionalBody: true,
  )
  Future<chopper.Response<PedidoResponse>> _apiV1PedidosPedidoIdPut({
    @Path('pedido_id') required String? pedidoId,
    @Body() required dynamic body,
  });

  ///Cancelar Pedido
  ///@param pedido_id
  Future<chopper.Response<PedidoResponse>> apiV1PedidosPedidoIdDelete(
      {required String? pedidoId}) {
    generatedMapping.putIfAbsent(
        PedidoResponse, () => PedidoResponse.fromJsonFactory);

    return _apiV1PedidosPedidoIdDelete(pedidoId: pedidoId);
  }

  ///Cancelar Pedido
  ///@param pedido_id
  @Delete(path: '/api/v1/pedidos/{pedido_id}')
  Future<chopper.Response<PedidoResponse>> _apiV1PedidosPedidoIdDelete(
      {@Path('pedido_id') required String? pedidoId});

  ///Cambiar Estado Pedido
  ///@param pedido_id
  ///@param nuevo_estado
  Future<chopper.Response<PedidoResponse>> apiV1PedidosPedidoIdEstadoPatch({
    required String? pedidoId,
    required String? nuevoEstado,
  }) {
    generatedMapping.putIfAbsent(
        PedidoResponse, () => PedidoResponse.fromJsonFactory);

    return _apiV1PedidosPedidoIdEstadoPatch(
        pedidoId: pedidoId, nuevoEstado: nuevoEstado);
  }

  ///Cambiar Estado Pedido
  ///@param pedido_id
  ///@param nuevo_estado
  @Patch(
    path: '/api/v1/pedidos/{pedido_id}/estado',
    optionalBody: true,
  )
  Future<chopper.Response<PedidoResponse>> _apiV1PedidosPedidoIdEstadoPatch({
    @Path('pedido_id') required String? pedidoId,
    @Query('nuevo_estado') required String? nuevoEstado,
  });

  ///Health Check
  Future<chopper.Response> get() {
    return _get();
  }

  ///Health Check
  @Get(path: '/')
  Future<chopper.Response> _get();
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
      chopper.Response response) async {
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
          body: DateTime.parse((response.body as String).replaceAll('"', ''))
              as ResultType);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);
