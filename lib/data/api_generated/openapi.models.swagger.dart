// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'openapi.enums.swagger.dart' as enums;

part 'openapi.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class BodyLoginForAccessTokenApiV1AuthLoginPost {
  const BodyLoginForAccessTokenApiV1AuthLoginPost({
    this.grantType,
    required this.username,
    required this.password,
    this.scope,
    this.clientId,
    this.clientSecret,
  });

  factory BodyLoginForAccessTokenApiV1AuthLoginPost.fromJson(
          Map<String, dynamic> json) =>
      _$BodyLoginForAccessTokenApiV1AuthLoginPostFromJson(json);

  static const toJsonFactory =
      _$BodyLoginForAccessTokenApiV1AuthLoginPostToJson;
  Map<String, dynamic> toJson() =>
      _$BodyLoginForAccessTokenApiV1AuthLoginPostToJson(this);

  @JsonKey(name: 'grant_type')
  final dynamic grantType;
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'scope')
  final String? scope;
  @JsonKey(name: 'client_id')
  final dynamic clientId;
  @JsonKey(name: 'client_secret')
  final dynamic clientSecret;
  static const fromJsonFactory =
      _$BodyLoginForAccessTokenApiV1AuthLoginPostFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BodyLoginForAccessTokenApiV1AuthLoginPost &&
            (identical(other.grantType, grantType) ||
                const DeepCollectionEquality()
                    .equals(other.grantType, grantType)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)) &&
            (identical(other.scope, scope) ||
                const DeepCollectionEquality().equals(other.scope, scope)) &&
            (identical(other.clientId, clientId) ||
                const DeepCollectionEquality()
                    .equals(other.clientId, clientId)) &&
            (identical(other.clientSecret, clientSecret) ||
                const DeepCollectionEquality()
                    .equals(other.clientSecret, clientSecret)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(grantType) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(scope) ^
      const DeepCollectionEquality().hash(clientId) ^
      const DeepCollectionEquality().hash(clientSecret) ^
      runtimeType.hashCode;
}

extension $BodyLoginForAccessTokenApiV1AuthLoginPostExtension
    on BodyLoginForAccessTokenApiV1AuthLoginPost {
  BodyLoginForAccessTokenApiV1AuthLoginPost copyWith(
      {dynamic grantType,
      String? username,
      String? password,
      String? scope,
      dynamic clientId,
      dynamic clientSecret}) {
    return BodyLoginForAccessTokenApiV1AuthLoginPost(
        grantType: grantType ?? this.grantType,
        username: username ?? this.username,
        password: password ?? this.password,
        scope: scope ?? this.scope,
        clientId: clientId ?? this.clientId,
        clientSecret: clientSecret ?? this.clientSecret);
  }

  BodyLoginForAccessTokenApiV1AuthLoginPost copyWithWrapped(
      {Wrapped<dynamic>? grantType,
      Wrapped<String>? username,
      Wrapped<String>? password,
      Wrapped<String?>? scope,
      Wrapped<dynamic>? clientId,
      Wrapped<dynamic>? clientSecret}) {
    return BodyLoginForAccessTokenApiV1AuthLoginPost(
        grantType: (grantType != null ? grantType.value : this.grantType),
        username: (username != null ? username.value : this.username),
        password: (password != null ? password.value : this.password),
        scope: (scope != null ? scope.value : this.scope),
        clientId: (clientId != null ? clientId.value : this.clientId),
        clientSecret:
            (clientSecret != null ? clientSecret.value : this.clientSecret));
  }
}

@JsonSerializable(explicitToJson: true)
class GastoOcultoCreate {
  const GastoOcultoCreate({
    required this.tipo,
    required this.valor,
    required this.esPorcentaje,
    this.activo,
  });

  factory GastoOcultoCreate.fromJson(Map<String, dynamic> json) =>
      _$GastoOcultoCreateFromJson(json);

  static const toJsonFactory = _$GastoOcultoCreateToJson;
  Map<String, dynamic> toJson() => _$GastoOcultoCreateToJson(this);

  @JsonKey(
    name: 'tipo',
    toJson: gastoOcultoCreateTipoToJson,
    fromJson: gastoOcultoCreateTipoFromJson,
  )
  final enums.GastoOcultoCreateTipo tipo;
  @JsonKey(name: 'valor')
  final dynamic valor;
  @JsonKey(name: 'es_porcentaje')
  final bool esPorcentaje;
  @JsonKey(name: 'activo', defaultValue: false)
  final bool? activo;
  static const fromJsonFactory = _$GastoOcultoCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GastoOcultoCreate &&
            (identical(other.tipo, tipo) ||
                const DeepCollectionEquality().equals(other.tipo, tipo)) &&
            (identical(other.valor, valor) ||
                const DeepCollectionEquality().equals(other.valor, valor)) &&
            (identical(other.esPorcentaje, esPorcentaje) ||
                const DeepCollectionEquality()
                    .equals(other.esPorcentaje, esPorcentaje)) &&
            (identical(other.activo, activo) ||
                const DeepCollectionEquality().equals(other.activo, activo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(tipo) ^
      const DeepCollectionEquality().hash(valor) ^
      const DeepCollectionEquality().hash(esPorcentaje) ^
      const DeepCollectionEquality().hash(activo) ^
      runtimeType.hashCode;
}

extension $GastoOcultoCreateExtension on GastoOcultoCreate {
  GastoOcultoCreate copyWith(
      {enums.GastoOcultoCreateTipo? tipo,
      dynamic valor,
      bool? esPorcentaje,
      bool? activo}) {
    return GastoOcultoCreate(
        tipo: tipo ?? this.tipo,
        valor: valor ?? this.valor,
        esPorcentaje: esPorcentaje ?? this.esPorcentaje,
        activo: activo ?? this.activo);
  }

  GastoOcultoCreate copyWithWrapped(
      {Wrapped<enums.GastoOcultoCreateTipo>? tipo,
      Wrapped<dynamic>? valor,
      Wrapped<bool>? esPorcentaje,
      Wrapped<bool?>? activo}) {
    return GastoOcultoCreate(
        tipo: (tipo != null ? tipo.value : this.tipo),
        valor: (valor != null ? valor.value : this.valor),
        esPorcentaje:
            (esPorcentaje != null ? esPorcentaje.value : this.esPorcentaje),
        activo: (activo != null ? activo.value : this.activo));
  }
}

@JsonSerializable(explicitToJson: true)
class GastoOcultoResponse {
  const GastoOcultoResponse({
    required this.tipo,
    required this.valor,
    required this.esPorcentaje,
    this.activo,
    required this.id,
  });

  factory GastoOcultoResponse.fromJson(Map<String, dynamic> json) =>
      _$GastoOcultoResponseFromJson(json);

  static const toJsonFactory = _$GastoOcultoResponseToJson;
  Map<String, dynamic> toJson() => _$GastoOcultoResponseToJson(this);

  @JsonKey(
    name: 'tipo',
    toJson: gastoOcultoResponseTipoToJson,
    fromJson: gastoOcultoResponseTipoFromJson,
  )
  final enums.GastoOcultoResponseTipo tipo;
  @JsonKey(name: 'valor')
  final String valor;
  @JsonKey(name: 'es_porcentaje')
  final bool esPorcentaje;
  @JsonKey(name: 'activo', defaultValue: false)
  final bool? activo;
  @JsonKey(name: 'id')
  final String id;
  static const fromJsonFactory = _$GastoOcultoResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GastoOcultoResponse &&
            (identical(other.tipo, tipo) ||
                const DeepCollectionEquality().equals(other.tipo, tipo)) &&
            (identical(other.valor, valor) ||
                const DeepCollectionEquality().equals(other.valor, valor)) &&
            (identical(other.esPorcentaje, esPorcentaje) ||
                const DeepCollectionEquality()
                    .equals(other.esPorcentaje, esPorcentaje)) &&
            (identical(other.activo, activo) ||
                const DeepCollectionEquality().equals(other.activo, activo)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(tipo) ^
      const DeepCollectionEquality().hash(valor) ^
      const DeepCollectionEquality().hash(esPorcentaje) ^
      const DeepCollectionEquality().hash(activo) ^
      const DeepCollectionEquality().hash(id) ^
      runtimeType.hashCode;
}

extension $GastoOcultoResponseExtension on GastoOcultoResponse {
  GastoOcultoResponse copyWith(
      {enums.GastoOcultoResponseTipo? tipo,
      String? valor,
      bool? esPorcentaje,
      bool? activo,
      String? id}) {
    return GastoOcultoResponse(
        tipo: tipo ?? this.tipo,
        valor: valor ?? this.valor,
        esPorcentaje: esPorcentaje ?? this.esPorcentaje,
        activo: activo ?? this.activo,
        id: id ?? this.id);
  }

  GastoOcultoResponse copyWithWrapped(
      {Wrapped<enums.GastoOcultoResponseTipo>? tipo,
      Wrapped<String>? valor,
      Wrapped<bool>? esPorcentaje,
      Wrapped<bool?>? activo,
      Wrapped<String>? id}) {
    return GastoOcultoResponse(
        tipo: (tipo != null ? tipo.value : this.tipo),
        valor: (valor != null ? valor.value : this.valor),
        esPorcentaje:
            (esPorcentaje != null ? esPorcentaje.value : this.esPorcentaje),
        activo: (activo != null ? activo.value : this.activo),
        id: (id != null ? id.value : this.id));
  }
}

@JsonSerializable(explicitToJson: true)
class HTTPValidationError {
  const HTTPValidationError({
    this.detail,
  });

  factory HTTPValidationError.fromJson(Map<String, dynamic> json) =>
      _$HTTPValidationErrorFromJson(json);

  static const toJsonFactory = _$HTTPValidationErrorToJson;
  Map<String, dynamic> toJson() => _$HTTPValidationErrorToJson(this);

  @JsonKey(name: 'detail', defaultValue: <ValidationError>[])
  final List<ValidationError>? detail;
  static const fromJsonFactory = _$HTTPValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is HTTPValidationError &&
            (identical(other.detail, detail) ||
                const DeepCollectionEquality().equals(other.detail, detail)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(detail) ^ runtimeType.hashCode;
}

extension $HTTPValidationErrorExtension on HTTPValidationError {
  HTTPValidationError copyWith({List<ValidationError>? detail}) {
    return HTTPValidationError(detail: detail ?? this.detail);
  }

  HTTPValidationError copyWithWrapped(
      {Wrapped<List<ValidationError>?>? detail}) {
    return HTTPValidationError(
        detail: (detail != null ? detail.value : this.detail));
  }
}

@JsonSerializable(explicitToJson: true)
class IngredienteCreate {
  const IngredienteCreate({
    required this.insumoId,
    required this.cantidadUsada,
    required this.unidad,
  });

  factory IngredienteCreate.fromJson(Map<String, dynamic> json) =>
      _$IngredienteCreateFromJson(json);

  static const toJsonFactory = _$IngredienteCreateToJson;
  Map<String, dynamic> toJson() => _$IngredienteCreateToJson(this);

  @JsonKey(name: 'insumo_id')
  final String insumoId;
  @JsonKey(name: 'cantidad_usada')
  final dynamic cantidadUsada;
  @JsonKey(name: 'unidad')
  final String unidad;
  static const fromJsonFactory = _$IngredienteCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IngredienteCreate &&
            (identical(other.insumoId, insumoId) ||
                const DeepCollectionEquality()
                    .equals(other.insumoId, insumoId)) &&
            (identical(other.cantidadUsada, cantidadUsada) ||
                const DeepCollectionEquality()
                    .equals(other.cantidadUsada, cantidadUsada)) &&
            (identical(other.unidad, unidad) ||
                const DeepCollectionEquality().equals(other.unidad, unidad)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(insumoId) ^
      const DeepCollectionEquality().hash(cantidadUsada) ^
      const DeepCollectionEquality().hash(unidad) ^
      runtimeType.hashCode;
}

extension $IngredienteCreateExtension on IngredienteCreate {
  IngredienteCreate copyWith(
      {String? insumoId, dynamic cantidadUsada, String? unidad}) {
    return IngredienteCreate(
        insumoId: insumoId ?? this.insumoId,
        cantidadUsada: cantidadUsada ?? this.cantidadUsada,
        unidad: unidad ?? this.unidad);
  }

  IngredienteCreate copyWithWrapped(
      {Wrapped<String>? insumoId,
      Wrapped<dynamic>? cantidadUsada,
      Wrapped<String>? unidad}) {
    return IngredienteCreate(
        insumoId: (insumoId != null ? insumoId.value : this.insumoId),
        cantidadUsada:
            (cantidadUsada != null ? cantidadUsada.value : this.cantidadUsada),
        unidad: (unidad != null ? unidad.value : this.unidad));
  }
}

@JsonSerializable(explicitToJson: true)
class IngredienteResponse {
  const IngredienteResponse({
    required this.id,
    required this.insumo,
    required this.cantidadUsada,
    required this.unidad,
  });

  factory IngredienteResponse.fromJson(Map<String, dynamic> json) =>
      _$IngredienteResponseFromJson(json);

  static const toJsonFactory = _$IngredienteResponseToJson;
  Map<String, dynamic> toJson() => _$IngredienteResponseToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'insumo')
  final InsumoResponse insumo;
  @JsonKey(name: 'cantidad_usada')
  final String cantidadUsada;
  @JsonKey(name: 'unidad')
  final String unidad;
  static const fromJsonFactory = _$IngredienteResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IngredienteResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.insumo, insumo) ||
                const DeepCollectionEquality().equals(other.insumo, insumo)) &&
            (identical(other.cantidadUsada, cantidadUsada) ||
                const DeepCollectionEquality()
                    .equals(other.cantidadUsada, cantidadUsada)) &&
            (identical(other.unidad, unidad) ||
                const DeepCollectionEquality().equals(other.unidad, unidad)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(insumo) ^
      const DeepCollectionEquality().hash(cantidadUsada) ^
      const DeepCollectionEquality().hash(unidad) ^
      runtimeType.hashCode;
}

extension $IngredienteResponseExtension on IngredienteResponse {
  IngredienteResponse copyWith(
      {String? id,
      InsumoResponse? insumo,
      String? cantidadUsada,
      String? unidad}) {
    return IngredienteResponse(
        id: id ?? this.id,
        insumo: insumo ?? this.insumo,
        cantidadUsada: cantidadUsada ?? this.cantidadUsada,
        unidad: unidad ?? this.unidad);
  }

  IngredienteResponse copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<InsumoResponse>? insumo,
      Wrapped<String>? cantidadUsada,
      Wrapped<String>? unidad}) {
    return IngredienteResponse(
        id: (id != null ? id.value : this.id),
        insumo: (insumo != null ? insumo.value : this.insumo),
        cantidadUsada:
            (cantidadUsada != null ? cantidadUsada.value : this.cantidadUsada),
        unidad: (unidad != null ? unidad.value : this.unidad));
  }
}

@JsonSerializable(explicitToJson: true)
class InsumoCreate {
  const InsumoCreate({
    required this.nombre,
    required this.unidad,
    required this.precioCompra,
    required this.cantidadComprada,
    this.alertaMinimo,
  });

