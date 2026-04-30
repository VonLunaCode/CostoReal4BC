import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_provider.dart';
import '../widgets/kitchy_bottom_nav.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Tu Perfil',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2623),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFEBE6D9),
              child: Icon(Icons.person, color: Color(0xFF7A613E), size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chef', // Podría usarse estado del usuario si lo tenemos
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2623),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'usuario@kitchy.app', // Placeholder
              style: TextStyle(fontSize: 14, color: Color(0xFF807667)),
            ),
            const SizedBox(height: 48),
            _buildOpcion(
              icon: Icons.settings_outlined,
              title: 'Configuración',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildOpcion(
              icon: Icons.help_outline,
              title: 'Soporte y Ayuda',
              onTap: () {},
            ),
            const SizedBox(height: 48),
            _buildLogoutButton(context, ref),
            const SizedBox(height: 100), // Espacio para el nav bar
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: const KitchyBottomNav(currentIndex: 3),
    );
  }

  Widget _buildOpcion({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2623).withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF7A613E)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C2623)),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFD5D1C6)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => ref.read(authProvider.notifier).logout(),
        icon: const Icon(Icons.logout),
        label: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFDE8E8),
          foregroundColor: const Color(0xFFC53030),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
