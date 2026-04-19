import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum GastoOcultoCreateTipo {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('empaque')
  empaque('empaque'),
  @JsonValue('gas_luz')
  gasLuz('gas_luz');

  final String? value;

  const GastoOcultoCreateTipo(this.value);
}

enum GastoOcultoResponseTipo {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('empaque')
  empaque('empaque'),
  @JsonValue('gas_luz')
  gasLuz('gas_luz');

  final String? value;

  const GastoOcultoResponseTipo(this.value);
}

enum InsumoCreateUnidad {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('kg')
  kg('kg'),
  @JsonValue('g')
  g('g'),
  @JsonValue('l')
  l('l'),
  @JsonValue('ml')
  ml('ml'),
  @JsonValue('pz')
  pz('pz'),
  @JsonValue('caja')
  caja('caja'),
  @JsonValue('taza')
  taza('taza');

  final String? value;

  const InsumoCreateUnidad(this.value);
}

enum InsumoResponseUnidad {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('kg')
  kg('kg'),
  @JsonValue('g')
  g('g'),
  @JsonValue('l')
  l('l'),
  @JsonValue('ml')
  ml('ml'),
  @JsonValue('pz')
  pz('pz'),
  @JsonValue('caja')
  caja('caja'),
  @JsonValue('taza')
  taza('taza');

  final String? value;

  const InsumoResponseUnidad(this.value);
}

enum MovimientoCreateTipo {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('entrada')
  entrada('entrada'),
  @JsonValue('salida')
  salida('salida');

  final String? value;

  const MovimientoCreateTipo(this.value);
}

enum MovimientoCreateMotivo {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('compra')
  compra('compra'),
  @JsonValue('uso_produccion')
  usoProduccion('uso_produccion'),
  @JsonValue('merma')
  merma('merma');

  final String? value;

  const MovimientoCreateMotivo(this.value);
}

enum ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('empaque')
  empaque('empaque'),
  @JsonValue('gas_luz')
  gasLuz('gas_luz');

  final String? value;

  const ApiV1RecetasIdGastosOcultosTipoTogglePatchTipo(this.value);
}
