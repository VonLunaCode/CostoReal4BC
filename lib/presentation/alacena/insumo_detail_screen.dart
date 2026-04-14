import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../data/api_generated/openapi.enums.swagger.dart';
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

class InsumoDetailScreen extends ConsumerWidget {
  final String insumoId;
  const InsumoDetailScreen({super.key, required this.insumoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insumoAsync = ref.watch(insumoByIdProvider(insumoId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7), // Tono crema muy sutil de Figma
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 40,
        title: insumoAsync.when(
          data: (insumo) => Text(
            insumo.nombre,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
          ),
          loading: () => const SizedBox(),
          error: (_, __) => const Text('Error'),
        ),
        actions: [
          insumoAsync.when(
            data: (insumo) => IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF718096)),
              onPressed: () => context.push('/alacena/editar', extra: insumo),
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE2E8F0),
              child: Icon(Icons.person, size: 20, color: Color(0xFF718096)),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Stock Hero Section (Sin círculo, estilo editorial)
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'STOCK DISPONIBLE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          color: Color(0xFFA0AEC0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            insumo.cantidadActual,
                            style: const TextStyle(
                              fontSize: 64,
                              fontFamily: 'serif',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            insumo.unidad.value ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Info Cards (Grisáceas de Figma)
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
                        value: '\$${insumo.precioCompra}',
                        icon: Icons.payments_outlined,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Estado de Alacena (Barra horizontal de Figma)
                const Text(
                  'Estado de Alacena',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: 'serif',
                    fontSize: 18,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF1F1F1)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                            'ALERTA MÍNIMO: ${alertaMin.toStringAsFixed(0)}KG',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                          ),
                          const Text(
                            'Nivel Saludable',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF9BBE86)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Stack(
                        children: [
                          Container(
                            height: 8,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: (cantActual / (alertaMin * 3)).clamp(0.0, 1.0),
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: isCritico ? const Color(0xFFDC2626) : const Color(0xFF7A613E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                
                // Últimos Movimientos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Últimos Movimientos',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('VER TODO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFBC985D))),
                    ),
                  ],
                ),
                const _MovementItem(
                  title: '+5kg Compra',
                  subtitle: '02 Abr, 2024',
                  isEntry: true,
                ),
                const _MovementItem(
                  title: '-2kg Receta Macarons',
                  subtitle: '01 Abr, 2024',
                  isEntry: false,
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
        child: ElevatedButton.icon(
          onPressed: () => _showMovementModal(context, ref),
          icon: const Icon(Icons.sync_alt, size: 20),
          label: const Text('REGISTRAR MOVIMIENTO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFBC985D),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  void _showMovementModal(BuildContext context, WidgetRef ref) {
    final insumo = ref.read(insumoByIdProvider(insumoId)).value;
    if (insumo == null) return;

    showMovimientoStockBottomSheet(
      context: context,
      insumo: insumo,
      onMovimientoRegistrado: () {
        ref.invalidate(insumoByIdProvider(insumoId));
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
        color: const Color(0xFFF1F1F1), // Fondo gris de Figma
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF7A613E), size: 18),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFA0AEC0), letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A))),
        ],
      ),
    );
  }
}

class _MovementItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isEntry;

  const _MovementItem({required this.title, required this.subtitle, required this.isEntry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F1F1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isEntry ? const Color(0xFFF0FFF4) : const Color(0xFFFFF5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEntry ? Icons.add : Icons.remove,
              size: 16,
              color: isEntry ? const Color(0xFF38A169) : const Color(0xFFDC2626),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A))),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFFA0AEC0))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFFCBD5E0)),
        ],
      ),
    );
  }
}


