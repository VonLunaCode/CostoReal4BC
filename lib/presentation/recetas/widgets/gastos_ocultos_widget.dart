import 'package:flutter/material.dart';

class GastosOcultosWidget extends StatefulWidget {
  final Function(bool empaqueActivo, double empaqueValor, bool gasLuzActivo,
      double gasLuzValor, bool gasLuzEsPorcentaje) onGastosChanged;

  // Valores iniciales opcionales (para pre-poblar)
  final bool initialEmpaqueActivo;
  final double initialEmpaqueValor;
  final bool initialGasLuzActivo;
  final double initialGasLuzPorcentaje;
  final bool initialGasLuzEsPorcentaje;

  const GastosOcultosWidget({
    super.key,
    required this.onGastosChanged,
    this.initialEmpaqueActivo = false,
    this.initialEmpaqueValor = 0.0,
    this.initialGasLuzActivo = false,
    this.initialGasLuzPorcentaje = 0.0,
    this.initialGasLuzEsPorcentaje = true,
  });

  @override
  State<GastosOcultosWidget> createState() => _GastosOcultosWidgetState();
}

class _GastosOcultosWidgetState extends State<GastosOcultosWidget> {
  late bool _empaqueActivo;
  late double _empaqueValor;
  late bool _gasLuzActivo;
  late double _gasLuzPorcentaje;
  late int _selectedGasLuzTab;

  final _empaqueController = TextEditingController();
  final _gasLuzController = TextEditingController();
  final _gasLuzMontoFijoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _empaqueActivo = widget.initialEmpaqueActivo;
    _empaqueValor = widget.initialEmpaqueValor;
    _gasLuzActivo = widget.initialGasLuzActivo;
    _gasLuzPorcentaje = widget.initialGasLuzPorcentaje;
    _selectedGasLuzTab = widget.initialGasLuzEsPorcentaje ? 0 : 1;

    _empaqueController.text = _empaqueValor > 0 ? _empaqueValor.toString() : '';
    final gasLuzTexto = _gasLuzPorcentaje > 0 ? _gasLuzPorcentaje.toString() : '';
    _gasLuzController.text = gasLuzTexto;
    _gasLuzMontoFijoController.text = _selectedGasLuzTab == 1 ? gasLuzTexto : '';
  }

  @override
  void didUpdateWidget(GastosOcultosWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialEmpaqueValor != widget.initialEmpaqueValor) {
      _empaqueValor = widget.initialEmpaqueValor;
      _empaqueController.text =
          widget.initialEmpaqueValor > 0 ? widget.initialEmpaqueValor.toString() : '';
    }
    if (oldWidget.initialGasLuzEsPorcentaje != widget.initialGasLuzEsPorcentaje) {
      _selectedGasLuzTab = widget.initialGasLuzEsPorcentaje ? 0 : 1;
    }
    if (oldWidget.initialGasLuzPorcentaje != widget.initialGasLuzPorcentaje) {
      _gasLuzPorcentaje = widget.initialGasLuzPorcentaje;
      _gasLuzController.text = widget.initialGasLuzPorcentaje > 0
          ? widget.initialGasLuzPorcentaje.toString()
          : '';
      _gasLuzMontoFijoController.text = widget.initialGasLuzPorcentaje > 0
          ? widget.initialGasLuzPorcentaje.toString()
          : '';
    }
  }

  @override
  void dispose() {
    _empaqueController.dispose();
    _gasLuzController.dispose();
    _gasLuzMontoFijoController.dispose();
    super.dispose();
  }

  void _notifyChanges() {
    widget.onGastosChanged(
      _empaqueActivo,
      _empaqueValor,
      _gasLuzActivo,
      _gasLuzPorcentaje,
      _selectedGasLuzTab == 0,
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
            const Text('Incluir Empaque',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF4A4035))),
            Switch(
              value: _empaqueActivo,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF7A613E),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD5D1C6),
              onChanged: (val) {
                setState(() {
                  _empaqueActivo = val;
                  if (val && _empaqueValor == 0.0) {
                    _empaqueValor = 15.0;
                    _empaqueController.text = '15.0';
                  }
                });
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
                    const Text('Costo del empaque:',
                        style:
                            TextStyle(fontSize: 11, color: Color(0xFF4A4035))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEBE6D9),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text('VALORES SUGERIDOS',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A613E),
                              letterSpacing: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: _empaqueController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xFF2C2623)),
                    decoration: InputDecoration(
                      prefixText: r'$ ',
                      prefixStyle: const TextStyle(
                          fontSize: 14, color: Color(0xFF4A4035)),
                      fillColor: const Color(0xFFEBE6D9),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
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
            const Text('Incluir Energías',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF4A4035))),
            Switch(
              value: _gasLuzActivo,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF7A613E),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD5D1C6),
              onChanged: (val) {
                setState(() {
                  _gasLuzActivo = val;
                  if (val && _gasLuzPorcentaje == 0.0) {
                    _gasLuzPorcentaje = 10.0;
                    _gasLuzController.text = '10';
                  }
                });
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
                  decoration: BoxDecoration(
                      color: const Color(0xFFEBE6D9),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedGasLuzTab = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: _selectedGasLuzTab == 0
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text('% Porcentaje',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: _selectedGasLuzTab == 0
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: _selectedGasLuzTab == 0
                                        ? const Color(0xFF2C2623)
                                        : const Color(0xFF807667))),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedGasLuzTab = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: _selectedGasLuzTab == 1
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: Text('\$ Monto Fijo',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: _selectedGasLuzTab == 1
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: _selectedGasLuzTab == 1
                                        ? const Color(0xFF2C2623)
                                        : const Color(0xFF807667))),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        _selectedGasLuzTab == 0 ? 'Porcentaje:' : 'Monto fijo:',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF4A4035))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEBE6D9),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Text('VALORES SUGERIDOS',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7A613E),
                              letterSpacing: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_selectedGasLuzTab == 0)
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      controller: _gasLuzController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF2C2623)),
                      decoration: InputDecoration(
                        fillColor: const Color(0xFFEBE6D9),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                      ),
                      onChanged: (val) {
                        double parsed = double.tryParse(val) ?? 0.0;
                        _gasLuzPorcentaje = parsed > 100 ? 100 : parsed;
                        _notifyChanges();
                      },
                    ),
                  )
                else
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      controller: _gasLuzMontoFijoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF2C2623)),
                      decoration: InputDecoration(
                        prefixText: r'$ ',
                        prefixStyle: const TextStyle(
                            fontSize: 14, color: Color(0xFF4A4035)),
                        fillColor: const Color(0xFFEBE6D9),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                      ),
                      onChanged: (val) {
                        _gasLuzPorcentaje = double.tryParse(val) ?? 0.0;
                        _notifyChanges();
                      },
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  _selectedGasLuzTab == 0
                      ? 'calculado sobre el costo de insumos'
                      : 'monto fijo agregado',
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF807667)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
