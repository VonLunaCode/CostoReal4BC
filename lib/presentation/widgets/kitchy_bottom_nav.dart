import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../theme/kitchy_colors.dart';
import '../../theme/kitchy_typography.dart';
import '../pedidos/pedidos_providers.dart';
import '../recetas/recetas_providers.dart';
import '../alacena/alacena_screen.dart';

class KitchyBottomNav extends ConsumerWidget {
  final int currentIndex;

  const KitchyBottomNav({super.key, required this.currentIndex});

  void _handleTap(BuildContext context, WidgetRef ref, int index, String route, dynamic provider) {
    if (currentIndex == index) {
      // Si ya estamos en la pestaña, invalidamos el provider para refrescar
      if (provider != null) {
        ref.invalidate(provider);
      }
    } else {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Importamos los providers necesarios (o asumimos que están disponibles)
    // Nota: Para evitar dependencias circulares, podrías usar strings o manejadores
    
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: KitchyColors.divider, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.calendar_today_outlined,
            label: 'Agenda',
            isActive: currentIndex == 0,
            onTap: () => _handleTap(context, ref, 0, '/agenda', pedidosProvider),
          ),
          _NavItem(
            icon: Icons.menu_book,
            label: 'Recetas',
            isActive: currentIndex == 1,
            onTap: () => _handleTap(context, ref, 1, '/recetas', recetasProvider),
          ),
          
          // Botón Cocina Flotante Central
          GestureDetector(
            onTap: () {
              if (currentIndex == -1 || routeActive(context, '/')) {
                 // Refresh home if needed
              }
              context.go('/');
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: KitchyColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant, color: Colors.white, size: 24),
            ),
          ),

          _NavItem(
            icon: Icons.inventory_2_outlined,
            label: 'Alacena',
            isActive: currentIndex == 2,
            onTap: () => _handleTap(context, ref, 2, '/alacena', alacenaProvider),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Perfil',
            isActive: currentIndex == 3,
            onTap: () => context.go('/perfil'),
          ),
        ],
      ),
    );
  }

  bool routeActive(BuildContext context, String route) {
    return GoRouterState.of(context).uri.toString() == route;
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? KitchyColors.primary : KitchyColors.navInactive;
    
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
