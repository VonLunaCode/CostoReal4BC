import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth_provider.dart';
import '../widgets/kitchy_bottom_nav.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Kitchy', 
          style: TextStyle(
            fontFamily: 'Georgia', 
            fontStyle: FontStyle.italic,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2623),
          )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => ref.read(authProvider.notifier).logout(),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFEAE8E1),
                child: Icon(Icons.person, color: Color(0xFF718096), size: 20),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡HOLA, CHEF!',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: Color(0xFF807667),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bienvenido de vuelta',
              style: TextStyle(fontSize: 28, fontFamily: 'Georgia', fontWeight: FontWeight.bold, color: Color(0xFF2C2623)),
            ),
            const SizedBox(height: 32),
            _buildMainCard(
              context,
              title: 'Alacena Virtual',
              subtitle: 'Gestiona tus insumos y stock',
              icon: Icons.inventory_2_outlined,
              onTap: () => context.push('/alacena'),
            ),
            const SizedBox(height: 16),
            _buildMainCard(
              context,
              title: 'Mis Recetas',
              subtitle: 'Costea y planifica tu menú',
              icon: Icons.restaurant_menu,
              onTap: () => context.push('/recetas'),
            ),
            const SizedBox(height: 16),
            _buildMainCard(
              context,
              title: 'Reportes',
              subtitle: 'Analiza tus gastos',
              icon: Icons.bar_chart,
              onTap: () {},
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: const KitchyBottomNav(currentIndex: -1),
    );
  }

  Widget _buildMainCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2623).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC69E57).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: const Color(0xFFC69E57), size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2C2623)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Color(0xFF807667), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFD2C5B4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
