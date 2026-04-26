import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/kitchy_colors.dart';
import '../../../theme/kitchy_typography.dart';
import '../../../theme/kitchy_spacing.dart';

class WhatsappDeepLinkButton extends StatelessWidget {
  final String? whatsappUrl;
  final String clienteNombre;

  const WhatsappDeepLinkButton({
    super.key,
    required this.whatsappUrl,
    required this.clienteNombre,
  });

  Future<void> _launchWhatsApp(BuildContext context) async {
    if (whatsappUrl == null || whatsappUrl!.isEmpty) return;
    
    final uri = Uri.parse(whatsappUrl!);
    
    try {
      // Intento 1: Forzar app nativa (externalNonBrowserApplication)
      final launched = await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        // Intento 2: Fallback web/browser (externalApplication)
        final fallbackLaunched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!fallbackLaunched) {
          throw Exception('Could not launch fallback mode.');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp.'),
            backgroundColor: Color(0xFFBA1A1A),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Caso deshabilitado (sin número de WhatsApp)
    if (whatsappUrl == null || whatsappUrl!.isEmpty) {
      return Tooltip(
        message: 'Agrega el número de $clienteNombre para abrir WhatsApp',
        child: SizedBox(
          height: 46,
          child: ElevatedButton.icon(
            onPressed: null, // El botón queda gris y deshabilitado
            icon: const Icon(Icons.chat_outlined, color: KitchyColors.textDisabled, size: 18),
            label: Text(
              'Contactar por WhatsApp',
              style: KitchyTypography.button.copyWith(fontSize: 14, color: KitchyColors.textDisabled),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: KitchyColors.chipUnselected, // Gris apagado
              disabledBackgroundColor: KitchyColors.chipUnselected,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(KitchyRadius.button),
              ),
            ),
          ),
        ),
      );
    }

    // Caso activo
    return SizedBox(
      height: 46,
      child: ElevatedButton.icon(
        onPressed: () => _launchWhatsApp(context),
        icon: const Icon(Icons.chat_outlined, color: KitchyColors.whatsappText, size: 18),
        label: Text(
          'Contactar por WhatsApp',
          style: KitchyTypography.button.copyWith(fontSize: 14, color: KitchyColors.whatsappText),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: KitchyColors.whatsapp,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KitchyRadius.button),
          ),
        ),
      ),
    );
  }
}
