import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
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
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Alacena',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A202C),
          ),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
                    decoration: InputDecoration(
                      hintText: 'Buscar insumos...',
                      hintStyle: const TextStyle(color: Color(0xFFA0AEC0)),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFA0AEC0)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                if (criticos.isNotEmpty || desactualizados.isNotEmpty) ...[
                  _SectionHeader(title: 'ATENCIÓN NECESARIA', color: const Color(0xFF718096)),
                  const SizedBox(height: 12),
                  ...criticos.map((i) => _InsumoCard(insumo: i, type: _CardType.critical)),
                  ...desactualizados.map((i) => _InsumoCard(insumo: i, type: _CardType.warning)),
                  const SizedBox(height: 24),
                ],

                _SectionHeader(title: 'INSUMOS EN ALACENA', color: const Color(0xFF718096)),
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
        backgroundColor: const Color(0xFFBC985D),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: color,
      ),
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
    final Color accentColor;
    final Color bgColor;
    final IconData iconData;
    final String? badgeText;

    switch (type) {
      case _CardType.critical:
        accentColor = const Color(0xFFDC2626);
        bgColor = const Color(0xFFFEE2E2);
        iconData = Icons.inventory_2;
        badgeText = 'STOCK BAJO';
        break;
      case _CardType.warning:
        accentColor = const Color(0xFFD97706);
        bgColor = const Color(0xFFFEF3C7);
        iconData = Icons.warning_amber;
        badgeText = 'PRECIO VIEJO';
        break;
      case _CardType.normal:
        accentColor = const Color(0xFFBC985D);
        bgColor = const Color(0xFFF3F4F6);
        iconData = Icons.inventory_2_outlined;
        badgeText = null;
    }

    // Calcular tiempo relativo simple
    final now = DateTime.now();
    final diff = now.difference(insumo.fechaUltimoPrecio).inDays;
    final timeStr = diff == 0 ? 'Hoy' : 'Hace $diff d';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (type == _CardType.critical)
                  Container(
                    width: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC2626),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icono Izquierdo
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(iconData, color: accentColor, size: 24),
                        ),
                        const SizedBox(width: 16),
                        // Información Central
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                insumo.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    '${insumo.cantidadActual} ${insumo.unidad.value}',
                                    style: const TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '•',
                                    style: TextStyle(
                                      color: const Color(0xFF718096).withOpacity(0.5),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '\$${insumo.precioCompra}',
                                    style: const TextStyle(
                                      color: Color(0xFFBC985D),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Badge / Info Derecha
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (badgeText != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  badgeText,
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                color: Color(0xFFA0AEC0),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: Color(0xFFCBD5E0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.assignment_outlined, label: 'Pedidos', isActive: false),
          _NavItem(icon: Icons.restaurant_menu, label: 'Recetas', isActive: false),
          _NavItem(icon: Icons.inventory_2, label: 'Alacena', isActive: true),
          _NavItem(icon: Icons.person_outline, label: 'Perfil', isActive: false),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _NavItem({required this.icon, required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFFBC985D) : const Color(0xFFA0AEC0);
    return InkWell(
      onTap: () {
        // Navegación pendiente
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
