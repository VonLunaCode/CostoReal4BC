import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/kitchy_colors.dart';
import '../../../theme/kitchy_typography.dart';
import '../../../theme/kitchy_spacing.dart';

class MapaButtonWidget extends StatelessWidget {
  final String? direccion;

  const MapaButtonWidget({super.key, this.direccion});

  Future<void> _openMaps(BuildContext context, String engine) async {
    if (direccion == null || direccion!.isEmpty) return;

    final encodedAddress = Uri.encodeComponent(direccion!);
    Uri url;

    if (engine == 'google') {
      // Google Maps
      url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedAddress');
    } else {
      // Waze
      url = Uri.parse('https://waze.com/ul?q=$encodedAddress&navigate=yes');
    }

    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir $engine')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al intentar abrir el mapa')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (direccion == null || direccion!.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('VER EN MAPA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: KitchyColors.textSecondary, letterSpacing: 1)),
        const SizedBox(height: 8),
        Row(
          children: [
            _mapOption(
              context: context,
              label: 'Google Maps',
              icon: Icons.map_outlined,
              onTap: () => _openMaps(context, 'google'),
            ),
            const SizedBox(width: 10),
            _mapOption(
              context: context,
              label: 'Waze',
              icon: Icons.navigation_outlined,
              onTap: () => _openMaps(context, 'waze'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mapOption({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KitchyRadius.button),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: KitchyColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(KitchyRadius.button),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: KitchyColors.textPrimary),
              const SizedBox(width: 8),
              Text(label, style: KitchyTypography.buttonSecondary.copyWith(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
