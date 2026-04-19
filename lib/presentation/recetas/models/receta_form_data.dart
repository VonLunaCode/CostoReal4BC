import '../../../data/api_generated/openapi.models.swagger.dart';

class IngredienteFormData {
  InsumoResponse? insumo;
  String cantidad = '0';
  String unidad = 'pz';

  IngredienteFormData({this.insumo, this.cantidad = '0', this.unidad = 'pz'});
}

class PasoFormData {
  String descripcion = '';
  int? duracionSegundos;
  bool esCritico = false;

  PasoFormData({this.descripcion = '', this.duracionSegundos, this.esCritico = false});
}