  factory InsumoCreate.fromJson(Map<String, dynamic> json) =>
      _$InsumoCreateFromJson(json);

  static const toJsonFactory = _$InsumoCreateToJson;
  Map<String, dynamic> toJson() => _$InsumoCreateToJson(this);

  @JsonKey(name: 'nombre')
  final String nombre;
  @JsonKey(
    name: 'unidad',
    toJson: insumoCreateUnidadToJson,
    fromJson: insumoCreateUnidadFromJson,
  )
  final enums.InsumoCreateUnidad unidad;
  @JsonKey(name: 'precio_compra')
  final dynamic precioCompra;
  @JsonKey(name: 'cantidad_comprada')
  final dynamic cantidadComprada;
  @JsonKey(name: 'alerta_minimo')
  final dynamic alertaMinimo;
  static const fromJsonFactory = _$InsumoCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InsumoCreate &&
            (identical(other.nombre, nombre) ||
                const DeepCollectionEquality().equals(other.nombre, nombre)) &&
            (identical(other.unidad, unidad) ||
                const DeepCollectionEquality().equals(other.unidad, unidad)) &&
            (identical(other.precioCompra, precioCompra) ||
                const DeepCollectionEquality()
                    .equals(other.precioCompra, precioCompra)) &&
            (identical(other.cantidadComprada, cantidadComprada) ||
                const DeepCollectionEquality()
                    .equals(other.cantidadComprada, cantidadComprada)) &&
            (identical(other.alertaMinimo, alertaMinimo) ||
                const DeepCollectionEquality()
                    .equals(other.alertaMinimo, alertaMinimo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(nombre) ^
      const DeepCollectionEquality().hash(unidad) ^
      const DeepCollectionEquality().hash(precioCompra) ^
      const DeepCollectionEquality().hash(cantidadComprada) ^
      const DeepCollectionEquality().hash(alertaMinimo) ^
      runtimeType.hashCode;
}

extension $InsumoCreateExtension on InsumoCreate {
  InsumoCreate copyWith(
      {String? nombre,
      enums.InsumoCreateUnidad? unidad,
      dynamic precioCompra,
      dynamic cantidadComprada,
      dynamic alertaMinimo}) {
    return InsumoCreate(
        nombre: nombre ?? this.nombre,
        unidad: unidad ?? this.unidad,
        precioCompra: precioCompra ?? this.precioCompra,
        cantidadComprada: cantidadComprada ?? this.cantidadComprada,
        alertaMinimo: alertaMinimo ?? this.alertaMinimo);
  }

  InsumoCreate copyWithWrapped(
      {Wrapped<String>? nombre,
      Wrapped<enums.InsumoCreateUnidad>? unidad,
      Wrapped<dynamic>? precioCompra,
      Wrapped<dynamic>? cantidadComprada,
      Wrapped<dynamic>? alertaMinimo}) {
    return InsumoCreate(
        nombre: (nombre != null ? nombre.value : this.nombre),
        unidad: (unidad != null ? unidad.value : this.unidad),
        precioCompra:
            (precioCompra != null ? precioCompra.value : this.precioCompra),
        cantidadComprada: (cantidadComprada != null
            ? cantidadComprada.value
            : this.cantidadComprada),
        alertaMinimo:
            (alertaMinimo != null ? alertaMinimo.value : this.alertaMinimo));
  }
}

@JsonSerializable(explicitToJson: true)
class InsumoResponse {
  const InsumoResponse({
    required this.nombre,
    required this.unidad,
    required this.precioCompra,
    required this.cantidadComprada,
    this.alertaMinimo,
    required this.id,
    required this.usuarioId,
    required this.cantidadActual,
    required this.fechaUltimoPrecio,
    required this.activo,
  });

  factory InsumoResponse.fromJson(Map<String, dynamic> json) =>
      _$InsumoResponseFromJson(json);

  static const toJsonFactory = _$InsumoResponseToJson;
  Map<String, dynamic> toJson() => _$InsumoResponseToJson(this);

  @JsonKey(name: 'nombre')
  final String nombre;
  @JsonKey(
    name: 'unidad',
    toJson: insumoResponseUnidadToJson,
    fromJson: insumoResponseUnidadFromJson,
  )
  final enums.InsumoResponseUnidad unidad;
  @JsonKey(name: 'precio_compra')
  final String precioCompra;
  @JsonKey(name: 'cantidad_comprada')
  final String cantidadComprada;
  @JsonKey(name: 'alerta_minimo')
  final String? alertaMinimo;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'usuario_id')
  final String usuarioId;
  @JsonKey(name: 'cantidad_actual')
  final String cantidadActual;
  @JsonKey(name: 'fecha_ultimo_precio', toJson: _dateToJson)
  final DateTime fechaUltimoPrecio;
  @JsonKey(name: 'activo')
  final bool activo;
  static const fromJsonFactory = _$InsumoResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InsumoResponse &&
            (identical(other.nombre, nombre) ||
                const DeepCollectionEquality().equals(other.nombre, nombre)) &&
            (identical(other.unidad, unidad) ||
                const DeepCollectionEquality().equals(other.unidad, unidad)) &&
            (identical(other.precioCompra, precioCompra) ||
                const DeepCollectionEquality()
                    .equals(other.precioCompra, precioCompra)) &&
            (identical(other.cantidadComprada, cantidadComprada) ||
                const DeepCollectionEquality()
                    .equals(other.cantidadComprada, cantidadComprada)) &&
            (identical(other.alertaMinimo, alertaMinimo) ||
                const DeepCollectionEquality()
                    .equals(other.alertaMinimo, alertaMinimo)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.usuarioId, usuarioId) ||
                const DeepCollectionEquality()
                    .equals(other.usuarioId, usuarioId)) &&
            (identical(other.cantidadActual, cantidadActual) ||
                const DeepCollectionEquality()
                    .equals(other.cantidadActual, cantidadActual)) &&
            (identical(other.fechaUltimoPrecio, fechaUltimoPrecio) ||
                const DeepCollectionEquality()
                    .equals(other.fechaUltimoPrecio, fechaUltimoPrecio)) &&
            (identical(other.activo, activo) ||
                const DeepCollectionEquality().equals(other.activo, activo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(nombre) ^
      const DeepCollectionEquality().hash(unidad) ^
      const DeepCollectionEquality().hash(precioCompra) ^
      const DeepCollectionEquality().hash(cantidadComprada) ^
      const DeepCollectionEquality().hash(alertaMinimo) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(usuarioId) ^
      const DeepCollectionEquality().hash(cantidadActual) ^
      const DeepCollectionEquality().hash(fechaUltimoPrecio) ^
      const DeepCollectionEquality().hash(activo) ^
      runtimeType.hashCode;
}

extension $InsumoResponseExtension on InsumoResponse {
  InsumoResponse copyWith(
      {String? nombre,
      enums.InsumoResponseUnidad? unidad,
      String? precioCompra,
      String? cantidadComprada,
      String? alertaMinimo,
      String? id,
      String? usuarioId,
      String? cantidadActual,
      DateTime? fechaUltimoPrecio,
      bool? activo}) {
    return InsumoResponse(
        nombre: nombre ?? this.nombre,
        unidad: unidad ?? this.unidad,
        precioCompra: precioCompra ?? this.precioCompra,
        cantidadComprada: cantidadComprada ?? this.cantidadComprada,
        alertaMinimo: alertaMinimo ?? this.alertaMinimo,
        id: id ?? this.id,
        usuarioId: usuarioId ?? this.usuarioId,
        cantidadActual: cantidadActual ?? this.cantidadActual,
        fechaUltimoPrecio: fechaUltimoPrecio ?? this.fechaUltimoPrecio,
        activo: activo ?? this.activo);
  }

  InsumoResponse copyWithWrapped(
      {Wrapped<String>? nombre,
      Wrapped<enums.InsumoResponseUnidad>? unidad,
      Wrapped<String>? precioCompra,
      Wrapped<String>? cantidadComprada,
      Wrapped<String?>? alertaMinimo,
      Wrapped<String>? id,
      Wrapped<String>? usuarioId,
      Wrapped<String>? cantidadActual,
      Wrapped<DateTime>? fechaUltimoPrecio,
      Wrapped<bool>? activo}) {
    return InsumoResponse(
        nombre: (nombre != null ? nombre.value : this.nombre),
        unidad: (unidad != null ? unidad.value : this.unidad),
        precioCompra:
            (precioCompra != null ? precioCompra.value : this.precioCompra),
        cantidadComprada: (cantidadComprada != null
            ? cantidadComprada.value
            : this.cantidadComprada),
        alertaMinimo:
            (alertaMinimo != null ? alertaMinimo.value : this.alertaMinimo),
        id: (id != null ? id.value : this.id),
        usuarioId: (usuarioId != null ? usuarioId.value : this.usuarioId),
        cantidadActual: (cantidadActual != null
            ? cantidadActual.value
            : this.cantidadActual),
        fechaUltimoPrecio: (fechaUltimoPrecio != null
            ? fechaUltimoPrecio.value
            : this.fechaUltimoPrecio),
        activo: (activo != null ? activo.value : this.activo));
  }
}

@JsonSerializable(explicitToJson: true)
class InsumoUpdate {
  const InsumoUpdate({
    this.nombre,
    this.unidad,
    this.precioCompra,
    this.cantidadComprada,
    this.alertaMinimo,
  });

  factory InsumoUpdate.fromJson(Map<String, dynamic> json) =>
      _$InsumoUpdateFromJson(json);

  static const toJsonFactory = _$InsumoUpdateToJson;
  Map<String, dynamic> toJson() => _$InsumoUpdateToJson(this);

  @JsonKey(name: 'nombre')
  final dynamic nombre;
  @JsonKey(name: 'unidad')
  final dynamic unidad;
  @JsonKey(name: 'precio_compra')
  final dynamic precioCompra;
  @JsonKey(name: 'cantidad_comprada')
  final dynamic cantidadComprada;
  @JsonKey(name: 'alerta_minimo')
  final dynamic alertaMinimo;
  static const fromJsonFactory = _$InsumoUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is InsumoUpdate &&
            (identical(other.nombre, nombre) ||
                const DeepCollectionEquality().equals(other.nombre, nombre)) &&
            (identical(other.unidad, unidad) ||
                const DeepCollectionEquality().equals(other.unidad, unidad)) &&
            (identical(other.precioCompra, precioCompra) ||
                const DeepCollectionEquality()
                    .equals(other.precioCompra, precioCompra)) &&
            (identical(other.cantidadComprada, cantidadComprada) ||
                const DeepCollectionEquality()
                    .equals(other.cantidadComprada, cantidadComprada)) &&
            (identical(other.alertaMinimo, alertaMinimo) ||
                const DeepCollectionEquality()
                    .equals(other.alertaMinimo, alertaMinimo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(nombre) ^
      const DeepCollectionEquality().hash(unidad) ^
      const DeepCollectionEquality().hash(precioCompra) ^
      const DeepCollectionEquality().hash(cantidadComprada) ^
      const DeepCollectionEquality().hash(alertaMinimo) ^
      runtimeType.hashCode;
}

extension $InsumoUpdateExtension on InsumoUpdate {
  InsumoUpdate copyWith(
      {dynamic nombre,
      dynamic unidad,
      dynamic precioCompra,
      dynamic cantidadComprada,
      dynamic alertaMinimo}) {
    return InsumoUpdate(
        nombre: nombre ?? this.nombre,
        unidad: unidad ?? this.unidad,
        precioCompra: precioCompra ?? this.precioCompra,
        cantidadComprada: cantidadComprada ?? this.cantidadComprada,
        alertaMinimo: alertaMinimo ?? this.alertaMinimo);
  }

  InsumoUpdate copyWithWrapped(
      {Wrapped<dynamic>? nombre,
      Wrapped<dynamic>? unidad,
      Wrapped<dynamic>? precioCompra,
      Wrapped<dynamic>? cantidadComprada,
      Wrapped<dynamic>? alertaMinimo}) {
    return InsumoUpdate(
        nombre: (nombre != null ? nombre.value : this.nombre),
        unidad: (unidad != null ? unidad.value : this.unidad),
        precioCompra:
            (precioCompra != null ? precioCompra.value : this.precioCompra),
        cantidadComprada: (cantidadComprada != null
            ? cantidadComprada.value
            : this.cantidadComprada),
        alertaMinimo:
            (alertaMinimo != null ? alertaMinimo.value : this.alertaMinimo));
  }
}

@JsonSerializable(explicitToJson: true)
class LineaPedidoCreate {
  const LineaPedidoCreate({
    required this.nombreProducto,
    required this.cantidadPorciones,
    required this.precioAcordadoMxn,
    this.recetaId,
  });

  factory LineaPedidoCreate.fromJson(Map<String, dynamic> json) =>
      _$LineaPedidoCreateFromJson(json);

  static const toJsonFactory = _$LineaPedidoCreateToJson;
  Map<String, dynamic> toJson() => _$LineaPedidoCreateToJson(this);

  @JsonKey(name: 'nombre_producto')
  final String nombreProducto;
  @JsonKey(name: 'cantidad_porciones')
  final int cantidadPorciones;
  @JsonKey(name: 'precio_acordado_mxn')
  final dynamic precioAcordadoMxn;
  @JsonKey(name: 'receta_id')
  final dynamic recetaId;
  static const fromJsonFactory = _$LineaPedidoCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LineaPedidoCreate &&
            (identical(other.nombreProducto, nombreProducto) ||
                const DeepCollectionEquality()
                    .equals(other.nombreProducto, nombreProducto)) &&
            (identical(other.cantidadPorciones, cantidadPorciones) ||
                const DeepCollectionEquality()
                    .equals(other.cantidadPorciones, cantidadPorciones)) &&
            (identical(other.precioAcordadoMxn, precioAcordadoMxn) ||
                const DeepCollectionEquality()
                    .equals(other.precioAcordadoMxn, precioAcordadoMxn)) &&
            (identical(other.recetaId, recetaId) ||
                const DeepCollectionEquality()
                    .equals(other.recetaId, recetaId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(nombreProducto) ^
      const DeepCollectionEquality().hash(cantidadPorciones) ^
      const DeepCollectionEquality().hash(precioAcordadoMxn) ^
      const DeepCollectionEquality().hash(recetaId) ^
      runtimeType.hashCode;
}

extension $LineaPedidoCreateExtension on LineaPedidoCreate {
  LineaPedidoCreate copyWith(
      {String? nombreProducto,
      int? cantidadPorciones,
      dynamic precioAcordadoMxn,
      dynamic recetaId}) {
    return LineaPedidoCreate(
        nombreProducto: nombreProducto ?? this.nombreProducto,
        cantidadPorciones: cantidadPorciones ?? this.cantidadPorciones,
        precioAcordadoMxn: precioAcordadoMxn ?? this.precioAcordadoMxn,
        recetaId: recetaId ?? this.recetaId);
  }

  LineaPedidoCreate copyWithWrapped(
      {Wrapped<String>? nombreProducto,
      Wrapped<int>? cantidadPorciones,
      Wrapped<dynamic>? precioAcordadoMxn,
      Wrapped<dynamic>? recetaId}) {
    return LineaPedidoCreate(
        nombreProducto: (nombreProducto != null
            ? nombreProducto.value
            : this.nombreProducto),
        cantidadPorciones: (cantidadPorciones != null
            ? cantidadPorciones.value
            : this.cantidadPorciones),
        precioAcordadoMxn: (precioAcordadoMxn != null
            ? precioAcordadoMxn.value
            : this.precioAcordadoMxn),
        recetaId: (recetaId != null ? recetaId.value : this.recetaId));
  }
}

@JsonSerializable(explicitToJson: true)
class LineaPedidoResponse {
  const LineaPedidoResponse({
    required this.nombreProducto,
    required this.cantidadPorciones,
    required this.precioAcordadoMxn,
    this.recetaId,
    required this.id,
    required this.pedidoId,
  });

  factory LineaPedidoResponse.fromJson(Map<String, dynamic> json) =>
      _$LineaPedidoResponseFromJson(json);

  static const toJsonFactory = _$LineaPedidoResponseToJson;
  Map<String, dynamic> toJson() => _$LineaPedidoResponseToJson(this);

  @JsonKey(name: 'nombre_producto')
  final String nombreProducto;
  @JsonKey(name: 'cantidad_porciones')
  final int cantidadPorciones;
  @JsonKey(name: 'precio_acordado_mxn')
  final String precioAcordadoMxn;
  @JsonKey(name: 'receta_id')
  final dynamic recetaId;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'pedido_id')
  final String pedidoId;
  static const fromJsonFactory = _$LineaPedidoResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LineaPedidoResponse &&
            (identical(other.nombreProducto, nombreProducto) ||
                const DeepCollectionEquality()
                    .equals(other.nombreProducto, nombreProducto)) &&
            (identical(other.cantidadPorciones, cantidadPorciones) ||
                const DeepCollectionEquality()
                    .equals(other.cantidadPorciones, cantidadPorciones)) &&
            (identical(other.precioAcordadoMxn, precioAcordadoMxn) ||
                const DeepCollectionEquality()
                    .equals(other.precioAcordadoMxn, precioAcordadoMxn)) &&
            (identical(other.recetaId, recetaId) ||
                const DeepCollectionEquality()
                    .equals(other.recetaId, recetaId)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.pedidoId, pedidoId) ||
                const DeepCollectionEquality()
                    .equals(other.pedidoId, pedidoId)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(nombreProducto) ^
      const DeepCollectionEquality().hash(cantidadPorciones) ^
      const DeepCollectionEquality().hash(precioAcordadoMxn) ^
      const DeepCollectionEquality().hash(recetaId) ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(pedidoId) ^
      runtimeType.hashCode;
}

extension $LineaPedidoResponseExtension on LineaPedidoResponse {
  LineaPedidoResponse copyWith(
      {String? nombreProducto,
      int? cantidadPorciones,
      String? precioAcordadoMxn,
      dynamic recetaId,
      String? id,
      String? pedidoId}) {
    return LineaPedidoResponse(
        nombreProducto: nombreProducto ?? this.nombreProducto,
        cantidadPorciones: cantidadPorciones ?? this.cantidadPorciones,
        precioAcordadoMxn: precioAcordadoMxn ?? this.precioAcordadoMxn,
        recetaId: recetaId ?? this.recetaId,
        id: id ?? this.id,
        pedidoId: pedidoId ?? this.pedidoId);
  }

  LineaPedidoResponse copyWithWrapped(
      {Wrapped<String>? nombreProducto,
      Wrapped<int>? cantidadPorciones,
      Wrapped<String>? precioAcordadoMxn,
      Wrapped<dynamic>? recetaId,
      Wrapped<String>? id,
      Wrapped<String>? pedidoId}) {
    return LineaPedidoResponse(
        nombreProducto: (nombreProducto != null
            ? nombreProducto.value
            : this.nombreProducto),
        cantidadPorciones: (cantidadPorciones != null
            ? cantidadPorciones.value
            : this.cantidadPorciones),
        precioAcordadoMxn: (precioAcordadoMxn != null
            ? precioAcordadoMxn.value
            : this.precioAcordadoMxn),
        recetaId: (recetaId != null ? recetaId.value : this.recetaId),
        id: (id != null ? id.value : this.id),
        pedidoId: (pedidoId != null ? pedidoId.value : this.pedidoId));
  }
}

@JsonSerializable(explicitToJson: true)
class MovimientoCreate {
  const MovimientoCreate({
    required this.tipo,
    required this.cantidad,
    required this.motivo,
  });

  factory MovimientoCreate.fromJson(Map<String, dynamic> json) =>
      _$MovimientoCreateFromJson(json);

  static const toJsonFactory = _$MovimientoCreateToJson;
  Map<String, dynamic> toJson() => _$MovimientoCreateToJson(this);

  @JsonKey(
    name: 'tipo',
    toJson: movimientoCreateTipoToJson,
    fromJson: movimientoCreateTipoFromJson,
  )
  final enums.MovimientoCreateTipo tipo;
  @JsonKey(name: 'cantidad')
  final dynamic cantidad;
  @JsonKey(
    name: 'motivo',
    toJson: movimientoCreateMotivoToJson,
    fromJson: movimientoCreateMotivoFromJson,
  )
  final enums.MovimientoCreateMotivo motivo;
  static const fromJsonFactory = _$MovimientoCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MovimientoCreate &&
            (identical(other.tipo, tipo) ||
                const DeepCollectionEquality().equals(other.tipo, tipo)) &&
            (identical(other.cantidad, cantidad) ||
                const DeepCollectionEquality()
                    .equals(other.cantidad, cantidad)) &&
            (identical(other.motivo, motivo) ||
                const DeepCollectionEquality().equals(other.motivo, motivo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(tipo) ^
      const DeepCollectionEquality().hash(cantidad) ^
      const DeepCollectionEquality().hash(motivo) ^
      runtimeType.hashCode;
}

extension $MovimientoCreateExtension on MovimientoCreate {
  MovimientoCreate copyWith(
      {enums.MovimientoCreateTipo? tipo,
      dynamic cantidad,
      enums.MovimientoCreateMotivo? motivo}) {
    return MovimientoCreate(
        tipo: tipo ?? this.tipo,
        cantidad: cantidad ?? this.cantidad,
        motivo: motivo ?? this.motivo);
  }

  MovimientoCreate copyWithWrapped(
      {Wrapped<enums.MovimientoCreateTipo>? tipo,
      Wrapped<dynamic>? cantidad,
      Wrapped<enums.MovimientoCreateMotivo>? motivo}) {
    return MovimientoCreate(
        tipo: (tipo != null ? tipo.value : this.tipo),
        cantidad: (cantidad != null ? cantidad.value : this.cantidad),
        motivo: (motivo != null ? motivo.value : this.motivo));
  }
}

@JsonSerializable(explicitToJson: true)
class MovimientoResponse {
  const MovimientoResponse({
    required this.id,
    required this.insumoId,
    required this.usuarioId,
    required this.tipo,
    required this.cantidad,
    required this.motivo,
    required this.fecha,
  });

  factory MovimientoResponse.fromJson(Map<String, dynamic> json) =>
      _$MovimientoResponseFromJson(json);

  static const toJsonFactory = _$MovimientoResponseToJson;
  Map<String, dynamic> toJson() => _$MovimientoResponseToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'insumo_id')
  final String insumoId;
  @JsonKey(name: 'usuario_id')
  final String usuarioId;
  @JsonKey(name: 'tipo')
  final String tipo;
  @JsonKey(name: 'cantidad')
  final String cantidad;
  @JsonKey(name: 'motivo')
  final String motivo;
  @JsonKey(name: 'fecha')
  final DateTime fecha;
  static const fromJsonFactory = _$MovimientoResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MovimientoResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.insumoId, insumoId) ||
                const DeepCollectionEquality()
                    .equals(other.insumoId, insumoId)) &&
            (identical(other.usuarioId, usuarioId) ||
                const DeepCollectionEquality()
                    .equals(other.usuarioId, usuarioId)) &&
            (identical(other.tipo, tipo) ||
                const DeepCollectionEquality().equals(other.tipo, tipo)) &&
            (identical(other.cantidad, cantidad) ||
                const DeepCollectionEquality()
                    .equals(other.cantidad, cantidad)) &&
            (identical(other.motivo, motivo) ||
                const DeepCollectionEquality().equals(other.motivo, motivo)) &&
            (identical(other.fecha, fecha) ||
                const DeepCollectionEquality().equals(other.fecha, fecha)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(insumoId) ^
      const DeepCollectionEquality().hash(usuarioId) ^
      const DeepCollectionEquality().hash(tipo) ^
      const DeepCollectionEquality().hash(cantidad) ^
      const DeepCollectionEquality().hash(motivo) ^
      const DeepCollectionEquality().hash(fecha) ^
      runtimeType.hashCode;
}

extension $MovimientoResponseExtension on MovimientoResponse {
  MovimientoResponse copyWith(
      {String? id,
      String? insumoId,
      String? usuarioId,
      String? tipo,
      String? cantidad,
      String? motivo,
      DateTime? fecha}) {
    return MovimientoResponse(
        id: id ?? this.id,
        insumoId: insumoId ?? this.insumoId,
        usuarioId: usuarioId ?? this.usuarioId,
        tipo: tipo ?? this.tipo,
        cantidad: cantidad ?? this.cantidad,
        motivo: motivo ?? this.motivo,
        fecha: fecha ?? this.fecha);
  }

  MovimientoResponse copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? insumoId,
      Wrapped<String>? usuarioId,
      Wrapped<String>? tipo,
      Wrapped<String>? cantidad,
      Wrapped<String>? motivo,
      Wrapped<DateTime>? fecha}) {
    return MovimientoResponse(
        id: (id != null ? id.value : this.id),
        insumoId: (insumoId != null ? insumoId.value : this.insumoId),
        usuarioId: (usuarioId != null ? usuarioId.value : this.usuarioId),
        tipo: (tipo != null ? tipo.value : this.tipo),
        cantidad: (cantidad != null ? cantidad.value : this.cantidad),
        motivo: (motivo != null ? motivo.value : this.motivo),
        fecha: (fecha != null ? fecha.value : this.fecha));
  }
}

@JsonSerializable(explicitToJson: true)
class PasoCreate {
  const PasoCreate({
    required this.orden,
    required this.descripcion,
    this.duracionSegundos,
    this.esCritico,
  });

  factory PasoCreate.fromJson(Map<String, dynamic> json) =>
      _$PasoCreateFromJson(json);

  static const toJsonFactory = _$PasoCreateToJson;
  Map<String, dynamic> toJson() => _$PasoCreateToJson(this);

  @JsonKey(name: 'orden')
  final int orden;
  @JsonKey(name: 'descripcion')
  final String descripcion;
  @JsonKey(name: 'duracion_segundos')
  final dynamic duracionSegundos;
  @JsonKey(name: 'es_critico', defaultValue: false)
  final bool? esCritico;
  static const fromJsonFactory = _$PasoCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PasoCreate &&
            (identical(other.orden, orden) ||
                const DeepCollectionEquality().equals(other.orden, orden)) &&
            (identical(other.descripcion, descripcion) ||
                const DeepCollectionEquality()
                    .equals(other.descripcion, descripcion)) &&
            (identical(other.duracionSegundos, duracionSegundos) ||
                const DeepCollectionEquality()
                    .equals(other.duracionSegundos, duracionSegundos)) &&
            (identical(other.esCritico, esCritico) ||
                const DeepCollectionEquality()
                    .equals(other.esCritico, esCritico)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(orden) ^
      const DeepCollectionEquality().hash(descripcion) ^
      const DeepCollectionEquality().hash(duracionSegundos) ^
      const DeepCollectionEquality().hash(esCritico) ^
      runtimeType.hashCode;
}

extension $PasoCreateExtension on PasoCreate {
  PasoCreate copyWith(
      {int? orden,
      String? descripcion,
      dynamic duracionSegundos,
      bool? esCritico}) {
    return PasoCreate(
        orden: orden ?? this.orden,
        descripcion: descripcion ?? this.descripcion,
        duracionSegundos: duracionSegundos ?? this.duracionSegundos,
        esCritico: esCritico ?? this.esCritico);
  }

  PasoCreate copyWithWrapped(
      {Wrapped<int>? orden,
      Wrapped<String>? descripcion,
      Wrapped<dynamic>? duracionSegundos,
      Wrapped<bool?>? esCritico}) {
    return PasoCreate(
        orden: (orden != null ? orden.value : this.orden),
        descripcion:
            (descripcion != null ? descripcion.value : this.descripcion),
        duracionSegundos: (duracionSegundos != null
            ? duracionSegundos.value
            : this.duracionSegundos),
        esCritico: (esCritico != null ? esCritico.value : this.esCritico));
  }
}

@JsonSerializable(explicitToJson: true)
class PasoResponse {
  const PasoResponse({
    required this.orden,
    required this.descripcion,
    this.duracionSegundos,
    this.esCritico,
    required this.id,
  });

  factory PasoResponse.fromJson(Map<String, dynamic> json) =>
      _$PasoResponseFromJson(json);

  static const toJsonFactory = _$PasoResponseToJson;
  Map<String, dynamic> toJson() => _$PasoResponseToJson(this);

  @JsonKey(name: 'orden')
  final int orden;
  @JsonKey(name: 'descripcion')
  final String descripcion;
  @JsonKey(name: 'duracion_segundos')
  final dynamic duracionSegundos;
  @JsonKey(name: 'es_critico', defaultValue: false)
  final bool? esCritico;
  @JsonKey(name: 'id')
  final String id;
  static const fromJsonFactory = _$PasoResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PasoResponse &&
            (identical(other.orden, orden) ||
                const DeepCollectionEquality().equals(other.orden, orden)) &&
            (identical(other.descripcion, descripcion) ||
                const DeepCollectionEquality()
                    .equals(other.descripcion, descripcion)) &&
            (identical(other.duracionSegundos, duracionSegundos) ||
                const DeepCollectionEquality()
                    .equals(other.duracionSegundos, duracionSegundos)) &&
            (identical(other.esCritico, esCritico) ||
                const DeepCollectionEquality()
                    .equals(other.esCritico, esCritico)) &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(orden) ^
      const DeepCollectionEquality().hash(descripcion) ^
      const DeepCollectionEquality().hash(duracionSegundos) ^
      const DeepCollectionEquality().hash(esCritico) ^
      const DeepCollectionEquality().hash(id) ^
      runtimeType.hashCode;
}

extension $PasoResponseExtension on PasoResponse {
  PasoResponse copyWith(
      {int? orden,
      String? descripcion,
      dynamic duracionSegundos,
      bool? esCritico,
      String? id}) {
    return PasoResponse(
        orden: orden ?? this.orden,
        descripcion: descripcion ?? this.descripcion,
        duracionSegundos: duracionSegundos ?? this.duracionSegundos,
        esCritico: esCritico ?? this.esCritico,
        id: id ?? this.id);
  }

  PasoResponse copyWithWrapped(
      {Wrapped<int>? orden,
      Wrapped<String>? descripcion,
      Wrapped<dynamic>? duracionSegundos,
      Wrapped<bool?>? esCritico,
      Wrapped<String>? id}) {
    return PasoResponse(
        orden: (orden != null ? orden.value : this.orden),
        descripcion:
            (descripcion != null ? descripcion.value : this.descripcion),
        duracionSegundos: (duracionSegundos != null
            ? duracionSegundos.value
            : this.duracionSegundos),
        esCritico: (esCritico != null ? esCritico.value : this.esCritico),
        id: (id != null ? id.value : this.id));
  }
}

@JsonSerializable(explicitToJson: true)
class PedidoCreate {
  const PedidoCreate({
    required this.clienteNombre,
    this.clienteWhatsapp,
    required this.fechaEntrega,
    this.puntoEntrega,
    this.notas,
    required this.lineas,
  });

  factory PedidoCreate.fromJson(Map<String, dynamic> json) =>
      _$PedidoCreateFromJson(json);

  static const toJsonFactory = _$PedidoCreateToJson;
  Map<String, dynamic> toJson() => _$PedidoCreateToJson(this);

  @JsonKey(name: 'cliente_nombre')
  final String clienteNombre;
  @JsonKey(name: 'cliente_whatsapp')
  final dynamic clienteWhatsapp;
  @JsonKey(name: 'fecha_entrega')
  final DateTime fechaEntrega;
  @JsonKey(name: 'punto_entrega')
  final dynamic puntoEntrega;
  @JsonKey(name: 'notas')
  final dynamic notas;
  @JsonKey(name: 'lineas', defaultValue: <LineaPedidoCreate>[])
  final List<LineaPedidoCreate> lineas;
  static const fromJsonFactory = _$PedidoCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PedidoCreate &&
            (identical(other.clienteNombre, clienteNombre) ||
                const DeepCollectionEquality()
                    .equals(other.clienteNombre, clienteNombre)) &&
            (identical(other.clienteWhatsapp, clienteWhatsapp) ||
                const DeepCollectionEquality()
                    .equals(other.clienteWhatsapp, clienteWhatsapp)) &&
            (identical(other.fechaEntrega, fechaEntrega) ||
                const DeepCollectionEquality()
                    .equals(other.fechaEntrega, fechaEntrega)) &&
            (identical(other.puntoEntrega, puntoEntrega) ||
                const DeepCollectionEquality()
                    .equals(other.puntoEntrega, puntoEntrega)) &&
            (identical(other.notas, notas) ||
                const DeepCollectionEquality().equals(other.notas, notas)) &&
            (identical(other.lineas, lineas) ||
                const DeepCollectionEquality().equals(other.lineas, lineas)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(clienteNombre) ^
      const DeepCollectionEquality().hash(clienteWhatsapp) ^
      const DeepCollectionEquality().hash(fechaEntrega) ^
      const DeepCollectionEquality().hash(puntoEntrega) ^
      const DeepCollectionEquality().hash(notas) ^
      const DeepCollectionEquality().hash(lineas) ^
      runtimeType.hashCode;
}

extension $PedidoCreateExtension on PedidoCreate {
  PedidoCreate copyWith(
      {String? clienteNombre,
      dynamic clienteWhatsapp,
      DateTime? fechaEntrega,
      dynamic puntoEntrega,
      dynamic notas,
      List<LineaPedidoCreate>? lineas}) {
    return PedidoCreate(
        clienteNombre: clienteNombre ?? this.clienteNombre,
        clienteWhatsapp: clienteWhatsapp ?? this.clienteWhatsapp,
        fechaEntrega: fechaEntrega ?? this.fechaEntrega,
        puntoEntrega: puntoEntrega ?? this.puntoEntrega,
        notas: notas ?? this.notas,
        lineas: lineas ?? this.lineas);
  }

  PedidoCreate copyWithWrapped(
      {Wrapped<String>? clienteNombre,
      Wrapped<dynamic>? clienteWhatsapp,
      Wrapped<DateTime>? fechaEntrega,
      Wrapped<dynamic>? puntoEntrega,
      Wrapped<dynamic>? notas,
      Wrapped<List<LineaPedidoCreate>>? lineas}) {
    return PedidoCreate(
        clienteNombre:
            (clienteNombre != null ? clienteNombre.value : this.clienteNombre),
        clienteWhatsapp: (clienteWhatsapp != null
            ? clienteWhatsapp.value
            : this.clienteWhatsapp),
        fechaEntrega:
            (fechaEntrega != null ? fechaEntrega.value : this.fechaEntrega),
        puntoEntrega:
            (puntoEntrega != null ? puntoEntrega.value : this.puntoEntrega),
        notas: (notas != null ? notas.value : this.notas),
        lineas: (lineas != null ? lineas.value : this.lineas));
  }
}

@JsonSerializable(explicitToJson: true)
class PedidoResponse {
  const PedidoResponse({
    required this.id,
    required this.usuarioId,
    required this.clienteNombre,
    this.clienteWhatsapp,
    required this.fechaEntrega,
    this.puntoEntrega,
    required this.estado,
    this.notas,
    required this.lineas,
    this.whatsappUrl,
  });

  factory PedidoResponse.fromJson(Map<String, dynamic> json) =>
      _$PedidoResponseFromJson(json);

  static const toJsonFactory = _$PedidoResponseToJson;
  Map<String, dynamic> toJson() => _$PedidoResponseToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'usuario_id')
  final String usuarioId;
  @JsonKey(name: 'cliente_nombre')
  final String clienteNombre;
  @JsonKey(name: 'cliente_whatsapp')
  final dynamic clienteWhatsapp;
  @JsonKey(name: 'fecha_entrega')
  final DateTime fechaEntrega;
  @JsonKey(name: 'punto_entrega')
  final dynamic puntoEntrega;
  @JsonKey(name: 'estado')
  final String estado;
  @JsonKey(name: 'notas')
  final dynamic notas;
  @JsonKey(name: 'lineas', defaultValue: <LineaPedidoResponse>[])
  final List<LineaPedidoResponse> lineas;
  @JsonKey(name: 'whatsapp_url')
  final dynamic whatsappUrl;
  static const fromJsonFactory = _$PedidoResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PedidoResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.usuarioId, usuarioId) ||
                const DeepCollectionEquality()
                    .equals(other.usuarioId, usuarioId)) &&
            (identical(other.clienteNombre, clienteNombre) ||
                const DeepCollectionEquality()
                    .equals(other.clienteNombre, clienteNombre)) &&
            (identical(other.clienteWhatsapp, clienteWhatsapp) ||
                const DeepCollectionEquality()
                    .equals(other.clienteWhatsapp, clienteWhatsapp)) &&
            (identical(other.fechaEntrega, fechaEntrega) ||
                const DeepCollectionEquality()
                    .equals(other.fechaEntrega, fechaEntrega)) &&
            (identical(other.puntoEntrega, puntoEntrega) ||
                const DeepCollectionEquality()
                    .equals(other.puntoEntrega, puntoEntrega)) &&
            (identical(other.estado, estado) ||
                const DeepCollectionEquality().equals(other.estado, estado)) &&
            (identical(other.notas, notas) ||
                const DeepCollectionEquality().equals(other.notas, notas)) &&
            (identical(other.lineas, lineas) ||
                const DeepCollectionEquality().equals(other.lineas, lineas)) &&
            (identical(other.whatsappUrl, whatsappUrl) ||
                const DeepCollectionEquality()
                    .equals(other.whatsappUrl, whatsappUrl)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(usuarioId) ^
      const DeepCollectionEquality().hash(clienteNombre) ^
      const DeepCollectionEquality().hash(clienteWhatsapp) ^
      const DeepCollectionEquality().hash(fechaEntrega) ^
      const DeepCollectionEquality().hash(puntoEntrega) ^
      const DeepCollectionEquality().hash(estado) ^
      const DeepCollectionEquality().hash(notas) ^
      const DeepCollectionEquality().hash(lineas) ^
      const DeepCollectionEquality().hash(whatsappUrl) ^
      runtimeType.hashCode;
}

extension $PedidoResponseExtension on PedidoResponse {
  PedidoResponse copyWith(
      {String? id,
      String? usuarioId,
      String? clienteNombre,
      dynamic clienteWhatsapp,
      DateTime? fechaEntrega,
      dynamic puntoEntrega,
      String? estado,
      dynamic notas,
      List<LineaPedidoResponse>? lineas,
      dynamic whatsappUrl}) {
    return PedidoResponse(
        id: id ?? this.id,
        usuarioId: usuarioId ?? this.usuarioId,
        clienteNombre: clienteNombre ?? this.clienteNombre,
        clienteWhatsapp: clienteWhatsapp ?? this.clienteWhatsapp,
        fechaEntrega: fechaEntrega ?? this.fechaEntrega,
        puntoEntrega: puntoEntrega ?? this.puntoEntrega,
        estado: estado ?? this.estado,
        notas: notas ?? this.notas,
        lineas: lineas ?? this.lineas,
        whatsappUrl: whatsappUrl ?? this.whatsappUrl);
  }

  PedidoResponse copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? usuarioId,
      Wrapped<String>? clienteNombre,
      Wrapped<dynamic>? clienteWhatsapp,
      Wrapped<DateTime>? fechaEntrega,
      Wrapped<dynamic>? puntoEntrega,
      Wrapped<String>? estado,
      Wrapped<dynamic>? notas,
      Wrapped<List<LineaPedidoResponse>>? lineas,
      Wrapped<dynamic>? whatsappUrl}) {
    return PedidoResponse(
        id: (id != null ? id.value : this.id),
        usuarioId: (usuarioId != null ? usuarioId.value : this.usuarioId),
        clienteNombre:
            (clienteNombre != null ? clienteNombre.value : this.clienteNombre),
        clienteWhatsapp: (clienteWhatsapp != null
            ? clienteWhatsapp.value
            : this.clienteWhatsapp),
        fechaEntrega:
            (fechaEntrega != null ? fechaEntrega.value : this.fechaEntrega),
        puntoEntrega:
            (puntoEntrega != null ? puntoEntrega.value : this.puntoEntrega),
        estado: (estado != null ? estado.value : this.estado),
        notas: (notas != null ? notas.value : this.notas),
        lineas: (lineas != null ? lineas.value : this.lineas),
        whatsappUrl:
            (whatsappUrl != null ? whatsappUrl.value : this.whatsappUrl));
  }
}

@JsonSerializable(explicitToJson: true)
class RecetaCreate {
  const RecetaCreate({
    required this.nombre,
    required this.porciones,
    this.margenPct,
    required this.ingredientes,
    this.pasos,
  });

