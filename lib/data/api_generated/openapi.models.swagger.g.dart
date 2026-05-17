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

ColisionHoraResponse _$ColisionHoraResponseFromJson(
        Map<String, dynamic> json) =>
    ColisionHoraResponse(
      hayColision: json['hay_colision'] as bool,
      cantidad: (json['cantidad'] as num).toInt(),
      horaInicio: json['hora_inicio'] as String,
      horaFin: json['hora_fin'] as String,
    );

Map<String, dynamic> _$ColisionHoraResponseToJson(
        ColisionHoraResponse instance) =>
    <String, dynamic>{
      'hay_colision': instance.hayColision,
      'cantidad': instance.cantidad,
      'hora_inicio': instance.horaInicio,
      'hora_fin': instance.horaFin,
    };

GastoOcultoCreate _$GastoOcultoCreateFromJson(Map<String, dynamic> json) =>
    GastoOcultoCreate(
      tipo: gastoOcultoCreateTipoFromJson(json['tipo']),
      valor: json['valor'],
      esPorcentaje: json['es_porcentaje'] as bool,
      activo: json['activo'] as bool? ?? false,
    );

Map<String, dynamic> _$GastoOcultoCreateToJson(GastoOcultoCreate instance) =>
    <String, dynamic>{
      'tipo': gastoOcultoCreateTipoToJson(instance.tipo),
      'valor': instance.valor,
      'es_porcentaje': instance.esPorcentaje,
      'activo': instance.activo,
    };

GastoOcultoResponse _$GastoOcultoResponseFromJson(Map<String, dynamic> json) =>
    GastoOcultoResponse(
      tipo: gastoOcultoResponseTipoFromJson(json['tipo']),
      valor: json['valor'] as String,
      esPorcentaje: json['es_porcentaje'] as bool,
      activo: json['activo'] as bool? ?? false,
      id: json['id'] as String,
    );

