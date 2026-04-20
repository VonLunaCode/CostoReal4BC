import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../widgets/kitchy_bottom_nav.dart';
import 'movimiento_stock_bottom_sheet.dart';

/// Provider que gestiona la lista de insumos desde el backend.
final alacenaProvider = FutureProvider.autoDispose<List<InsumoResponse>>((ref) async {
  final api = ref.watch(apiProvider);
  final response = await api.apiV1InsumosGet();
  if (!response.isSuccessful) {
    throw Exception('Error al cargar insumos: ${response.error}');
  }
  final list = response.body ?? [];
  // Ordenamiento inicial: Alfabético por nombre
  list.sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
  return list;
});

/// Provider para el filtro de búsqueda.
final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

class AlacenaScreen extends ConsumerWidget {
  const AlacenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insumosAsync = ref.watch(alacenaProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const Icon(Icons.restaurant_menu, color: Color(0xFFB8872A), size: 28),
            const SizedBox(width: 8),
            const Text(
              'Alacena',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontStyle: FontStyle.italic,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2623),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => context.push('/perfil'),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFE2E8F0),
                child: Icon(Icons.person, color: Color(0xFF718096)),
              ),
            ),
          ),
        ],
      ),
      body: insumosAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFBC985D)),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Color(0xFFDC2626)),
              const SizedBox(height: 16),
              Text('Error: $err', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(alacenaProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBC985D),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (insumos) {
          // Filtrado en memoria
          final filtered = insumos.where((i) {
            return i.nombre.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          // Lógica de Alertas y Clasificación
          final now = DateTime.now();
          
          final criticos = filtered.where((i) {
            final cantActual = double.tryParse(i.cantidadActual) ?? 0.0;
            final alertaMin = double.tryParse(i.alertaMinimo ?? '0') ?? 0.0;
            return cantActual <= alertaMin;
          }).toList();

          final desactualizados = filtered.where((i) {
            final diff = now.difference(i.fechaUltimoPrecio).inDays;
            return diff > 30 && !criticos.contains(i);
          }).toList();

          final regulares = filtered.where((i) {
            return !criticos.contains(i) && !desactualizados.contains(i);
          }).toList();

          return RefreshIndicator(
            onRefresh: () => ref.refresh(alacenaProvider.future),
            color: const Color(0xFFBC985D),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 8),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE6D9), // Light grayish-beige from design
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
                    decoration: InputDecoration(
                      hintText: 'Buscar insumos...',
                      hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF9E9E9E)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                if (criticos.isNotEmpty || desactualizados.isNotEmpty) ...[
                  const _SectionHeader(title: 'ATENCIÓN NECESARIA', color: Color(0xFF718096)),
                  const SizedBox(height: 12),
                  ...criticos.map((i) => _InsumoCard(insumo: i, type: _CardType.critical)),
                  ...desactualizados.map((i) => _InsumoCard(insumo: i, type: _CardType.warning)),
                  const SizedBox(height: 24),
                ],

                const _SectionHeader(title: 'INSUMOS EN ALACENA', color: Color(0xFF718096)),
                const SizedBox(height: 12),
                if (regulares.isEmpty && criticos.isEmpty && desactualizados.isEmpty)
                   const Padding(
                     padding: EdgeInsets.symmetric(vertical: 40),
                     child: Text('No se encontraron insumos', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                   ),
                ...regulares.map((i) => _InsumoCard(insumo: i, type: _CardType.normal)),
                const SizedBox(height: 100), // Espacio para el FAB
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/alacena/crear'),
        backgroundColor: const Color(0xFFC29F5C),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      extendBody: true,
      bottomNavigationBar: const KitchyBottomNav(currentIndex: 2),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (title.contains('NECESARIA')) ...[
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFDC2626),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

enum _CardType { critical, warning, normal }

class _InsumoCard extends ConsumerWidget {
  final InsumoResponse insumo;
  final _CardType type;

  const _InsumoCard({required this.insumo, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A4A4A).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/alacena/${insumo.id}'),
          onLongPress: () => showMovimientoStockBottomSheet(
            context: context,
            insumo: insumo,
            onMovimientoRegistrado: () => ref.invalidate(alacenaProvider),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type == _CardType.critical || type == _CardType.warning) ...[
                  if (type == _CardType.critical)
                    const _AlertBadge(
                      label: 'STOCK BAJO',
                      icon: Icons.inventory_2_outlined,
                      color: Color(0xFFDC2626),
                      bgColor: Color(0xFFFDE8E8),
                    ),
                  if (type == _CardType.warning)
                    const _AlertBadge(
                      label: 'PRECIO DESACTUALIZADO',
                      icon: Icons.warning_amber_rounded,
                      color: Color(0xFFD97706),
                      bgColor: Color(0xFFFEF3C7),
                    ),
                  const SizedBox(height: 12),
                ],
                
                Row(
                  children: [
                    // Imagen / Icono de Insumo
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2623), // Dark background matching the image placeholder
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          insumo.nombre.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Información
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insumo.nombre,
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 16,
                              color: Color(0xFF2C2623),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${insumo.cantidadActual}${insumo.unidad.value} restantes',
                            style: const TextStyle(
                              color: Color(0xFF807667),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Conditional "ULT. COMPRA" info if type is normal
                    if (type == _CardType.normal) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'ÚLT. COMPRA',
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Color(0xFFA0AEC0)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Hace ${now.difference(insumo.fechaUltimoPrecio).inDays} días',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2C2623)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _AlertBadge({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}


