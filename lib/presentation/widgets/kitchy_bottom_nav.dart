import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class KitchyBottomNav extends StatelessWidget {
  final int currentIndex;

  const KitchyBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F1).withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2623).withOpacity(0.04),
            offset: const Offset(0, -10),
            blurRadius: 30,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _NavItem(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Pedidos',
                  isActive: currentIndex == 0,
                  onTap: () => context.go('/agenda'),
                ),
                _NavItem(
                  icon: Icons.menu_book,
                  label: 'Recetas',
                  isActive: currentIndex == 1,
                  onTap: () => context.push('/recetas'),
                ),
                
                // Botón Cocina Flotante Central
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () => context.go('/'),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC69E57),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC69E57).withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: const Icon(Icons.restaurant, color: Color(0xFFFAF8F1), size: 30),
                    ),
                  ),
                ),

                _NavItem(
                  icon: Icons.inventory_2,
                  label: 'Alacena',
                  isActive: currentIndex == 2,
                  onTap: () => context.push('/alacena'),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  label: 'Perfil',
                  isActive: currentIndex == 3,
                  onTap: () => context.push('/perfil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    final color = isActive ? const Color(0xFFC69E57) : const Color(0xFF2C2623).withOpacity(0.6);
    
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
