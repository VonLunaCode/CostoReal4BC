import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DonaChartWidget extends StatelessWidget {
  final double costoInsumos;
  final double costoEmpaque;
  final double costoEnergia;
  final double precioVenta; // Para mostrar en el centro de la dona

  const DonaChartWidget({
    super.key,
    required this.costoInsumos,
    required this.costoEmpaque,
    required this.costoEnergia,
    this.precioVenta = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasGastosOcultos = costoEmpaque > 0 || costoEnergia > 0;
    final double total = costoInsumos + costoEmpaque + costoEnergia;
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DESGLOSE DE COSTOS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 16),
          if (!hasGastosOcultos)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFFA0AEC0)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Activa gastos ocultos para ver el desglose de costos',
                      style: TextStyle(color: Color(0xFF718096), fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  // Dona con texto central
                  Expanded(
                    flex: 3,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50,
                            sections: _buildChartSections(total),
                          ),
                          swapAnimationDuration: const Duration(milliseconds: 300),
                        ),
                        // Texto central del Figma
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'VENTA FINAL',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Color(0xFF718096),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              formatter.format(precioVenta).replaceAll('.00', ''),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Leyenda
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (costoInsumos > 0)
                          _buildLegendItem('Insumos', const Color(0xFFB8872A)),
                        if (costoInsumos > 0) const SizedBox(height: 10),
                        if (costoEmpaque > 0)
                          _buildLegendItem('Empaque', const Color(0xFF2D8A52)),
                        if (costoEmpaque > 0) const SizedBox(height: 10),
                        if (costoEnergia > 0)
                          _buildLegendItem('Gas/Luz', const Color(0xFF1A2B4A)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(double total) {
    if (total == 0) return [];
    final List<PieChartSectionData> sections = [];

    if (costoInsumos > 0) {
      sections.add(PieChartSectionData(
        color: const Color(0xFFB8872A),
        value: costoInsumos,
        title: '${((costoInsumos / total) * 100).toStringAsFixed(1)}%',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    if (costoEmpaque > 0) {
      sections.add(PieChartSectionData(
        color: const Color(0xFF2D8A52),
        value: costoEmpaque,
        title: '${((costoEmpaque / total) * 100).toStringAsFixed(1)}%',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    if (costoEnergia > 0) {
      sections.add(PieChartSectionData(
        color: const Color(0xFF1A2B4A),
        value: costoEnergia,
        title: '${((costoEnergia / total) * 100).toStringAsFixed(1)}%',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ));
    }

    return sections;
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4A5568))),
      ],
    );
  }
}
