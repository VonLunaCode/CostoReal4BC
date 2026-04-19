import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MargenSliderWidget extends StatefulWidget {
  final double margen;
  final double costoPorPorcion;
  final ValueChanged<double> onChanged;

  const MargenSliderWidget({
    super.key,
    required this.margen,
    required this.costoPorPorcion,
    required this.onChanged,
  });

  @override
  State<MargenSliderWidget> createState() => _MargenSliderWidgetState();
}

class _MargenSliderWidgetState extends State<MargenSliderWidget> {
  late TextEditingController _precioManualController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final initialPrice = widget.costoPorPorcion * (1 + widget.margen / 100);
    _precioManualController = TextEditingController(text: initialPrice.toStringAsFixed(2));
  }

  @override
  void didUpdateWidget(covariant MargenSliderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus) {
      if (oldWidget.margen != widget.margen || oldWidget.costoPorPorcion != widget.costoPorPorcion) {
        final newPrice = widget.costoPorPorcion * (1 + widget.margen / 100);
        _precioManualController.text = newPrice.toStringAsFixed(2);
      }
    }
  }

  @override
  void dispose() {
    _precioManualController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onManualPriceChanged(String val) {
    if (widget.costoPorPorcion <= 0) return;
    final price = double.tryParse(val);
    if (price == null) return;
    
    final newMargin = ((price / widget.costoPorPorcion) - 1) * 100;
    widget.onChanged(newMargin);
  }

  @override
  Widget build(BuildContext context) {
    final double precioManual = double.tryParse(_precioManualController.text) ?? (widget.costoPorPorcion * (1 + widget.margen / 100));
    final double gananciaNeta = precioManual - widget.costoPorPorcion;
    final bool esPerdida = precioManual < widget.costoPorPorcion && widget.costoPorPorcion > 0;
    
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: esPerdida ? Colors.red.shade200 : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MARGEN DE GANANCIA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Color(0xFF718096),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFBC985D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.margen.toInt()}%',
                  style: const TextStyle(
                    color: Color(0xFFBC985D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Slider + marcas sin overflow
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFBC985D),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFFBC985D),
              overlayColor: const Color(0xFFBC985D).withOpacity(0.2),
            ),
            child: Slider(
              value: widget.margen.clamp(0.0, 200.0),
              min: 0,
              max: 200,
              divisions: 200,
              onChanged: (val) {
                _focusNode.unfocus();
                widget.onChanged(val);
              },
            ),
          ),
          // Marcas de referencia debajo del slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTickLabel('30%'),
                _buildTickLabel('50%'),
                _buildTickLabel('100%'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  label: 'Ganancia neta',
                  value: '${formatter.format(gananciaNeta)} /porcion',
                  color: esPerdida ? Colors.red : const Color(0xFF2D3748),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Precio final (Manual)', style: TextStyle(fontSize: 12, color: Color(0xFF718096))),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 36,
                      child: TextField(
                        controller: _precioManualController,
                        focusNode: _focusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: _onManualPriceChanged,
                        decoration: InputDecoration(
                          prefixText: r'$ ',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: esPerdida ? Colors.red : const Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFBC985D), width: 2),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: esPerdida ? Colors.red : const Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (esPerdida)
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '⚠️ Precio de venta a pérdida — revisa tu costeo',
                      style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTickLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFFA0AEC0)));
  }

  Widget _infoItem({required String label, required String value, required Color color, bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF718096))),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