  factory RecetaCreate.fromJson(Map<String, dynamic> json) =>
      _$RecetaCreateFromJson(json);

  static const toJsonFactory = _$RecetaCreateToJson;
  Map<String, dynamic> toJson() => _$RecetaCreateToJson(this);

  @JsonKey(name: 'nombre')
  final String nombre;
  @JsonKey(name: 'porciones')
  final int porciones;
  @JsonKey(name: 'margen_pct')
  final dynamic margenPct;
  @JsonKey(name: 'ingredientes', defaultValue: <IngredienteCreate>[])
  final List<IngredienteCreate> ingredientes;
  @JsonKey(name: 'pasos', defaultValue: <PasoCreate>[])
  final List<PasoCreate>? pasos;
  static const fromJsonFactory = _$RecetaCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RecetaCreate &&
            (identical(other.nombre, nombre) ||
                const DeepCollectionEquality().equals(other.nombre, nombre)) &&
            (identical(other.porciones, porciones) ||
                const DeepCollectionEquality()
                    .equals(other.porciones, porciones)) &&
            (identical(other.margenPct, margenPct) ||
                const DeepCollectionEquality()
                    .equals(other.margenPct, margenPct)) &&
            (identical(other.ingredientes, ingredientes) ||
                const DeepCollectionEquality()
                    .equals(other.ingredientes, ingredientes)) &&
            (identical(other.pasos, pasos) ||
                const DeepCollectionEquality().equals(other.pasos, pasos)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(nombre) ^
      const DeepCollectionEquality().hash(porciones) ^
      const DeepCollectionEquality().hash(margenPct) ^
      const DeepCollectionEquality().hash(ingredientes) ^
      const DeepCollectionEquality().hash(pasos) ^
      runtimeType.hashCode;
}

extension $RecetaCreateExtension on RecetaCreate {
  RecetaCreate copyWith(
      {String? nombre,
      int? porciones,
      dynamic margenPct,
      List<IngredienteCreate>? ingredientes,
      List<PasoCreate>? pasos}) {
    return RecetaCreate(
        nombre: nombre ?? this.nombre,
        porciones: porciones ?? this.porciones,
        margenPct: margenPct ?? this.margenPct,
        ingredientes: ingredientes ?? this.ingredientes,
        pasos: pasos ?? this.pasos);
  }

