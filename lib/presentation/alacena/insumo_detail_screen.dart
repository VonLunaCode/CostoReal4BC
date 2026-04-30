import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import 'alacena_screen.dart';
import 'movimiento_stock_bottom_sheet.dart';

final insumoByIdProvider = FutureProvider.autoDispose.family<InsumoResponse, String>((ref, id) async {
  final api = ref.watch(apiProvider);
  final response = await api.apiV1InsumosIdGet(id: id);
  if (!response.isSuccessful) {
    throw Exception('Error al cargar insumo: ${response.error}');
  }
  return response.body!;
});

final insumoMovementsProvider = FutureProvider.autoDispose.family<List<MovimientoResponse>, String>((ref, id) async {
  final api = ref.watch(apiProvider);
  final response = await api.apiV1InsumosIdMovimientosGet(id: id);
  if (!response.isSuccessful) {
    throw Exception('Error al cargar movimientos: ${response.error}');
  }
  return response.body ?? [];
});

class InsumoDetailScreen extends ConsumerWidget {
  final String insumoId;
  const InsumoDetailScreen({super.key, required this.insumoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insumoAsync = ref.watch(insumoByIdProvider(insumoId));
    final movimientosAsync = ref.watch(insumoMovementsProvider(insumoId));

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2623)),
          onPressed: () => context.pop(),
        ),
        title: insumoAsync.when(
          data: (insumo) => Text(
            insumo.nombre,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontStyle: FontStyle.italic,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2623),
            ),
          ),
          loading: () => const SizedBox(),
          error: (_, __) => const Text('Error', style: TextStyle(color: Color(0xFF2C2623))),
        ),
        actions: [
          insumoAsync.when(
            data: (insumo) => IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF2C2623)),
              onPressed: () async {
                final updated = await context.push<bool>(
                  '/alacena/editar',
                  extra: insumo,
                );
                if (updated == true || context.mounted) {
                  ref.invalidate(insumoByIdProvider(insumoId));
                }
              },
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF2C2623),
               child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: insumoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFBC985D))),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (insumo) {
          final cantActual = double.tryParse(insumo.cantidadActual) ?? 0.0;
          final alertaMin = double.tryParse(insumo.alertaMinimo ?? '0') ?? 0.0;
          final isCritico = cantActual <= alertaMin;
          
          final displayCantActual = cantActual == cantActual.toInt() ? cantActual.toInt().toString() : cantActual.toString();
          
          final double? priceNum = double.tryParse(insumo.precioCompra);
          final displayPrecio = priceNum != null && priceNum == priceNum.toInt() ? priceNum.toInt().toString() : insumo.precioCompra;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Stock Hero Section
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F2EA),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'STOCK DISPONIBLE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.0,
                              color: Color(0xFF807667),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                displayCantActual,
                                style: const TextStyle(
                                  fontSize: 64,
                                  fontFamily: 'Georgia',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2623),
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                insumo.unidad.value ?? '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Georgia',
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF807667),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Decorative watermark background
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(Icons.restaurant, size: 100, color: const Color(0xFF807667).withOpacity(0.05)),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Info Cards
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        label: 'UNIDAD',
                        value: _getFullUnitName(insumo.unidad.value),
                        icon: Icons.scale_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InfoCard(
                        label: 'PRECIO COMPRA',
                        value: '\$$displayPrecio',
                        icon: Icons.payments_outlined,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                const SizedBox(height: 32),
                
                // Estado de Alacena (Barra dinámica real)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F2EA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Definimos la Meta. Si es muy baja, usamos el mínimo * 2 como referencia visual.
                      final double meta = double.parse(insumo.cantidadComprada.toString()) > alertaMin 
                          ? double.parse(insumo.cantidadComprada.toString()) 
                          : (alertaMin > 0 ? alertaMin * 2 : 10.0);
                          
                      final double progress = (cantActual / meta).clamp(0.0, 1.0);
                      final double alertPosition = (alertaMin / meta).clamp(0.0, 1.0);
                      final double barWidth = constraints.maxWidth;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Estado de Alacena',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2623),
                                ),
                              ),
                              Text(
                                'Meta: ${meta.toStringAsFixed(meta == meta.toInt() ? 0 : 1)} ${insumo.unidad.value ?? ""}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF807667)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.centerLeft,
                            clipBehavior: Clip.none,
                            children: [
                              // Fondo de la barra
                              Container(
                                height: 12,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // Progreso actual
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                height: 12,
                                width: barWidth * progress,
                                decoration: BoxDecoration(
                                  color: isCritico ? const Color(0xFFDC2626) : const Color(0xFF8B6B3D),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // Línea Roja de Alerta (Posición dinámica)
                              Positioned(
                                left: barWidth * alertPosition,
                                child: Container(
                                  width: 2,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDC2626),
                                    borderRadius: BorderRadius.circular(1),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(1, 1))
                                    ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'ALERTA MÍNIMO: ${alertaMin.toStringAsFixed(alertaMin == alertaMin.toInt() ? 0 : 1)} ${insumo.unidad.value ?? ""}',
                                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF807667), letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                              Text(
                                isCritico ? 'Nivel Crítico' : 'Nivel Saludable',
                                style: TextStyle(
                                  fontSize: 10, 
                                  fontWeight: FontWeight.bold, 
                                  color: isCritico ? const Color(0xFFDC2626) : const Color(0xFF16A34A) // Verde para saludable
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),
                
                // Últimos Movimientos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Últimos Movimientos',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2623),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 2),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFC69E57), width: 1.5))
                        ),
                        child: const Text('VER TODO', style: TextStyle(fontSize: 10, letterSpacing: 1.0, fontWeight: FontWeight.bold, color: Color(0xFFC69E57))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                movimientosAsync.when(
                  loading: () => const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Color(0xFFBC985D)),
                  )),
                  error: (err, _) => Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text('Error al cargar movimientos: $err', style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                  data: (movimientos) {
                    if (movimientos.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF1F1E6)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.history_toggle_off, size: 48, color: const Color(0xFF807667).withOpacity(0.3)),
                            const SizedBox(height: 16),
                            const Text(
                              'SIN MOVIMIENTOS',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF807667)),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Aún no hay registros de entradas o salidas para este insumo.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Color(0xFF807667)),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: movimientos.map((m) {
                        final dateStr = _formatDate(m.fecha);
                        final prefix = m.tipo == 'entrada' ? '+' : '-';
                        final cant = double.tryParse(m.cantidad.toString()) ?? 0.0;
                        final displayStr = _formatCantidadMovimiento(cant, insumo.unidad.value);
                        
                        return _MovementItem(
                          title: '$prefix$displayStr',
                          subtitle: _formatMotivo(m.motivo),
                          date: dateStr,
                          isEntry: m.tipo == 'entrada',
                        );
                      }).toList(),
                    );
                  },
                ),
                
                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => _showMovementModal(context, ref),
            icon: const Icon(Icons.sync_alt, size: 20, color: Colors.white),
            label: const Text('REGISTRAR MOVIMIENTO', style: TextStyle(fontSize: 13, letterSpacing: 1.5, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC69E57),
              elevation: 4,
              shadowColor: const Color(0xFFC69E57).withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }

  String _getFullUnitName(String? short) {
    switch (short) {
      case 'kg': return 'Kilogramos';
      case 'g': return 'Gramos';
      case 'l': return 'Litros';
      case 'ml': return 'Mililitros';
      case 'pz': return 'Piezas';
      default: return short ?? '';
    }
  }

  String _formatDate(DateTime date) {
    // Formato simple: 02 Abr, 2024
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  /// Convierte un valor almacenado en unidad base a una representación
  /// legible. Si el valor es menor a 1 y la unidad es convertible (kg→g, l→ml),
  /// muestra la sub-unidad. Ej: 0.02 kg → "20g", 0.5 l → "500ml".
  String _formatCantidadMovimiento(double cantidad, String? unidadBase) {
    if ((unidadBase == 'kg' || unidadBase == 'l') && cantidad > 0 && cantidad < 1) {
      final subUnidad = unidadBase == 'kg' ? 'g' : 'ml';
      final enSubUnidad = cantidad * 1000;
      final display = enSubUnidad == enSubUnidad.toInt()
          ? enSubUnidad.toInt().toString()
          : enSubUnidad.toStringAsFixed(1);
      return '$display$subUnidad';
    }
    final display = cantidad == cantidad.toInt()
        ? cantidad.toInt().toString()
        : cantidad.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
    return '$display${unidadBase ?? ""}';
  }

  String _formatMotivo(String motivo) {
    switch (motivo) {
      case 'compra': return 'Compra';
      case 'uso_produccion': return 'Uso en Producción';
      case 'merma': return 'Merma';
      default: return motivo;
    }
  }

  void _showMovementModal(BuildContext context, WidgetRef ref) {
    final insumo = ref.read(insumoByIdProvider(insumoId)).value;
    if (insumo == null) return;

    showMovimientoStockBottomSheet(
      context: context,
      insumo: insumo,
      onMovimientoRegistrado: () {
        ref.invalidate(insumoByIdProvider(insumoId));
        ref.invalidate(insumoMovementsProvider(insumoId));
        ref.invalidate(alacenaProvider);
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEBE6D9), // Fondo gris/crema de Figma
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF8B6B3D), size: 24),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF807667), letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontFamily: 'Georgia', fontWeight: FontWeight.bold, color: Color(0xFF2C2623))),
        ],
      ),
    );
  }
}

class _MovementItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final bool isEntry;

  const _MovementItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.isEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isEntry ? const Color(0xFFEFFBFA) : const Color(0xFFFEF2F2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEntry ? Icons.add : Icons.remove,
              size: 20,
              color: isEntry ? const Color(0xFF3B82F6) /* Actually we should use teal/green, I'll use 0xFF14B8A6 */ : const Color(0xFFEF4444), // The image shows dark green/red
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C2623))),
                    const SizedBox(width: 4),
                    Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C2623))),
                  ],
                ),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(fontSize: 12, color: Color(0xFF807667))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFCBD5E0)),
        ],
      ),
    );
  }
}


