import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/kitchy_bottom_nav.dart';
import 'pedidos_providers.dart';
import 'widgets/pedido_card_widget.dart';

class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pedidosAsync = ref.watch(pedidosProvider);
    final currentFilter = ref.watch(pedidosFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF9F2),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'KITCHY',
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Color(0xFFC69E57), // Golden color from Figma
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFEEDCD5),
              child: IconButton(
                icon: const Icon(Icons.person_outline, color: Color(0xFF2C2623)),
                onPressed: () {
                  context.push('/perfil');
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Texts
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agenda',
                  style: TextStyle(
                    fontFamily: 'Noto Serif',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2623),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestión de pedidos artesanales para hoy.',
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterChip(context, ref, 'Todos', null, currentFilter),
                const SizedBox(width: 8),
                _buildFilterChip(context, ref, 'Pendiente', 'pendiente', currentFilter),
                const SizedBox(width: 8),
                _buildFilterChip(context, ref, 'En Preparación', 'en_preparacion', currentFilter),
                const SizedBox(width: 8),
                _buildFilterChip(context, ref, 'Listo', 'listo', currentFilter),
                const SizedBox(width: 8),
                _buildFilterChip(context, ref, 'Entregado', 'entregado', currentFilter),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // List or Empty State
          Expanded(
            child: pedidosAsync.when(
              data: (pedidos) {
                if (pedidos.isEmpty) {
                  return _buildEmptyState(context);
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(pedidosProvider);
                  },
                  color: const Color(0xFFC69E57),
                  child: ListView.builder(
                    itemCount: pedidos.length,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index];
                      return PedidoCardWidget(
                        pedido: pedido,
                        onTap: () {
                          context.go('/agenda/${pedido.id}');
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFC69E57)),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFBA1A1A), size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar pedidos',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(pedidosProvider),
                      child: const Text('Reintentar', style: TextStyle(color: Color(0xFFC69E57))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC69E57), // Figma golden color
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          context.go('/agenda/crear');
        },
        child: const Icon(Icons.add, size: 28),
      ),
      extendBody: true,
      bottomNavigationBar: const KitchyBottomNav(currentIndex: 0),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, 
    WidgetRef ref, 
    String label, 
    String? filterValue, 
    String? currentFilter
  ) {
    final isSelected = currentFilter == filterValue;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Work Sans',
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? Colors.white : const Color(0xFF6D605A),
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(pedidosFilterProvider.notifier).state = filterValue;
      },
      backgroundColor: const Color(0xFFEEDCD5).withOpacity(0.4), // Light surface variant
      selectedColor: const Color(0xFFC69E57), // Golden
      checkmarkColor: Colors.transparent, // Hide checkmark like Figma
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: const Color(0xFFD2C5B4).withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            '¡Sin pedidos!',
            style: TextStyle(
              fontFamily: 'Noto Serif',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2623),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No hay pedidos pendientes en tu agenda.',
            style: TextStyle(
              fontFamily: 'Work Sans',
              color: Color(0xFF6D605A),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/agenda/crear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC69E57),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Registrar primer pedido',
              style: TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