  RecetaCreate copyWithWrapped(
      {Wrapped<String>? nombre,
      Wrapped<int>? porciones,
      Wrapped<dynamic>? margenPct,
      Wrapped<List<IngredienteCreate>>? ingredientes,
      Wrapped<List<PasoCreate>?>? pasos}) {
    return RecetaCreate(
        nombre: (nombre != null ? nombre.value : this.nombre),
        porciones: (porciones != null ? porciones.value : this.porciones),
        margenPct: (margenPct != null ? margenPct.value : this.margenPct),
        ingredientes:
            (ingredientes != null ? ingredientes.value : this.ingredientes),
        pasos: (pasos != null ? pasos.value : this.pasos));
  }
}

@JsonSerializable(explicitToJson: true)
class RecetaResponse {
  const RecetaResponse({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.porciones,
    required this.margenPct,
    required this.activa,
    required this.ingredientes,
    required this.pasos,
    required this.gastosOcultos,
    this.costoCalculado,
  });

  factory RecetaResponse.fromJson(Map<String, dynamic> json) =>
      _$RecetaResponseFromJson(json);

  static const toJsonFactory = _$RecetaResponseToJson;
  Map<String, dynamic> toJson() => _$RecetaResponseToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'usuario_id')
  final String usuarioId;
  @JsonKey(name: 'nombre')
  final String nombre;
  @JsonKey(name: 'porciones')
  final int porciones;
  @JsonKey(name: 'margen_pct')
  final String margenPct;
  @JsonKey(name: 'activa')
  final bool activa;
  @JsonKey(name: 'ingredientes', defaultValue: <IngredienteResponse>[])
  final List<IngredienteResponse> ingredientes;
  @JsonKey(name: 'pasos', defaultValue: <PasoResponse>[])
  final List<PasoResponse> pasos;
  @JsonKey(name: 'gastos_ocultos', defaultValue: <GastoOcultoResponse>[])
  final List<GastoOcultoResponse> gastosOcultos;
  @JsonKey(name: 'costo_calculado')
  final dynamic costoCalculado;
  static const fromJsonFactory = _$RecetaResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RecetaResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.usuarioId, usuarioId) ||
                const DeepCollectionEquality()
                    .equals(other.usuarioId, usuarioId)) &&
            (identical(other.nombre, nombre) ||
                const DeepCollectionEquality().equals(other.nombre, nombre)) &&
            (identical(other.porciones, porciones) ||
                const DeepCollectionEquality()
                    .equals(other.porciones, porciones)) &&
            (identical(other.margenPct, margenPct) ||
                const DeepCollectionEquality()
                    .equals(other.margenPct, margenPct)) &&
            (identical(other.activa, activa) ||
                const DeepCollectionEquality().equals(other.activa, activa)) &&
            (identical(other.ingredientes, ingredientes) ||
                const DeepCollectionEquality()
                    .equals(other.ingredientes, ingredientes)) &&
            (identical(other.pasos, pasos) ||
                const DeepCollectionEquality().equals(other.pasos, pasos)) &&
            (identical(other.gastosOcultos, gastosOcultos) ||
                const DeepCollectionEquality()
                    .equals(other.gastosOcultos, gastosOcultos)) &&
            (identical(other.costoCalculado, costoCalculado) ||
                const DeepCollectionEquality()
                    .equals(other.costoCalculado, costoCalculado)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(usuarioId) ^
      const DeepCollectionEquality().hash(nombre) ^
      const DeepCollectionEquality().hash(porciones) ^
      const DeepCollectionEquality().hash(margenPct) ^
      const DeepCollectionEquality().hash(activa) ^
      const DeepCollectionEquality().hash(ingredientes) ^
      const DeepCollectionEquality().hash(pasos) ^
      const DeepCollectionEquality().hash(gastosOcultos) ^
      const DeepCollectionEquality().hash(costoCalculado) ^
      runtimeType.hashCode;
}

extension $RecetaResponseExtension on RecetaResponse {
  RecetaResponse copyWith(
      {String? id,
      String? usuarioId,
      String? nombre,
      int? porciones,
      String? margenPct,
      bool? activa,
      List<IngredienteResponse>? ingredientes,
      List<PasoResponse>? pasos,
      List<GastoOcultoResponse>? gastosOcultos,
      dynamic costoCalculado}) {
    return RecetaResponse(
        id: id ?? this.id,
        usuarioId: usuarioId ?? this.usuarioId,
        nombre: nombre ?? this.nombre,
        porciones: porciones ?? this.porciones,
        margenPct: margenPct ?? this.margenPct,
        activa: activa ?? this.activa,
        ingredientes: ingredientes ?? this.ingredientes,
        pasos: pasos ?? this.pasos,
        gastosOcultos: gastosOcultos ?? this.gastosOcultos,
        costoCalculado: costoCalculado ?? this.costoCalculado);
  }

