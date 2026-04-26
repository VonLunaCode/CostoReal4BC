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
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Margen de Ganancia Deseado',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4035),
              ),
            ),
            Text(
              '${widget.margen.toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7A613E),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Slider + marcas sin overflow
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF7A613E),
            inactiveTrackColor: const Color(0xFFEBE6D9),
            thumbColor: const Color(0xFF7A613E),
            overlayColor: const Color(0xFF7A613E).withOpacity(0.2),
            trackHeight: 2.0,
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
              _buildTickLabel('0%'),
              _buildTickLabel('100%'),
              _buildTickLabel('200%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTickLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFFA0AEC0)));
  }
}
