import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/api_generated/openapi.models.swagger.dart';
import '../../../utils/date_formatter.dart';
import '../../../theme/kitchy_colors.dart';
import '../../../theme/kitchy_typography.dart';
import '../../../data/api_provider.dart';
import '../pedidos_providers.dart';

class PedidoCardWidget extends ConsumerWidget {
  final PedidoResponse pedido;
  final VoidCallback onTap;

  const PedidoCardWidget({
    super.key,
    required this.pedido,
    required this.onTap,
  });

  Future<void> _changeStatus(BuildContext context, WidgetRef ref, String nextStatus, String actionLabel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Confirmar $actionLabel?'),
        content: Text('¿Estás seguro de que deseas cambiar el estado a "$nextStatus"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: KitchyColors.primary),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final api = ref.read(apiProvider);
      final response = await api.apiV1PedidosPedidoIdEstadoPatch(
        pedidoId: pedido.id,
        nuevoEstado: nextStatus,
      );

      if (response.isSuccessful) {
        ref.invalidate(pedidosProvider);
        // También invalidar el detalle por si acaso
        ref.invalidate(pedidoDetailProvider(pedido.id));
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cambiar estado: ${response.error}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error inesperado')),
        );
      }
    }
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final phone = pedido.clienteWhatsapp?.toString();
    if (phone == null || phone.isEmpty) return;
    
    // Limpiar número: quedarse solo con dígitos
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
    
    // Crear mensaje automático
    final productos = pedido.lineas.map((l) => '${l.cantidadPorciones}x ${l.nombreProducto}').join(', ');
    final mensaje = '¡Hola ${pedido.clienteNombre}! Te escribo de Kitchy sobre tu pedido de ($productos). ¿Todo bien para la entrega hoy?';
    final encodedMsg = Uri.encodeComponent(mensaje);
    
    // La URL correcta de wa.me no lleva el + ni caracteres especiales
    final url = Uri.parse('https://wa.me/52$cleanPhone?text=$encodedMsg');
    
    try {
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir WhatsApp')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al intentar abrir WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estado = pedido.estado.toLowerCase();
    final cfg = _getStatusConfig(estado);
    
    final productosTexto = pedido.lineas.map((l) => '${l.cantidadPorciones}x ${l.nombreProducto}').toList();
    final subtotal = pedido.lineas.fold(0.0, (sum, linea) {
      final double precioLinea = double.tryParse(linea.precioAcordadoMxn.toString()) ?? 0.0;
      return sum + precioLinea;
    });

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C1F0E).withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge + total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusBadge(label: cfg.label, bg: cfg.bg, fg: cfg.fg),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Total', style: KitchyTypography.price),
                    Text(
                      '\$${subtotal.toStringAsFixed(2)}',
                      style: KitchyTypography.priceTotal,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Client name + time
            Text(pedido.clienteNombre, style: KitchyTypography.clientHeading),
            const SizedBox(height: 2),
            Text(
              KitchyDateFormatter.formatDeliveryDate(pedido.fechaEntrega),
              style: KitchyTypography.deliveryMeta,
            ),
            const SizedBox(height: 10),

            // Items list
            ...productosTexto.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(text, style: KitchyTypography.productName),
              ),
            ),

            if (pedido.notas != null && pedido.notas!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 13, color: Color(0xFF8B7355)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      pedido.notas!,
                      style: KitchyTypography.infoBody,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Action row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Action: WhatsApp
                GestureDetector(
                  onTap: () => _launchWhatsApp(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: KitchyColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chat_bubble_outline,
                        size: 16, color: KitchyColors.textSecondary),
                  ),
                ),

                // Action button (Tap card for details/change status)
                if (cfg.actionLabel != null && cfg.nextStatus != null)
                  GestureDetector(
                    onTap: () => _changeStatus(context, ref, cfg.nextStatus!, cfg.actionLabel!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: cfg.actionColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        cfg.actionLabel!,
                        style: KitchyTypography.button,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(String estado) {
    switch (estado) {
      case 'pendiente':
        return _StatusConfig(
          label: 'Pendiente',
          bg: const Color(0xFFFFF3E0),
          fg: const Color(0xFFE65100),
          actionLabel: 'Preparar',
          actionColor: KitchyColors.primary,
          nextStatus: 'en_preparacion',
        );
      case 'en_preparacion':
        return _StatusConfig(
          label: 'En Preparación',
          bg: const Color(0xFFFFF8E1),
          fg: const Color(0xFFF57F17),
          actionLabel: 'Terminar',
          actionColor: KitchyColors.textPrimary,
          nextStatus: 'listo',
        );
      case 'listo':
        return _StatusConfig(
          label: 'Listo',
          bg: const Color(0xFFE8F5E9),
          fg: const Color(0xFF2E7D32),
          actionLabel: 'Entregar',
          actionColor: const Color(0xFF2E7D32),
          nextStatus: 'entregado',
        );
      case 'entregado':
        return _StatusConfig(
          label: 'Entregado',
          bg: const Color(0xFFF3F3F3),
          fg: const Color(0xFF757575),
          actionLabel: null,
          actionColor: Colors.transparent,
          nextStatus: null,
        );
      case 'cancelado':
        return _StatusConfig(
          label: 'Cancelado',
          bg: const Color(0xFFFFEBEE),
          fg: const Color(0xFFC62828),
          actionLabel: null,
          actionColor: Colors.transparent,
          nextStatus: null,
        );
      default:
        return _StatusConfig(
          label: estado.toUpperCase(),
          bg: const Color(0xFFF3F3F3),
          fg: const Color(0xFF757575),
          actionLabel: null,
          actionColor: Colors.transparent,
          nextStatus: null,
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _StatusBadge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _StatusConfig {
  final String label;
  final Color bg;
  final Color fg;
  final String? actionLabel;
  final Color actionColor;
  final String? nextStatus;

  const _StatusConfig({
    required this.label,
    required this.bg,
    required this.fg,
    required this.actionLabel,
    required this.actionColor,
    required this.nextStatus,
  });
}
