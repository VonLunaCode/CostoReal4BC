import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontFamily: 'serif', fontSize: 28)),
        actions: [
          IconButton(
            onPressed: () => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡HOLA, CHEF!',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Color(0xFF718096),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bienvenido de vuelta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.go('/alacena');
          if (index == 2) context.push('/recetas');
          if (index == 3) context.push('/perfil');
        },
        selectedItemColor: const Color(0xFFBC985D),
        unselectedItemColor: const Color(0xFF718096),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Alacena'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recetas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFBC985D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: const Color(0xFFBC985D), size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2D3748)),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF718096), fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF718096)),
            ],
          ),
        ),
      ),
    );
  }
}