Map<String, dynamic> _$GastoOcultoResponseToJson(
        GastoOcultoResponse instance) =>
    <String, dynamic>{
      'tipo': gastoOcultoResponseTipoToJson(instance.tipo),
      'valor': instance.valor,
      'es_porcentaje': instance.esPorcentaje,
      'activo': instance.activo,
      'id': instance.id,
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

IngredienteCreate _$IngredienteCreateFromJson(Map<String, dynamic> json) =>
    IngredienteCreate(
      insumoId: json['insumo_id'] as String,
      cantidadUsada: json['cantidad_usada'],
      unidad: json['unidad'] as String,
    );

Map<String, dynamic> _$IngredienteCreateToJson(IngredienteCreate instance) =>
    <String, dynamic>{
      'insumo_id': instance.insumoId,
      'cantidad_usada': instance.cantidadUsada,
      'unidad': instance.unidad,
    };

IngredienteResponse _$IngredienteResponseFromJson(Map<String, dynamic> json) =>
    IngredienteResponse(
      id: json['id'] as String,
      insumo: InsumoResponse.fromJson(json['insumo'] as Map<String, dynamic>),
      cantidadUsada: json['cantidad_usada'] as String,
      unidad: json['unidad'] as String,
    );

Map<String, dynamic> _$IngredienteResponseToJson(
        IngredienteResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'insumo': instance.insumo.toJson(),
      'cantidad_usada': instance.cantidadUsada,
      'unidad': instance.unidad,
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

LineaPedidoCreate _$LineaPedidoCreateFromJson(Map<String, dynamic> json) =>
    LineaPedidoCreate(
      nombreProducto: json['nombre_producto'] as String,
      cantidadPorciones: (json['cantidad_porciones'] as num).toInt(),
      precioAcordadoMxn: json['precio_acordado_mxn'],
      recetaId: json['receta_id'],
    );

Map<String, dynamic> _$LineaPedidoCreateToJson(LineaPedidoCreate instance) =>
    <String, dynamic>{
      'nombre_producto': instance.nombreProducto,
      'cantidad_porciones': instance.cantidadPorciones,
      'precio_acordado_mxn': instance.precioAcordadoMxn,
      'receta_id': instance.recetaId,
    };

LineaPedidoResponse _$LineaPedidoResponseFromJson(Map<String, dynamic> json) =>
    LineaPedidoResponse(
      nombreProducto: json['nombre_producto'] as String,
      cantidadPorciones: (json['cantidad_porciones'] as num).toInt(),
      precioAcordadoMxn: json['precio_acordado_mxn'] as String,
      recetaId: json['receta_id'],
      id: json['id'] as String,
      pedidoId: json['pedido_id'] as String,
    );

Map<String, dynamic> _$LineaPedidoResponseToJson(
        LineaPedidoResponse instance) =>
    <String, dynamic>{
      'nombre_producto': instance.nombreProducto,
      'cantidad_porciones': instance.cantidadPorciones,
      'precio_acordado_mxn': instance.precioAcordadoMxn,
      'receta_id': instance.recetaId,
      'id': instance.id,
      'pedido_id': instance.pedidoId,
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

MovimientoResponse _$MovimientoResponseFromJson(Map<String, dynamic> json) =>
    MovimientoResponse(
      id: json['id'] as String,
      insumoId: json['insumo_id'] as String,
      usuarioId: json['usuario_id'] as String,
      tipo: json['tipo'] as String,
      cantidad: json['cantidad'] as String,
      motivo: json['motivo'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
    );

Map<String, dynamic> _$MovimientoResponseToJson(MovimientoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'insumo_id': instance.insumoId,
      'usuario_id': instance.usuarioId,
      'tipo': instance.tipo,
      'cantidad': instance.cantidad,
      'motivo': instance.motivo,
      'fecha': instance.fecha.toIso8601String(),
    };

NotificacionRead _$NotificacionReadFromJson(Map<String, dynamic> json) =>
    NotificacionRead(
      tipo: json['tipo'] as String,
      fechaProgramada: DateTime.parse(json['fecha_programada'] as String),
      pedidoId: json['pedido_id'],
      insumoId: json['insumo_id'],
      id: json['id'] as String,
      enviada: json['enviada'] as bool,
      fechaEnvio: json['fecha_envio'],
    );

Map<String, dynamic> _$NotificacionReadToJson(NotificacionRead instance) =>
    <String, dynamic>{
      'tipo': instance.tipo,
      'fecha_programada': instance.fechaProgramada.toIso8601String(),
      'pedido_id': instance.pedidoId,
      'insumo_id': instance.insumoId,
      'id': instance.id,
      'enviada': instance.enviada,
      'fecha_envio': instance.fechaEnvio,
    };

PasoCreate _$PasoCreateFromJson(Map<String, dynamic> json) => PasoCreate(
      orden: (json['orden'] as num).toInt(),
      descripcion: json['descripcion'] as String,
      duracion: json['duracion'],
      unidad: json['unidad'],
      duracionSegundos: json['duracion_segundos'],
      esCritico: json['es_critico'] as bool? ?? false,
    );

Map<String, dynamic> _$PasoCreateToJson(PasoCreate instance) =>
    <String, dynamic>{
      'orden': instance.orden,
      'descripcion': instance.descripcion,
      'duracion': instance.duracion,
      'unidad': instance.unidad,
      'duracion_segundos': instance.duracionSegundos,
      'es_critico': instance.esCritico,
    };

PasoResponse _$PasoResponseFromJson(Map<String, dynamic> json) => PasoResponse(
      orden: (json['orden'] as num).toInt(),
      descripcion: json['descripcion'] as String,
      duracion: json['duracion'],
      unidad: json['unidad'],
      duracionSegundos: json['duracion_segundos'],
      esCritico: json['es_critico'] as bool? ?? false,
      id: json['id'] as String,
    );

Map<String, dynamic> _$PasoResponseToJson(PasoResponse instance) =>
    <String, dynamic>{
      'orden': instance.orden,
      'descripcion': instance.descripcion,
      'duracion': instance.duracion,
      'unidad': instance.unidad,
      'duracion_segundos': instance.duracionSegundos,
      'es_critico': instance.esCritico,
      'id': instance.id,
    };

PedidoCreate _$PedidoCreateFromJson(Map<String, dynamic> json) => PedidoCreate(
      clienteNombre: json['cliente_nombre'] as String,
      clienteWhatsapp: json['cliente_whatsapp'],
      fechaEntrega: DateTime.parse(json['fecha_entrega'] as String),
      puntoEntrega: json['punto_entrega'],
      puntoEntregaId: json['punto_entrega_id'],
      notas: json['notas'],
      lineas: (json['lineas'] as List<dynamic>?)
              ?.map(
                  (e) => LineaPedidoCreate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PedidoCreateToJson(PedidoCreate instance) =>
    <String, dynamic>{
      'cliente_nombre': instance.clienteNombre,
      'cliente_whatsapp': instance.clienteWhatsapp,
      'fecha_entrega': instance.fechaEntrega.toIso8601String(),
      'punto_entrega': instance.puntoEntrega,
      'punto_entrega_id': instance.puntoEntregaId,
      'notas': instance.notas,
      'lineas': instance.lineas.map((e) => e.toJson()).toList(),
    };

PedidoResponse _$PedidoResponseFromJson(Map<String, dynamic> json) =>
    PedidoResponse(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      clienteNombre: json['cliente_nombre'] as String,
      clienteWhatsapp: json['cliente_whatsapp'],
      fechaEntrega: DateTime.parse(json['fecha_entrega'] as String),
      puntoEntrega: json['punto_entrega'],
      estado: json['estado'] as String,
      notas: json['notas'],
      lineas: (json['lineas'] as List<dynamic>?)
              ?.map((e) =>
                  LineaPedidoResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      whatsappUrl: json['whatsapp_url'],
      puntoEntregaDisplay: json['punto_entrega_display'],
      puntoEntregaDireccion: json['punto_entrega_direccion'],
    );

Map<String, dynamic> _$PedidoResponseToJson(PedidoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'cliente_nombre': instance.clienteNombre,
      'cliente_whatsapp': instance.clienteWhatsapp,
      'fecha_entrega': instance.fechaEntrega.toIso8601String(),
      'punto_entrega': instance.puntoEntrega,
      'estado': instance.estado,
      'notas': instance.notas,
      'lineas': instance.lineas.map((e) => e.toJson()).toList(),
      'whatsapp_url': instance.whatsappUrl,
      'punto_entrega_display': instance.puntoEntregaDisplay,
      'punto_entrega_direccion': instance.puntoEntregaDireccion,
    };

PedidoUpdate _$PedidoUpdateFromJson(Map<String, dynamic> json) => PedidoUpdate(
      clienteNombre: json['cliente_nombre'],
      clienteWhatsapp: json['cliente_whatsapp'],
      fechaEntrega: json['fecha_entrega'],
      puntoEntrega: json['punto_entrega'],
      puntoEntregaId: json['punto_entrega_id'],
      notas: json['notas'],
      lineas: json['lineas'],
    );

Map<String, dynamic> _$PedidoUpdateToJson(PedidoUpdate instance) =>
    <String, dynamic>{
      'cliente_nombre': instance.clienteNombre,
      'cliente_whatsapp': instance.clienteWhatsapp,
      'fecha_entrega': instance.fechaEntrega,
      'punto_entrega': instance.puntoEntrega,
      'punto_entrega_id': instance.puntoEntregaId,
      'notas': instance.notas,
      'lineas': instance.lineas,
    };

PuntoEntregaCreate _$PuntoEntregaCreateFromJson(Map<String, dynamic> json) =>
    PuntoEntregaCreate(
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'],
      direccion: json['direccion'],
    );

Map<String, dynamic> _$PuntoEntregaCreateToJson(PuntoEntregaCreate instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'direccion': instance.direccion,
    };

PuntoEntregaPatch _$PuntoEntregaPatchFromJson(Map<String, dynamic> json) =>
    PuntoEntregaPatch(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      direccion: json['direccion'],
    );

Map<String, dynamic> _$PuntoEntregaPatchToJson(PuntoEntregaPatch instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'direccion': instance.direccion,
    };

PuntoEntregaRead _$PuntoEntregaReadFromJson(Map<String, dynamic> json) =>
    PuntoEntregaRead(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'],
      direccion: json['direccion'],
      fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
      fechaModificacion: json['fecha_modificacion'],
    );

Map<String, dynamic> _$PuntoEntregaReadToJson(PuntoEntregaRead instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'direccion': instance.direccion,
      'fecha_creacion': instance.fechaCreacion.toIso8601String(),
      'fecha_modificacion': instance.fechaModificacion,
    };

PuntoEntregaUpdate _$PuntoEntregaUpdateFromJson(Map<String, dynamic> json) =>
    PuntoEntregaUpdate(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      direccion: json['direccion'],
    );

Map<String, dynamic> _$PuntoEntregaUpdateToJson(PuntoEntregaUpdate instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'direccion': instance.direccion,
    };

RecetaCreate _$RecetaCreateFromJson(Map<String, dynamic> json) => RecetaCreate(
      nombre: json['nombre'] as String,
      porciones: (json['porciones'] as num).toInt(),
      margenPct: json['margen_pct'],
      ingredientes: (json['ingredientes'] as List<dynamic>?)
              ?.map(
                  (e) => IngredienteCreate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pasos: (json['pasos'] as List<dynamic>?)
              ?.map((e) => PasoCreate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RecetaCreateToJson(RecetaCreate instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'porciones': instance.porciones,
      'margen_pct': instance.margenPct,
      'ingredientes': instance.ingredientes.map((e) => e.toJson()).toList(),
      'pasos': instance.pasos?.map((e) => e.toJson()).toList(),
    };

RecetaResponse _$RecetaResponseFromJson(Map<String, dynamic> json) =>
    RecetaResponse(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      nombre: json['nombre'] as String,
      porciones: (json['porciones'] as num).toInt(),
      margenPct: json['margen_pct'] as String,
      activa: json['activa'] as bool,
      ingredientes: (json['ingredientes'] as List<dynamic>?)
              ?.map((e) =>
                  IngredienteResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pasos: (json['pasos'] as List<dynamic>?)
              ?.map((e) => PasoResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      gastosOcultos: (json['gastos_ocultos'] as List<dynamic>?)
              ?.map((e) =>
                  GastoOcultoResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      costoPorPorcion: json['costo_por_porcion'],
      precioSugerido: json['precio_sugerido'],
    );

Map<String, dynamic> _$RecetaResponseToJson(RecetaResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'usuario_id': instance.usuarioId,
      'nombre': instance.nombre,
      'porciones': instance.porciones,
      'margen_pct': instance.margenPct,
      'activa': instance.activa,
      'ingredientes': instance.ingredientes.map((e) => e.toJson()).toList(),
      'pasos': instance.pasos.map((e) => e.toJson()).toList(),
      'gastos_ocultos': instance.gastosOcultos.map((e) => e.toJson()).toList(),
      'costo_por_porcion': instance.costoPorPorcion,
      'precio_sugerido': instance.precioSugerido,
    };

RecetaUpdate _$RecetaUpdateFromJson(Map<String, dynamic> json) => RecetaUpdate(
      nombre: json['nombre'],
      porciones: json['porciones'],
      margenPct: json['margen_pct'],
      ingredientes: json['ingredientes'],
      pasos: json['pasos'],
    );

Map<String, dynamic> _$RecetaUpdateToJson(RecetaUpdate instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'porciones': instance.porciones,
      'margen_pct': instance.margenPct,
      'ingredientes': instance.ingredientes,
      'pasos': instance.pasos,
    };

TemporizadorCreate _$TemporizadorCreateFromJson(Map<String, dynamic> json) =>
    TemporizadorCreate(
      pasoRecetaId: json['paso_receta_id'] as String,
      duracionSegundos: (json['duracion_segundos'] as num).toInt(),
    );

Map<String, dynamic> _$TemporizadorCreateToJson(TemporizadorCreate instance) =>
    <String, dynamic>{
      'paso_receta_id': instance.pasoRecetaId,
      'duracion_segundos': instance.duracionSegundos,
    };

TemporizadorResponse _$TemporizadorResponseFromJson(
        Map<String, dynamic> json) =>
    TemporizadorResponse(
      id: json['id'] as String,
      pasoRecetaId: json['paso_receta_id'] as String,
      usuarioId: json['usuario_id'] as String,
      duracionSegundos: (json['duracion_segundos'] as num).toInt(),
      estado: json['estado'] as String,
      fechaInicio: json['fecha_inicio'],
      fechaConfirmacion: json['fecha_confirmacion'],
    );

Map<String, dynamic> _$TemporizadorResponseToJson(
        TemporizadorResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'paso_receta_id': instance.pasoRecetaId,
      'usuario_id': instance.usuarioId,
      'duracion_segundos': instance.duracionSegundos,
      'estado': instance.estado,
      'fecha_inicio': instance.fechaInicio,
      'fecha_confirmacion': instance.fechaConfirmacion,
    };

ToggleGastoRequest _$ToggleGastoRequestFromJson(Map<String, dynamic> json) =>
    ToggleGastoRequest(
      activo: json['activo'] as bool,
    );

Map<String, dynamic> _$ToggleGastoRequestToJson(ToggleGastoRequest instance) =>
    <String, dynamic>{
      'activo': instance.activo,
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
    );

Map<String, dynamic> _$ValidationErrorToJson(ValidationError instance) =>
    <String, dynamic>{
      'loc': instance.loc,
      'msg': instance.msg,
      'type': instance.type,
    };