  RecetaResponse copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? usuarioId,
      Wrapped<String>? nombre,
      Wrapped<int>? porciones,
      Wrapped<String>? margenPct,
      Wrapped<bool>? activa,
      Wrapped<List<IngredienteResponse>>? ingredientes,
      Wrapped<List<PasoResponse>>? pasos,
      Wrapped<List<GastoOcultoResponse>>? gastosOcultos,
      Wrapped<dynamic>? costoCalculado}) {
    return RecetaResponse(
        id: (id != null ? id.value : this.id),
        usuarioId: (usuarioId != null ? usuarioId.value : this.usuarioId),
        nombre: (nombre != null ? nombre.value : this.nombre),
        porciones: (porciones != null ? porciones.value : this.porciones),
        margenPct: (margenPct != null ? margenPct.value : this.margenPct),
        activa: (activa != null ? activa.value : this.activa),
        ingredientes:
            (ingredientes != null ? ingredientes.value : this.ingredientes),
        pasos: (pasos != null ? pasos.value : this.pasos),
        gastosOcultos:
            (gastosOcultos != null ? gastosOcultos.value : this.gastosOcultos),
        costoCalculado: (costoCalculado != null
            ? costoCalculado.value
            : this.costoCalculado));
  }
}

@JsonSerializable(explicitToJson: true)
class RecetaUpdate {
  const RecetaUpdate({
    this.nombre,
    this.porciones,
    this.margenPct,
    this.ingredientes,
    this.pasos,
  });

