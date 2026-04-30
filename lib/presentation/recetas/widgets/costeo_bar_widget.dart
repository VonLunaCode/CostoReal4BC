import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/api_generated/openapi.models.swagger.dart';
import '../models/receta_form_data.dart';

class CosteoBarWidget extends StatelessWidget {
  final List<IngredienteFormData> ingredientes;
  final int porciones;
  final List<InsumoResponse> insumosDisponibles;
  final double extraEmpaque;
  final double extraGasLuzPct;
  final VoidCallback onSave;
  final bool isSaving;

  const CosteoBarWidget({
    super.key,
    required this.ingredientes,
    required this.porciones,
    required this.insumosDisponibles,
    this.extraEmpaque = 0.0,
    this.extraGasLuzPct = 0.0,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Cálculo del costo total en Dart (Síncrono)
    double subtotalIngredientes = 0.0;

    for (var ing in ingredientes) {
      if (ing.insumo == null) continue;
      
      final insumo = ing.insumo!;
      
      final double precioCompra = double.tryParse(insumo.precioCompra.toString()) ?? 0.0;
      final double cantidadComprada = double.tryParse(insumo.cantidadComprada.toString()) ?? 1.0;
      
      if (cantidadComprada == 0) continue;
      
      final double precioUnitario = precioCompra / cantidadComprada;
      final double cantidadUsada = double.tryParse(ing.cantidad) ?? 0.0;
      
      subtotalIngredientes += precioUnitario * cantidadUsada;
    }

    double costoTotal = subtotalIngredientes;
    // Sumar empaque
    costoTotal += extraEmpaque;
    // Sumar Gas/Luz basado en subtotal de ingredientes
    costoTotal += (subtotalIngredientes * extraGasLuzPct / 100);

    final double costoPorPorcion = porciones > 0 ? costoTotal / porciones : 0.0;

    // 2. Formateo de moneda es_MX
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2B4A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COSTO TOTAL: ${formatter.format(costoTotal)} MXN',
                        style: const TextStyle(
                          color: Color(0xFFCBD5E0),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Por porción: ${formatter.format(costoPorPorcion)}',
                        style: const TextStyle(
                          color: Color(0xFF4ADE80), // Verde brillante para resaltar ahorro/costo
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: isSaving ? null : onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBC985D),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF718096),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Guardar',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
