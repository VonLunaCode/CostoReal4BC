import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/api_generated/openapi.models.swagger.dart';

class PedidoCardWidget extends StatelessWidget {
  final PedidoResponse pedido;
  final VoidCallback onTap;

  const PedidoCardWidget({
    super.key,
    required this.pedido,
    required this.onTap,
  });

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return const Color(0xFF6B7280); // Gray
      case 'en_preparacion':
      case 'en preparación':
        return const Color(0xFFD97706); // Amber
      case 'listo':
        return const Color(0xFF16A34A); // Green
      case 'entregado':
        return const Color(0xFF2563EB); // Blue
      case 'cancelado':
        return const Color(0xFFDC2626); // Red
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM HH:mm');
    return 'Entrega: ${formatter.format(date)}';
  }

  Future<void> _launchWhatsApp(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    
    // Clean phone number
    final cleanPhone = phone.replaceAll(RegExp(r'\\D'), '');
    final url = Uri.parse('https://wa.me/\$cleanPhone');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getEstadoColor(pedido.estado);
    
    // Subtítulo de productos "2x Sourdough, 1x Croissant..."
    final productosTexto = pedido.lineas.map((l) {
      return '${l.cantidadPorciones}x ${l.nombreProducto}';
    }).join(', ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F2), // Surface Bright
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2623).withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra Izquierda de 4dp
              Container(
                width: 4.0,
                color: statusColor,
              ),
              
              // Contenido Principal
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Cliente & Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  pedido.clienteNombre,
                                  style: const TextStyle(
                                    fontFamily: 'Noto Serif',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C2623),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Badge de Estado
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  pedido.estado.toUpperCase().replaceAll('_', ' '),
                                  style: TextStyle(
                                    fontFamily: 'Work Sans',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // Subtítulo de Productos
                          Text(
                            productosTexto.isEmpty ? 'Sin productos' : productosTexto,
                            style: const TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 13,
                              color: Color(0xFF6D605A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Bottom Row: Fecha/Hora y WhatsApp
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatDate(pedido.fechaEntrega),
                                    style: TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Botón de WhatsApp Condicional
                              if (pedido.clienteWhatsapp != null && pedido.clienteWhatsapp.toString().isNotEmpty)
                                GestureDetector(
                                  onTap: () => _launchWhatsApp(pedido.clienteWhatsapp.toString()),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF25D366).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.chat, // Fallback icon for WhatsApp
                                      size: 16,
                                      color: Color(0xFF25D366),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
