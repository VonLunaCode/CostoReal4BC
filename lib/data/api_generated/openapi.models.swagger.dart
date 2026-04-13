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