  factory RecetaUpdate.fromJson(Map<String, dynamic> json) =>
      _$RecetaUpdateFromJson(json);

  static const toJsonFactory = _$RecetaUpdateToJson;
  Map<String, dynamic> toJson() => _$RecetaUpdateToJson(this);

  @JsonKey(name: 'nombre')
  final dynamic nombre;
  @JsonKey(name: 'porciones')
  final dynamic porciones;
  @JsonKey(name: 'margen_pct')
  final dynamic margenPct;
  @JsonKey(name: 'ingredientes')
  final dynamic ingredientes;
  @JsonKey(name: 'pasos')
  final dynamic pasos;
  static const fromJsonFactory = _$RecetaUpdateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RecetaUpdate &&
            (identical(other.nombre, nombre) ||
                const DeepCollectionEquality().equals(other.nombre, nombre)) &&
            (identical(other.porciones, porciones) ||
                const DeepCollectionEquality()
                    .equals(other.porciones, porciones)) &&
            (identical(other.margenPct, margenPct) ||
                const DeepCollectionEquality()
                    .equals(other.margenPct, margenPct)) &&
            (identical(other.ingredientes, ingredientes) ||
                const DeepCollectionEquality()
                    .equals(other.ingredientes, ingredientes)) &&
            (identical(other.pasos, pasos) ||
                const DeepCollectionEquality().equals(other.pasos, pasos)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(nombre) ^
      const DeepCollectionEquality().hash(porciones) ^
      const DeepCollectionEquality().hash(margenPct) ^
      const DeepCollectionEquality().hash(ingredientes) ^
      const DeepCollectionEquality().hash(pasos) ^
      runtimeType.hashCode;
}

extension $RecetaUpdateExtension on RecetaUpdate {
  RecetaUpdate copyWith(
      {dynamic nombre,
      dynamic porciones,
      dynamic margenPct,
      dynamic ingredientes,
      dynamic pasos}) {
    return RecetaUpdate(
        nombre: nombre ?? this.nombre,
        porciones: porciones ?? this.porciones,
        margenPct: margenPct ?? this.margenPct,
        ingredientes: ingredientes ?? this.ingredientes,
        pasos: pasos ?? this.pasos);
  }

  RecetaUpdate copyWithWrapped(
      {Wrapped<dynamic>? nombre,
      Wrapped<dynamic>? porciones,
      Wrapped<dynamic>? margenPct,
      Wrapped<dynamic>? ingredientes,
      Wrapped<dynamic>? pasos}) {
    return RecetaUpdate(
        nombre: (nombre != null ? nombre.value : this.nombre),
        porciones: (porciones != null ? porciones.value : this.porciones),
        margenPct: (margenPct != null ? margenPct.value : this.margenPct),
        ingredientes:
            (ingredientes != null ? ingredientes.value : this.ingredientes),
        pasos: (pasos != null ? pasos.value : this.pasos));
  }
}

@JsonSerializable(explicitToJson: true)
class ToggleGastoRequest {
  const ToggleGastoRequest({
    required this.activo,
  });

  factory ToggleGastoRequest.fromJson(Map<String, dynamic> json) =>
      _$ToggleGastoRequestFromJson(json);

  static const toJsonFactory = _$ToggleGastoRequestToJson;
  Map<String, dynamic> toJson() => _$ToggleGastoRequestToJson(this);

  @JsonKey(name: 'activo')
  final bool activo;
  static const fromJsonFactory = _$ToggleGastoRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ToggleGastoRequest &&
            (identical(other.activo, activo) ||
                const DeepCollectionEquality().equals(other.activo, activo)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(activo) ^ runtimeType.hashCode;
}

extension $ToggleGastoRequestExtension on ToggleGastoRequest {
  ToggleGastoRequest copyWith({bool? activo}) {
    return ToggleGastoRequest(activo: activo ?? this.activo);
  }

