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
    final double total = precioVenta > 0 ? precioVenta : (costoInsumos + costoEmpaque + costoEnergia == 0 ? 1 : costoInsumos + costoEmpaque + costoEnergia);
    final double bruts = precioVenta > 0 ? (precioVenta - (costoInsumos + costoEmpaque + costoEnergia)) : 0;
    
    final double pInsumos = (costoInsumos / total) * 100;
    final double pEmpaque = (costoEmpaque / total) * 100;
    final double pEnergia = (costoEnergia / total) * 100;
    final double pBruta = (bruts > 0 ? bruts / total : 0) * 100;

    return Column(
      children: [
        const Text(
          'Distribución del Precio',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2623),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 60,
                  sections: _buildChartSections(pInsumos, pEmpaque, pEnergia, pBruta),
                ),
                swapAnimationDuration: const Duration(milliseconds: 300),
              ),
              const Text(
                '100%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2623),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Column(
          children: [
            _buildLegendItem('Insumos (Costo)', pInsumos, const Color(0xFF7A613E)),
            const SizedBox(height: 12),
            _buildLegendItem('Empaque', pEmpaque, const Color(0xFFD5D1C6)),
            const SizedBox(height: 12),
            _buildLegendItem('Energía', pEnergia, const Color(0xFFEBE6D9)),
            const SizedBox(height: 12),
            _buildLegendItem('Utilidad Bruta', pBruta, const Color(0xFF447A55)),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildChartSections(double pIns, double pEmp, double pEne, double pBru) {
    final List<PieChartSectionData> sections = [];
    if (pIns > 0) sections.add(_section(pIns, const Color(0xFF7A613E)));
    if (pEmp > 0) sections.add(_section(pEmp, const Color(0xFFD5D1C6)));
    if (pEne > 0) sections.add(_section(pEne, const Color(0xFFEBE6D9)));
    if (pBru > 0) sections.add(_section(pBru, const Color(0xFF447A55)));
    
    if (sections.isEmpty) {
      sections.add(_section(100, const Color(0xFFEBE6D9)));
    }
    return sections;
  }

  PieChartSectionData _section(double val, Color color) {
    return PieChartSectionData(
      color: color,
      value: val,
      title: '', // El diseño tiene el 100% en el centro, y no labels encima de la dona
      radius: 4,
    );
  }

  Widget _buildLegendItem(String label, double val, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF807667))),
          ],
        ),
        Text('${val.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2C2623))),
      ],
    );
  }
}
