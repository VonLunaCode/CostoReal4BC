import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../theme/kitchy_colors.dart';
import '../../theme/kitchy_typography.dart';
import '../../theme/kitchy_spacing.dart';
import '../../theme/kitchy_shadows.dart';
import 'package:go_router/go_router.dart';
import '../widgets/kitchy_bottom_nav.dart';
import 'pedidos_providers.dart';
import 'widgets/whatsapp_deep_link_button.dart';
import 'widgets/cambiar_estado_pedido_bottom_sheet.dart';
import '../../utils/date_formatter.dart';

class PedidoDetailScreen extends ConsumerWidget {
  final String pedidoId;

  const PedidoDetailScreen({super.key, required this.pedidoId});

  String _formatDeliveryType(String? type) {
    if (type == null) return 'Entrega';
    if (type.toLowerCase().contains('domicilio')) return 'Entrega a Domicilio';
    return type;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pedidoAsync = ref.watch(pedidoDetailProvider(pedidoId));

    return Scaffold(
      backgroundColor: KitchyColors.background,
      appBar: AppBar(
        backgroundColor: KitchyColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: KitchyColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text('KITCHY', style: KitchyTypography.logo),
        centerTitle: true,
        actions: [
          pedidoAsync.when(
            data: (pedido) => IconButton(
              icon: const Icon(Icons.edit_outlined, color: KitchyColors.textPrimary),
              onPressed: () async {
                final updated = await context.push<bool>(
                  '/agenda/${pedido.id}/editar',
                  extra: pedido,
                );
                if (updated == true) {
                  ref.invalidate(pedidoDetailProvider(pedidoId));
                  ref.invalidate(pedidosProvider);
                }
              },
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: KitchyColors.border,
            child: Icon(Icons.person, color: KitchyColors.textSecondary, size: 18),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: pedidoAsync.when(
        data: (pedido) {
          final isDelivery = true; // Por ahora asumimos que todos son domicilio si no hay tipo_entrega
          final formattedDate = KitchyDateFormatter.formatDeliveryDate(pedido.fechaEntrega);
          final subtotal = pedido.lineas.fold(0.0, (sum, linea) {
            final double precioLinea = double.tryParse(linea.precioAcordadoMxn.toString()) ?? 0.0;
            return sum + precioLinea;
          });
          final envio = 0.0; // Placeholder si no viene de la API
          final total = subtotal + envio;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: KitchySpacing.screenHorizontal,
              vertical: KitchySpacing.screenTop,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header cliente
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pedido.clienteNombre.replaceAll(' ', '\n'), // Separar en 2 líneas si hay espacio
                      style: KitchyTypography.clientHeading,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 13, color: KitchyColors.textSecondary),
                        const SizedBox(width: 5),
                        Text(
                          '$formattedDate — ${pedido.puntoEntrega != null && pedido.puntoEntrega!.isNotEmpty ? 'Entrega a Domicilio' : 'Retiro en Local'}',
                          style: KitchyTypography.deliveryMeta,
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),

                // 2. Botones de contacto
                Row(
                  children: [
                    Expanded(
                      child: WhatsappDeepLinkButton(
                        whatsappUrl: pedido.whatsappUrl?.toString(),
                        clienteNombre: pedido.clienteNombre,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        border: Border.all(color: KitchyColors.border, width: 1.5),
                        borderRadius: BorderRadius.circular(KitchyRadius.button),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.phone_outlined, color: KitchyColors.textSecondary, size: 20),
                        onPressed: () async {
                          final phone = pedido.clienteWhatsapp?.toString();
                          if (phone != null && phone.isNotEmpty) {
                            final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
                            final uri = Uri.parse('tel:$cleanPhone');
                            try {
                              final launched = await launchUrl(uri);
                              if (!launched && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No se pudo abrir el teléfono (Asegúrate de estar en un dispositivo real)')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No se pudo abrir el teléfono')),
                                );
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Número de teléfono no disponible')),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 3. Estado del pedido
                // 3. Estado del pedido (Tappable para abrir Bottom Sheet)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ESTADO DEL PEDIDO', style: KitchyTypography.sectionLabel),
                    const Icon(Icons.touch_app, size: 14, color: KitchyColors.textSecondary),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showCambiarEstadoBottomSheet(
                      context,
                      ref,
                      pedido,
                      () {
                        ref.invalidate(pedidoDetailProvider(pedidoId));
                        ref.invalidate(pedidosProvider); // Para refrescar la agenda
                      },
                    );
                  },
                  child: _buildStatusStepper(pedido.estado),
                ),

                const SizedBox(height: 24),

                // 4. Resumen de orden
                Container(
                  decoration: BoxDecoration(
                    color: KitchyColors.surface,
                    borderRadius: BorderRadius.circular(KitchyRadius.large),
                    border: Border.all(color: KitchyColors.border, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: Text('Resumen de Orden',
                            style: KitchyTypography.heading1.copyWith(fontSize: 18)),
                      ),
                      const Divider(color: KitchyColors.divider, height: 1),
                      
                      // Llenar con lineas
                      ...pedido.lineas.map((linea) {
                        final totalLinea = double.tryParse(linea.precioAcordadoMxn.toString()) ?? 0.0;
                        final precioUnitario = linea.cantidadPorciones > 0 ? totalLinea / linea.cantidadPorciones : 0.0;
                        
                        return Column(
                          children: [
                            _orderItem(
                              name: linea.nombreProducto,
                              qty: linea.cantidadPorciones,
                              variant: 'Precio unitario: \$${precioUnitario.toStringAsFixed(2)}',
                              price: '\$${totalLinea.toStringAsFixed(2)}',
                            ),
                            const Divider(color: KitchyColors.divider, height: 1, indent: 16, endIndent: 16),
                          ],
                        );
                      }),
                      
                      const Divider(color: KitchyColors.divider, height: 1),
                      
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _summaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                            const SizedBox(height: 6),
                            _summaryRow('Envío', '\$${envio.toStringAsFixed(2)}'),
                            const SizedBox(height: 10),
                            const Divider(color: KitchyColors.divider),
                            const SizedBox(height: 10),
                            _summaryRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 5. Info cards (solo mostrar si tienen info)
                if (pedido.puntoEntrega != null && pedido.puntoEntrega!.isNotEmpty) ...[
                  _infoCard(
                    icon: Icons.location_on_outlined,
                    label: 'DIRECCIÓN',
                    content: pedido.puntoEntrega!,
                  ),
                  const SizedBox(height: 12),
                ],
                if (pedido.notas != null && pedido.notas!.isNotEmpty) ...[
                  _infoCard(
                    icon: Icons.notes_outlined,
                    label: 'NOTAS',
                    content: pedido.notas!,
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: KitchyColors.primary),
        ),
        error: (err, stack) => Center(
          child: Text('Error al cargar detalle: $err', style: TextStyle(color: Colors.red)),
        ),
      ),
      bottomNavigationBar: const KitchyBottomNav(currentIndex: 0),
    );
  }

  Widget _buildStatusStepper(String estado) {
    int currentStep = 0;
    switch (estado.toLowerCase()) {
      case 'pendiente': currentStep = 0; break;
      case 'en_preparacion': currentStep = 1; break;
      case 'listo': currentStep = 2; break;
      case 'entregado': currentStep = 3; break;
      default: currentStep = 0;
    }

    final steps = [
      {'label': 'Pendiente',   'icon': Icons.access_time_outlined},
      {'label': 'Preparando',  'icon': Icons.storefront_outlined},
      {'label': 'Listo',       'icon': Icons.check_box_outlined},
      {'label': 'Entregado',   'icon': Icons.task_alt_outlined},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: KitchyColors.surface,
        borderRadius: BorderRadius.circular(KitchyRadius.large),
        border: Border.all(color: KitchyColors.border, width: 1),
      ),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isCompleted = i < currentStep;
          final isActive    = i == currentStep;
          
          Color bgColor = isCompleted
              ? KitchyColors.stepCompleted
              : isActive
                  ? KitchyColors.primary
                  : KitchyColors.chipUnselected;

          Color iconColor = (isCompleted || isActive)
              ? Colors.white
              : KitchyColors.textDisabled;

          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : steps[i]['icon'] as IconData,
                    color: iconColor,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[i]['label'] as String,
                  textAlign: TextAlign.center,
                  style: isActive
                      ? KitchyTypography.stepLabelActive
                      : KitchyTypography.stepLabel,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _orderItem({
    required String name,
    required int qty,
    required String variant,
    required String price,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen placeholder
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: KitchyColors.surfaceWarm,
              borderRadius: BorderRadius.circular(KitchyRadius.small),
              border: Border.all(color: KitchyColors.border),
            ),
            child: const Icon(Icons.fastfood_outlined, color: KitchyColors.iconMuted),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name (x$qty)', style: KitchyTypography.productName),
                const SizedBox(height: 2),
                Text(variant, style: KitchyTypography.productVariant),
              ],
            ),
          ),
          // Precio
          Text(price, style: KitchyTypography.productPrice),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: isTotal
                ? KitchyTypography.totalRow
                : KitchyTypography.summaryRow),
        Text(amount,
            style: isTotal
                ? KitchyTypography.totalAmount
                : KitchyTypography.summaryRow
                    .copyWith(color: KitchyColors.textPrimary)),
      ],
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KitchyColors.infoCardBg,
        borderRadius: BorderRadius.circular(KitchyRadius.large),
        border: Border.all(color: KitchyColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: KitchyColors.primary),
              const SizedBox(width: 6),
              Text(label, style: KitchyTypography.sectionLabel),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: KitchyTypography.infoBody),
        ],
      ),
    );
  }
}