  ToggleGastoRequest copyWithWrapped({Wrapped<bool>? activo}) {
    return ToggleGastoRequest(
        activo: (activo != null ? activo.value : this.activo));
  }
}

@JsonSerializable(explicitToJson: true)
class Token {
  const Token({
    required this.accessToken,
    required this.tokenType,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  static const toJsonFactory = _$TokenToJson;
  Map<String, dynamic> toJson() => _$TokenToJson(this);

  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String tokenType;
  static const fromJsonFactory = _$TokenFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Token &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality()
                    .equals(other.accessToken, accessToken)) &&
            (identical(other.tokenType, tokenType) ||
                const DeepCollectionEquality()
                    .equals(other.tokenType, tokenType)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(tokenType) ^
      runtimeType.hashCode;
}

extension $TokenExtension on Token {
  Token copyWith({String? accessToken, String? tokenType}) {
    return Token(
        accessToken: accessToken ?? this.accessToken,
        tokenType: tokenType ?? this.tokenType);
  }

  Token copyWithWrapped(
      {Wrapped<String>? accessToken, Wrapped<String>? tokenType}) {
    return Token(
        accessToken:
            (accessToken != null ? accessToken.value : this.accessToken),
        tokenType: (tokenType != null ? tokenType.value : this.tokenType));
  }
}

@JsonSerializable(explicitToJson: true)
class UserCreate {
  const UserCreate({
    required this.email,
    required this.password,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) =>
      _$UserCreateFromJson(json);

  static const toJsonFactory = _$UserCreateToJson;
  Map<String, dynamic> toJson() => _$UserCreateToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$UserCreateFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserCreate &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $UserCreateExtension on UserCreate {
  UserCreate copyWith({String? email, String? password}) {
    return UserCreate(
        email: email ?? this.email, password: password ?? this.password);
  }

  UserCreate copyWithWrapped(
      {Wrapped<String>? email, Wrapped<String>? password}) {
    return UserCreate(
        email: (email != null ? email.value : this.email),
        password: (password != null ? password.value : this.password));
  }
}

@JsonSerializable(explicitToJson: true)
class UserResponse {
  const UserResponse({
    required this.id,
    required this.email,
    this.isActive,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  static const toJsonFactory = _$UserResponseToJson;
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool? isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  static const fromJsonFactory = _$UserResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserResponse &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality()
                    .equals(other.isActive, isActive)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(createdAt) ^
      runtimeType.hashCode;
}

extension $UserResponseExtension on UserResponse {
  UserResponse copyWith(
      {String? id, String? email, bool? isActive, DateTime? createdAt}) {
    return UserResponse(
        id: id ?? this.id,
        email: email ?? this.email,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt);
  }

  UserResponse copyWithWrapped(
      {Wrapped<String>? id,
      Wrapped<String>? email,
      Wrapped<bool?>? isActive,
      Wrapped<DateTime>? createdAt}) {
    return UserResponse(
        id: (id != null ? id.value : this.id),
        email: (email != null ? email.value : this.email),
        isActive: (isActive != null ? isActive.value : this.isActive),
        createdAt: (createdAt != null ? createdAt.value : this.createdAt));
  }
}

@JsonSerializable(explicitToJson: true)
class ValidationError {
  const ValidationError({
    required this.loc,
    required this.msg,
    required this.type,
    this.input,
    this.ctx,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);

  static const toJsonFactory = _$ValidationErrorToJson;
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);

  @JsonKey(name: 'loc', defaultValue: <Object>[])
  final List<Object> loc;
  @JsonKey(name: 'msg')
  final String msg;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'input')
  final dynamic input;
  @JsonKey(name: 'ctx')
  final Object? ctx;
  static const fromJsonFactory = _$ValidationErrorFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidationError &&
            (identical(other.loc, loc) ||
                const DeepCollectionEquality().equals(other.loc, loc)) &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.input, input) ||
                const DeepCollectionEquality().equals(other.input, input)) &&
            (identical(other.ctx, ctx) ||
                const DeepCollectionEquality().equals(other.ctx, ctx)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(loc) ^
      const DeepCollectionEquality().hash(msg) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(input) ^
      const DeepCollectionEquality().hash(ctx) ^
      runtimeType.hashCode;
}

extension $ValidationErrorExtension on ValidationError {
  ValidationError copyWith(
      {List<Object>? loc,
      String? msg,
      String? type,
      dynamic input,
      Object? ctx}) {
    return ValidationError(
        loc: loc ?? this.loc,
        msg: msg ?? this.msg,
        type: type ?? this.type,
        input: input ?? this.input,
        ctx: ctx ?? this.ctx);
  }

  ValidationError copyWithWrapped(
      {Wrapped<List<Object>>? loc,
      Wrapped<String>? msg,
      Wrapped<String>? type,
      Wrapped<dynamic>? input,
      Wrapped<Object?>? ctx}) {
    return ValidationError(
        loc: (loc != null ? loc.value : this.loc),
        msg: (msg != null ? msg.value : this.msg),
        type: (type != null ? type.value : this.type),
        input: (input != null ? input.value : this.input),
        ctx: (ctx != null ? ctx.value : this.ctx));
  }
}

String? gastoOcultoCreateTipoNullableToJson(
    enums.GastoOcultoCreateTipo? gastoOcultoCreateTipo) {
  return gastoOcultoCreateTipo?.value;
}

String? gastoOcultoCreateTipoToJson(
    enums.GastoOcultoCreateTipo gastoOcultoCreateTipo) {
  return gastoOcultoCreateTipo.value;
}

enums.GastoOcultoCreateTipo gastoOcultoCreateTipoFromJson(
  Object? gastoOcultoCreateTipo, [
  enums.GastoOcultoCreateTipo? defaultValue,
]) {
  return enums.GastoOcultoCreateTipo.values
          .firstWhereOrNull((e) => e.value == gastoOcultoCreateTipo) ??
      defaultValue ??
      enums.GastoOcultoCreateTipo.swaggerGeneratedUnknown;
}

enums.GastoOcultoCreateTipo? gastoOcultoCreateTipoNullableFromJson(
  Object? gastoOcultoCreateTipo, [
  enums.GastoOcultoCreateTipo? defaultValue,
]) {
  if (gastoOcultoCreateTipo == null) {
    return null;
  }
  return enums.GastoOcultoCreateTipo.values
          .firstWhereOrNull((e) => e.value == gastoOcultoCreateTipo) ??
      defaultValue;
}

String gastoOcultoCreateTipoExplodedListToJson(
    List<enums.GastoOcultoCreateTipo>? gastoOcultoCreateTipo) {
  return gastoOcultoCreateTipo?.map((e) => e.value!).join(',') ?? '';
}

List<String> gastoOcultoCreateTipoListToJson(
    List<enums.GastoOcultoCreateTipo>? gastoOcultoCreateTipo) {
  if (gastoOcultoCreateTipo == null) {
    return [];
  }

  return gastoOcultoCreateTipo.map((e) => e.value!).toList();
}

List<enums.GastoOcultoCreateTipo> gastoOcultoCreateTipoListFromJson(
  List? gastoOcultoCreateTipo, [
  List<enums.GastoOcultoCreateTipo>? defaultValue,
]) {
  if (gastoOcultoCreateTipo == null) {
    return defaultValue ?? [];
  }

  return gastoOcultoCreateTipo
      .map((e) => gastoOcultoCreateTipoFromJson(e.toString()))
      .toList();
}

List<enums.GastoOcultoCreateTipo>? gastoOcultoCreateTipoNullableListFromJson(
  List? gastoOcultoCreateTipo, [
  List<enums.GastoOcultoCreateTipo>? defaultValue,
]) {
  if (gastoOcultoCreateTipo == null) {
    return defaultValue;
  }

  return gastoOcultoCreateTipo
      .map((e) => gastoOcultoCreateTipoFromJson(e.toString()))
      .toList();
}

String? gastoOcultoResponseTipoNullableToJson(
    enums.GastoOcultoResponseTipo? gastoOcultoResponseTipo) {
  return gastoOcultoResponseTipo?.value;
}

String? gastoOcultoResponseTipoToJson(
    enums.GastoOcultoResponseTipo gastoOcultoResponseTipo) {
  return gastoOcultoResponseTipo.value;
}

enums.GastoOcultoResponseTipo gastoOcultoResponseTipoFromJson(
  Object? gastoOcultoResponseTipo, [
  enums.GastoOcultoResponseTipo? defaultValue,
]) {
  return enums.GastoOcultoResponseTipo.values
          .firstWhereOrNull((e) => e.value == gastoOcultoResponseTipo) ??
      defaultValue ??
      enums.GastoOcultoResponseTipo.swaggerGeneratedUnknown;
}

enums.GastoOcultoResponseTipo? gastoOcultoResponseTipoNullableFromJson(
  Object? gastoOcultoResponseTipo, [
  enums.GastoOcultoResponseTipo? defaultValue,
]) {
  if (gastoOcultoResponseTipo == null) {
    return null;
  }
  return enums.GastoOcultoResponseTipo.values
          .firstWhereOrNull((e) => e.value == gastoOcultoResponseTipo) ??
      defaultValue;
}

String gastoOcultoResponseTipoExplodedListToJson(
    List<enums.GastoOcultoResponseTipo>? gastoOcultoResponseTipo) {
  return gastoOcultoResponseTipo?.map((e) => e.value!).join(',') ?? '';
}

List<String> gastoOcultoResponseTipoListToJson(
    List<enums.GastoOcultoResponseTipo>? gastoOcultoResponseTipo) {
  if (gastoOcultoResponseTipo == null) {
    return [];
  }

  return gastoOcultoResponseTipo.map((e) => e.value!).toList();
}

List<enums.GastoOcultoResponseTipo> gastoOcultoResponseTipoListFromJson(
  List? gastoOcultoResponseTipo, [
  List<enums.GastoOcultoResponseTipo>? defaultValue,
]) {
  if (gastoOcultoResponseTipo == null) {
    return defaultValue ?? [];
  }

  return gastoOcultoResponseTipo
      .map((e) => gastoOcultoResponseTipoFromJson(e.toString()))
      .toList();
}

List<enums.GastoOcultoResponseTipo>?
    gastoOcultoResponseTipoNullableListFromJson(
  List? gastoOcultoResponseTipo, [
  List<enums.GastoOcultoResponseTipo>? defaultValue,
]) {
  if (gastoOcultoResponseTipo == null) {
    return defaultValue;
  }

  return gastoOcultoResponseTipo
      .map((e) => gastoOcultoResponseTipoFromJson(e.toString()))
      .toList();
}

String? insumoCreateUnidadNullableToJson(
    enums.InsumoCreateUnidad? insumoCreateUnidad) {
  return insumoCreateUnidad?.value;
}

String? insumoCreateUnidadToJson(enums.InsumoCreateUnidad insumoCreateUnidad) {
  return insumoCreateUnidad.value;
}

enums.InsumoCreateUnidad insumoCreateUnidadFromJson(
  Object? insumoCreateUnidad, [
  enums.InsumoCreateUnidad? defaultValue,
]) {
  return enums.InsumoCreateUnidad.values
          .firstWhereOrNull((e) => e.value == insumoCreateUnidad) ??
      defaultValue ??
      enums.InsumoCreateUnidad.swaggerGeneratedUnknown;
}

enums.InsumoCreateUnidad? insumoCreateUnidadNullableFromJson(
  Object? insumoCreateUnidad, [
  enums.InsumoCreateUnidad? defaultValue,
]) {
  if (insumoCreateUnidad == null) {
    return null;
  }
  return enums.InsumoCreateUnidad.values
          .firstWhereOrNull((e) => e.value == insumoCreateUnidad) ??
      defaultValue;
}

String insumoCreateUnidadExplodedListToJson(
    List<enums.InsumoCreateUnidad>? insumoCreateUnidad) {
  return insumoCreateUnidad?.map((e) => e.value!).join(',') ?? '';
}

List<String> insumoCreateUnidadListToJson(
    List<enums.InsumoCreateUnidad>? insumoCreateUnidad) {
  if (insumoCreateUnidad == null) {
    return [];
  }

  return insumoCreateUnidad.map((e) => e.value!).toList();
}

List<enums.InsumoCreateUnidad> insumoCreateUnidadListFromJson(
  List? insumoCreateUnidad, [
  List<enums.InsumoCreateUnidad>? defaultValue,
]) {
  if (insumoCreateUnidad == null) {
    return defaultValue ?? [];
  }

  return insumoCreateUnidad
      .map((e) => insumoCreateUnidadFromJson(e.toString()))
      .toList();
}

List<enums.InsumoCreateUnidad>? insumoCreateUnidadNullableListFromJson(
  List? insumoCreateUnidad, [
  List<enums.InsumoCreateUnidad>? defaultValue,
]) {
  if (insumoCreateUnidad == null) {
    return defaultValue;
  }

  return insumoCreateUnidad
      .map((e) => insumoCreateUnidadFromJson(e.toString()))
      .toList();
}

String? insumoResponseUnidadNullableToJson(
    enums.InsumoResponseUnidad? insumoResponseUnidad) {
  return insumoResponseUnidad?.value;
}

String? insumoResponseUnidadToJson(
    enums.InsumoResponseUnidad insumoResponseUnidad) {
  return insumoResponseUnidad.value;
}

enums.InsumoResponseUnidad insumoResponseUnidadFromJson(
  Object? insumoResponseUnidad, [
  enums.InsumoResponseUnidad? defaultValue,
]) {
  return enums.InsumoResponseUnidad.values
          .firstWhereOrNull((e) => e.value == insumoResponseUnidad) ??
      defaultValue ??
      enums.InsumoResponseUnidad.swaggerGeneratedUnknown;
}

enums.InsumoResponseUnidad? insumoResponseUnidadNullableFromJson(
  Object? insumoResponseUnidad, [
  enums.InsumoResponseUnidad? defaultValue,
]) {
  if (insumoResponseUnidad == null) {
    return null;
  }
  return enums.InsumoResponseUnidad.values
          .firstWhereOrNull((e) => e.value == insumoResponseUnidad) ??
      defaultValue;
}

String insumoResponseUnidadExplodedListToJson(
    List<enums.InsumoResponseUnidad>? insumoResponseUnidad) {
  return insumoResponseUnidad?.map((e) => e.value!).join(',') ?? '';
}

List<String> insumoResponseUnidadListToJson(
    List<enums.InsumoResponseUnidad>? insumoResponseUnidad) {
  if (insumoResponseUnidad == null) {
    return [];
  }

  return insumoResponseUnidad.map((e) => e.value!).toList();
}

List<enums.InsumoResponseUnidad> insumoResponseUnidadListFromJson(
  List? insumoResponseUnidad, [
  List<enums.InsumoResponseUnidad>? defaultValue,
]) {
  if (insumoResponseUnidad == null) {
    return defaultValue ?? [];
  }

  return insumoResponseUnidad
      .map((e) => insumoResponseUnidadFromJson(e.toString()))
      .toList();
}

List<enums.InsumoResponseUnidad>? insumoResponseUnidadNullableListFromJson(
  List? insumoResponseUnidad, [
  List<enums.InsumoResponseUnidad>? defaultValue,
]) {
  if (insumoResponseUnidad == null) {
    return defaultValue;
  }

  return insumoResponseUnidad
      .map((e) => insumoResponseUnidadFromJson(e.toString()))
      .toList();
}

String? movimientoCreateTipoNullableToJson(
    enums.MovimientoCreateTipo? movimientoCreateTipo) {
  return movimientoCreateTipo?.value;
}

String? movimientoCreateTipoToJson(
    enums.MovimientoCreateTipo movimientoCreateTipo) {
  return movimientoCreateTipo.value;
}

enums.MovimientoCreateTipo movimientoCreateTipoFromJson(
  Object? movimientoCreateTipo, [
  enums.MovimientoCreateTipo? defaultValue,
]) {
  return enums.MovimientoCreateTipo.values
          .firstWhereOrNull((e) => e.value == movimientoCreateTipo) ??
      defaultValue ??
      enums.MovimientoCreateTipo.swaggerGeneratedUnknown;
}

enums.MovimientoCreateTipo? movimientoCreateTipoNullableFromJson(
  Object? movimientoCreateTipo, [
  enums.MovimientoCreateTipo? defaultValue,
]) {
  if (movimientoCreateTipo == null) {
    return null;
  }
  return enums.MovimientoCreateTipo.values
          .firstWhereOrNull((e) => e.value == movimientoCreateTipo) ??
      defaultValue;
}

String movimientoCreateTipoExplodedListToJson(
    List<enums.MovimientoCreateTipo>? movimientoCreateTipo) {
  return movimientoCreateTipo?.map((e) => e.value!).join(',') ?? '';
}

List<String> movimientoCreateTipoListToJson(
    List<enums.MovimientoCreateTipo>? movimientoCreateTipo) {
  if (movimientoCreateTipo == null) {
    return [];
  }

  return movimientoCreateTipo.map((e) => e.value!).toList();
}

List<enums.MovimientoCreateTipo> movimientoCreateTipoListFromJson(
  List? movimientoCreateTipo, [
  List<enums.MovimientoCreateTipo>? defaultValue,
]) {
  if (movimientoCreateTipo == null) {
    return defaultValue ?? [];
  }

  return movimientoCreateTipo
      .map((e) => movimientoCreateTipoFromJson(e.toString()))
      .toList();
}

List<enums.MovimientoCreateTipo>? movimientoCreateTipoNullableListFromJson(
  List? movimientoCreateTipo, [
  List<enums.MovimientoCreateTipo>? defaultValue,
]) {
  if (movimientoCreateTipo == null) {
    return defaultValue;
  }

  return movimientoCreateTipo
      .map((e) => movimientoCreateTipoFromJson(e.toString()))
      .toList();
}

String? movimientoCreateMotivoNullableToJson(
    enums.MovimientoCreateMotivo? movimientoCreateMotivo) {
  return movimientoCreateMotivo?.value;
}

String? movimientoCreateMotivoToJson(
    enums.MovimientoCreateMotivo movimientoCreateMotivo) {
  return movimientoCreateMotivo.value;
}

enums.MovimientoCreateMotivo movimientoCreateMotivoFromJson(
  Object? movimientoCreateMotivo, [
  enums.MovimientoCreateMotivo? defaultValue,
]) {
  return enums.MovimientoCreateMotivo.values
          .firstWhereOrNull((e) => e.value == movimientoCreateMotivo) ??
      defaultValue ??
      enums.MovimientoCreateMotivo.swaggerGeneratedUnknown;
}

enums.MovimientoCreateMotivo? movimientoCreateMotivoNullableFromJson(
  Object? movimientoCreateMotivo, [
  enums.MovimientoCreateMotivo? defaultValue,
]) {
  if (movimientoCreateMotivo == null) {
    return null;
  }
  return enums.MovimientoCreateMotivo.values
          .firstWhereOrNull((e) => e.value == movimientoCreateMotivo) ??
      defaultValue;
}

String movimientoCreateMotivoExplodedListToJson(
    List<enums.MovimientoCreateMotivo>? movimientoCreateMotivo) {
  return movimientoCreateMotivo?.map((e) => e.value!).join(',') ?? '';
}

List<String> movimientoCreateMotivoListToJson(
    List<enums.MovimientoCreateMotivo>? movimientoCreateMotivo) {
  if (movimientoCreateMotivo == null) {
    return [];
  }

  return movimientoCreateMotivo.map((e) => e.value!).toList();
}

List<enums.MovimientoCreateMotivo> movimientoCreateMotivoListFromJson(
  List? movimientoCreateMotivo, [
  List<enums.MovimientoCreateMotivo>? defaultValue,
]) {
  if (movimientoCreateMotivo == null) {
    return defaultValue ?? [];
  }

  return movimientoCreateMotivo
      .map((e) => movimientoCreateMotivoFromJson(e.toString()))
      .toList();
}

List<enums.MovimientoCreateMotivo>? movimientoCreateMotivoNullableListFromJson(
  List? movimientoCreateMotivo, [
  List<enums.MovimientoCreateMotivo>? defaultValue,
]) {
  if (movimientoCreateMotivo == null) {
    return defaultValue;
  }

  return movimientoCreateMotivo
      .map((e) => movimientoCreateMotivoFromJson(e.toString()))
      .toList();
}

String? apiV1RecetasIdGastosOcultosTipoTogglePatchTipoNullableToJson(
    enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo?
        apiV1RecetasIdGastosOcultosTipoTogglePatchTipo) {
  return apiV1RecetasIdGastosOcultosTipoTogglePatchTipo?.value;
}

String? apiV1RecetasIdGastosOcultosTipoTogglePatchTipoToJson(
    enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo
        apiV1RecetasIdGastosOcultosTipoTogglePatchTipo) {
  return apiV1RecetasIdGastosOcultosTipoTogglePatchTipo.value;
}

enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo
    apiV1RecetasIdGastosOcultosTipoTogglePatchTipoFromJson(
  Object? apiV1RecetasIdGastosOcultosTipoTogglePatchTipo, [
  enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo? defaultValue,
]) {
  return enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo.values
          .firstWhereOrNull((e) =>
              e.value == apiV1RecetasIdGastosOcultosTipoTogglePatchTipo) ??
      defaultValue ??
      enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo
          .swaggerGeneratedUnknown;
}

enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo?
    apiV1RecetasIdGastosOcultosTipoTogglePatchTipoNullableFromJson(
  Object? apiV1RecetasIdGastosOcultosTipoTogglePatchTipo, [
  enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo? defaultValue,
]) {
  if (apiV1RecetasIdGastosOcultosTipoTogglePatchTipo == null) {
    return null;
  }
  return enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo.values
          .firstWhereOrNull((e) =>
              e.value == apiV1RecetasIdGastosOcultosTipoTogglePatchTipo) ??
      defaultValue;
}

String apiV1RecetasIdGastosOcultosTipoTogglePatchTipoExplodedListToJson(
    List<enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo>?
        apiV1RecetasIdGastosOcultosTipoTogglePatchTipo) {
  return apiV1RecetasIdGastosOcultosTipoTogglePatchTipo
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<String> apiV1RecetasIdGastosOcultosTipoTogglePatchTipoListToJson(
    List<enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo>?
        apiV1RecetasIdGastosOcultosTipoTogglePatchTipo) {
  if (apiV1RecetasIdGastosOcultosTipoTogglePatchTipo == null) {
    return [];
  }

  return apiV1RecetasIdGastosOcultosTipoTogglePatchTipo
      .map((e) => e.value!)
      .toList();
}

List<enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo>
    apiV1RecetasIdGastosOcultosTipoTogglePatchTipoListFromJson(
  List? apiV1RecetasIdGastosOcultosTipoTogglePatchTipo, [
  List<enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo>? defaultValue,
]) {
  if (apiV1RecetasIdGastosOcultosTipoTogglePatchTipo == null) {
    return defaultValue ?? [];
  }

  return apiV1RecetasIdGastosOcultosTipoTogglePatchTipo
      .map((e) =>
          apiV1RecetasIdGastosOcultosTipoTogglePatchTipoFromJson(e.toString()))
      .toList();
}

List<enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo>?
    apiV1RecetasIdGastosOcultosTipoTogglePatchTipoNullableListFromJson(
  List? apiV1RecetasIdGastosOcultosTipoTogglePatchTipo, [
  List<enums.ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo>? defaultValue,
]) {
  if (apiV1RecetasIdGastosOcultosTipoTogglePatchTipo == null) {
    return defaultValue;
  }

  return apiV1RecetasIdGastosOcultosTipoTogglePatchTipo
      .map((e) =>
          apiV1RecetasIdGastosOcultosTipoTogglePatchTipoFromJson(e.toString()))
      .toList();
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
