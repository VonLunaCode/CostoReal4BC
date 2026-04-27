import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/kitchy_bottom_nav.dart';
import 'pedidos_providers.dart';
import 'widgets/pedido_card_widget.dart';
import '../../theme/kitchy_colors.dart';
import '../../theme/kitchy_typography.dart';

class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pedidosAsync = ref.watch(pedidosProvider);
    final currentFilter = ref.watch(pedidosFilterProvider);

    return Scaffold(
      backgroundColor: KitchyColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('KITCHY', style: KitchyTypography.logo),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: KitchyColors.border, width: 1.5),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            size: 20, color: KitchyColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Agenda', style: KitchyTypography.heading1),
                  const SizedBox(height: 2),
                  Text(
                    'Gestión de pedidos artesanales para hoy',
                    style: KitchyTypography.body,
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),

            // --- FILTER BAR ---
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterButton(context, ref, 'Todos', null, currentFilter),
                  _buildFilterButton(context, ref, 'Pendiente', 'pendiente', currentFilter),
                  _buildFilterButton(context, ref, 'En Preparación', 'en_preparacion', currentFilter),
                  _buildFilterButton(context, ref, 'Listo', 'listo', currentFilter),
                  _buildFilterButton(context, ref, 'Entregado', 'entregado', currentFilter),
                  _buildFilterButton(context, ref, 'Cancelado', 'cancelado', currentFilter),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // --- LIST ---
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
                    color: KitchyColors.primary,
                    child: ListView.builder(
                      itemCount: pedidos.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  child: CircularProgressIndicator(color: KitchyColors.primary),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Color(0xFFBA1A1A), size: 48),
                      const SizedBox(height: 16),
                      Text('Error al cargar pedidos', style: KitchyTypography.body),
                      TextButton(
                        onPressed: () => ref.invalidate(pedidosProvider),
                        child: Text('Reintentar', style: TextStyle(color: KitchyColors.primary)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: KitchyColors.primary,
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

  Widget _buildFilterButton(
    BuildContext context, 
    WidgetRef ref, 
    String label, 
    String? filterValue, 
    String? currentFilter
  ) {
    final isSelected = currentFilter == filterValue;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => ref.read(pedidosFilterProvider.notifier).state = filterValue,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? KitchyColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? KitchyColors.primary : KitchyColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: isSelected ? KitchyTypography.chipActive : KitchyTypography.chipInactive,
            ),
          ),
        ),
      ),
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
