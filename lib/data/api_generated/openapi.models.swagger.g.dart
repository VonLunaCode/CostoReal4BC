// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openapi.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyLoginForAccessTokenApiV1AuthLoginPost
    _$BodyLoginForAccessTokenApiV1AuthLoginPostFromJson(
            Map<String, dynamic> json) =>
        BodyLoginForAccessTokenApiV1AuthLoginPost(
          grantType: json['grant_type'],
          username: json['username'] as String,
          password: json['password'] as String,
          scope: json['scope'] as String?,
          clientId: json['client_id'],
          clientSecret: json['client_secret'],
        );

Map<String, dynamic> _$BodyLoginForAccessTokenApiV1AuthLoginPostToJson(
        BodyLoginForAccessTokenApiV1AuthLoginPost instance) =>
    <String, dynamic>{
      'grant_type': instance.grantType,
      'username': instance.username,
      'password': instance.password,
      'scope': instance.scope,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
    };

HTTPValidationError _$HTTPValidationErrorFromJson(Map<String, dynamic> json) =>
    HTTPValidationError(
      detail: (json['detail'] as List<dynamic>?)
              ?.map((e) => ValidationError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HTTPValidationErrorToJson(
        HTTPValidationError instance) =>
    <String, dynamic>{
      'detail': instance.detail?.map((e) => e.toJson()).toList(),
    };

InsumoCreate _$InsumoCreateFromJson(Map<String, dynamic> json) => InsumoCreate(
      nombre: json['nombre'] as String,
      unidad: insumoCreateUnidadFromJson(json['unidad']),
      precioCompra: json['precio_compra'],
      cantidadComprada: json['cantidad_comprada'],
      alertaMinimo: json['alerta_minimo'],
    );

Map<String, dynamic> _$InsumoCreateToJson(InsumoCreate instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'unidad': insumoCreateUnidadToJson(instance.unidad),
      'precio_compra': instance.precioCompra,
      'cantidad_comprada': instance.cantidadComprada,
      'alerta_minimo': instance.alertaMinimo,
    };

InsumoResponse _$InsumoResponseFromJson(Map<String, dynamic> json) =>
    InsumoResponse(
      nombre: json['nombre'] as String,
      unidad: insumoResponseUnidadFromJson(json['unidad']),
      precioCompra: json['precio_compra'] as String,
      cantidadComprada: json['cantidad_comprada'] as String,
      alertaMinimo: json['alerta_minimo'] as String?,
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      cantidadActual: json['cantidad_actual'] as String,
      fechaUltimoPrecio: DateTime.parse(json['fecha_ultimo_precio'] as String),
      activo: json['activo'] as bool,
    );

Map<String, dynamic> _$InsumoResponseToJson(InsumoResponse instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'unidad': insumoResponseUnidadToJson(instance.unidad),
      'precio_compra': instance.precioCompra,
      'cantidad_comprada': instance.cantidadComprada,
      'alerta_minimo': instance.alertaMinimo,
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'cantidad_actual': instance.cantidadActual,
      'fecha_ultimo_precio': _dateToJson(instance.fechaUltimoPrecio),
      'activo': instance.activo,
    };

InsumoUpdate _$InsumoUpdateFromJson(Map<String, dynamic> json) => InsumoUpdate(
      nombre: json['nombre'],
      unidad: json['unidad'],
      precioCompra: json['precio_compra'],
      cantidadComprada: json['cantidad_comprada'],
      alertaMinimo: json['alerta_minimo'],
    );

Map<String, dynamic> _$InsumoUpdateToJson(InsumoUpdate instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'unidad': instance.unidad,
      'precio_compra': instance.precioCompra,
      'cantidad_comprada': instance.cantidadComprada,
      'alerta_minimo': instance.alertaMinimo,
    };

MovimientoCreate _$MovimientoCreateFromJson(Map<String, dynamic> json) =>
    MovimientoCreate(
      tipo: movimientoCreateTipoFromJson(json['tipo']),
      cantidad: json['cantidad'],
      motivo: movimientoCreateMotivoFromJson(json['motivo']),
    );

Map<String, dynamic> _$MovimientoCreateToJson(MovimientoCreate instance) =>
    <String, dynamic>{
      'tipo': movimientoCreateTipoToJson(instance.tipo),
      'cantidad': instance.cantidad,
      'motivo': movimientoCreateMotivoToJson(instance.motivo),
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
    };

UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => UserCreate(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserCreateToJson(UserCreate instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
    };

ValidationError _$ValidationErrorFromJson(Map<String, dynamic> json) =>
    ValidationError(
      loc: (json['loc'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
          [],
      msg: json['msg'] as String,
      type: json['type'] as String,
      input: json['input'],
      ctx: json['ctx'],
    );

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'loc': instance.loc,
      'msg': instance.msg,
      'type': instance.type,
      'input': instance.input,
      'ctx': instance.ctx,
    };
