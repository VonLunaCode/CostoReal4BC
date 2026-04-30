import '../../../data/api_generated/openapi.models.swagger.dart';

class IngredienteFormData {
  InsumoResponse? insumo;
  String cantidad = '0';
  String unidad = 'pz';
  String unidadInput = 'pz'; // Sub-unidad seleccionada por el usuario en UI

  IngredienteFormData({this.insumo, this.cantidad = '0', this.unidad = 'pz', this.unidadInput = 'pz'});
}

class PasoFormData {
  String descripcion = '';
  int? duracionSegundos;
  bool esCritico = false;

  PasoFormData({this.descripcion = '', this.duracionSegundos, this.esCritico = false});
}
