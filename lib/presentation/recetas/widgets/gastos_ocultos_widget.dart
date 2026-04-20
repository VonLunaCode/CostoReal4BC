import 'package:flutter/material.dart';

class GastosOcultosWidget extends StatefulWidget {
  final Function(bool empaqueActivo, double empaqueValor, bool gasLuzActivo, double gasLuzPorcentaje) onGastosChanged;
  
  // Valores iniciales opcionales (para pre-poblar)
  final bool initialEmpaqueActivo;
  final double initialEmpaqueValor;
  final bool initialGasLuzActivo;
  final double initialGasLuzPorcentaje;

  const GastosOcultosWidget({
    super.key,
    required this.onGastosChanged,
    this.initialEmpaqueActivo = false,
    this.initialEmpaqueValor = 0.0,
    this.initialGasLuzActivo = false,
    this.initialGasLuzPorcentaje = 0.0,
  });

  @override
  State<GastosOcultosWidget> createState() => _GastosOcultosWidgetState();
}

class _GastosOcultosWidgetState extends State<GastosOcultosWidget> {
  late bool _empaqueActivo;
  late double _empaqueValor;
  late bool _gasLuzActivo;
  late double _gasLuzPorcentaje;

  final _empaqueController = TextEditingController();
  final _gasLuzController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _empaqueActivo = widget.initialEmpaqueActivo;
    _empaqueValor = widget.initialEmpaqueValor;
    _gasLuzActivo = widget.initialGasLuzActivo;
    _gasLuzPorcentaje = widget.initialGasLuzPorcentaje;

    _empaqueController.text = _empaqueValor > 0 ? _empaqueValor.toString() : '';
    _gasLuzController.text = _gasLuzPorcentaje > 0 ? _gasLuzPorcentaje.toString() : '';
  }

  @override
  void dispose() {
    _empaqueController.dispose();
    _gasLuzController.dispose();
    super.dispose();
  }

  void _notifyChanges() {
    widget.onGastosChanged(
      _empaqueActivo,
      _empaqueValor,
      _gasLuzActivo,
      _gasLuzPorcentaje,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Incluir Empaque', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF4A4035))),
              Switch(
                value: _empaqueActivo,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF7A613E),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD5D1C6),
                onChanged: (val) {
                  setState(() => _empaqueActivo = val);
                  _notifyChanges();
                },
              ),
            ],
          ),
          if (_empaqueActivo)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Costo del empaque:', style: TextStyle(fontSize: 11, color: Color(0xFF4A4035))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFEBE6D9), borderRadius: BorderRadius.circular(12)),
                        child: const Text('VALORES SUGERIDOS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF7A613E), letterSpacing: 0.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      controller: _empaqueController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF2C2623)),
                      decoration: InputDecoration(
                        prefixText: r'$ ',
                        prefixStyle: const TextStyle(fontSize: 14, color: Color(0xFF4A4035)),
                        fillColor: const Color(0xFFEBE6D9),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                      onChanged: (val) {
                        _empaqueValor = double.tryParse(val) ?? 0.0;
                        _notifyChanges();
                      },
                    ),
                  ),
                ],
              ),
            ),

          const Divider(),

          // --- GAS Y LUZ ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Incluir Energías', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF4A4035))),
              Switch(
                value: _gasLuzActivo,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF7A613E),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD5D1C6),
                onChanged: (val) {
                  setState(() => _gasLuzActivo = val);
                  _notifyChanges();
                },
              ),
            ],
          ),
          if (_gasLuzActivo)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: const Color(0xFFEBE6D9), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                            alignment: Alignment.center,
                            child: const Text('% Porcentaje', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2C2623))),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            alignment: Alignment.center,
                            child: const Text('\$ Monto Fijo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF807667))),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Valor base:', style: TextStyle(fontSize: 11, color: Color(0xFF4A4035))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFEBE6D9), borderRadius: BorderRadius.circular(12)),
                        child: const Text('VALORES SUGERIDOS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF7A613E), letterSpacing: 0.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      controller: _gasLuzController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF2C2623)),
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFEBE6D9),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                      onChanged: (val) {
                        double parsed = double.tryParse(val) ?? 0.0;
                        _gasLuzPorcentaje = parsed > 100 ? 100 : parsed;
                        _notifyChanges();
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('calculado sobre el costo de insumos', style: TextStyle(fontSize: 10, color: Color(0xFF807667))),
                ],
              ),
            ),
        ],
      );
  }
}
