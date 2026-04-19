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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GASTOS ADICIONALES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 12),
          
          // --- EMPAQUE ---
          SwitchListTile(
            title: const Text('Costo de Empaque', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Bolsas, cajas, etiquetas...', style: TextStyle(fontSize: 12)),
            value: _empaqueActivo,
            activeColor: const Color(0xFFBC985D),
            onChanged: (val) {
              setState(() => _empaqueActivo = val);
              _notifyChanges();
            },
            contentPadding: EdgeInsets.zero,
          ),
          if (_empaqueActivo)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _empaqueController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Monto fijo MXN',
                  prefixText: r'$ ',
                  hintText: '0.00',
                  fillColor: const Color(0xFFF7FAFC),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (val) {
                  _empaqueValor = double.tryParse(val) ?? 0.0;
                  _notifyChanges();
                },
              ),
            ),

          const Divider(),

          // --- GAS Y LUZ ---
          SwitchListTile(
            title: const Text('Gas y Luz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Estimado de energía utilizada', style: TextStyle(fontSize: 12)),
            value: _gasLuzActivo,
            activeColor: const Color(0xFFBC985D),
            onChanged: (val) {
              setState(() => _gasLuzActivo = val);
              _notifyChanges();
            },
            contentPadding: EdgeInsets.zero,
          ),
          if (_gasLuzActivo)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _gasLuzController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Porcentaje %',
                  suffixText: '%',
                  hintText: '0',
                  fillColor: const Color(0xFFF7FAFC),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (val) {
                  double parsed = double.tryParse(val) ?? 0.0;
                  _gasLuzPorcentaje = parsed > 100 ? 100 : parsed;
                  _notifyChanges();
                },
              ),
            ),

          // --- ADVERTENCIA ---
          if (!_empaqueActivo && !_gasLuzActivo)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Gastos ocultos no incluidos en el costeo',
                      style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
