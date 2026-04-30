import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/api_provider.dart';
import '../../../../data/api_generated/openapi.models.swagger.dart';
import '../../../../theme/kitchy_colors.dart';
import '../../../../theme/kitchy_typography.dart';
import '../../../../theme/kitchy_spacing.dart';

void showCambiarEstadoBottomSheet(
  BuildContext context,
  WidgetRef ref,
  PedidoResponse pedido,
  VoidCallback onEstadoCambiado,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: KitchyColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) {
      return _CambiarEstadoBottomSheetContent(
        pedido: pedido,
        onEstadoCambiado: onEstadoCambiado,
      );
    },
  );
}

class _CambiarEstadoBottomSheetContent extends ConsumerStatefulWidget {
  final PedidoResponse pedido;
  final VoidCallback onEstadoCambiado;

  const _CambiarEstadoBottomSheetContent({
    required this.pedido,
    required this.onEstadoCambiado,
  });

  @override
  ConsumerState<_CambiarEstadoBottomSheetContent> createState() => _CambiarEstadoBottomSheetContentState();
}

class _CambiarEstadoBottomSheetContentState extends ConsumerState<_CambiarEstadoBottomSheetContent> {
  bool _isLoading = false;

  Future<void> _cambiarEstado(String nuevoEstado) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final api = ref.read(apiProvider);
      final response = await api.apiV1PedidosPedidoIdEstadoPatch(
        pedidoId: widget.pedido.id,
        nuevoEstado: nuevoEstado,
      );

      if (response.isSuccessful) {
        if (!mounted) return;
        Navigator.pop(context); // Cerrar bottom sheet
        widget.onEstadoCambiado(); // Notificar al padre
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar estado: \${response.error}'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error inesperado.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarDialogoCancelacion() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: KitchyColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KitchyRadius.large),
          ),
          title: Text(
            '¿Cancelar pedido?',
            style: KitchyTypography.heading1.copyWith(fontSize: 20),
          ),
          content: Text(
            'Esta acción no se puede deshacer. ¿Estás seguro de que quieres cancelar este pedido?',
            style: KitchyTypography.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Atrás',
                style: KitchyTypography.button.copyWith(color: KitchyColors.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Cerrar diálogo
                _cambiarEstado('cancelado'); // Proceder a cancelar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626), // Rojo
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(KitchyRadius.button),
                ),
              ),
              child: Text(
                'Sí, Cancelar',
                style: KitchyTypography.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final estado = widget.pedido.estado.toLowerCase();
    
    String? accionPrimariaTexto;
    String? nuevoEstadoPrimario;
    Color colorPrimario = KitchyColors.primary;

    if (estado == 'pendiente') {
      accionPrimariaTexto = 'Iniciar Preparación';
      nuevoEstadoPrimario = 'en_preparacion';
    } else if (estado == 'en_preparacion') {
      accionPrimariaTexto = 'Marcar como Listo';
      nuevoEstadoPrimario = 'listo';
    } else if (estado == 'listo') {
      accionPrimariaTexto = 'Marcar como Entregado';
      nuevoEstadoPrimario = 'entregado';
      colorPrimario = KitchyColors.stepCompleted; // Verde suave para entregar
    }

    final esEntregado = estado == 'entregado';
    final esCancelado = estado == 'cancelado';
    final mostrarBotonCancelar = !esEntregado && !esCancelado;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(KitchySpacing.screenHorizontal),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: KitchyColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Actualizar Estado',
              style: KitchyTypography.heading1.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(color: KitchyColors.primary),
                ),
              )
            else ...[
              if (esEntregado)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Pedido completado ✅',
                      style: KitchyTypography.heading1.copyWith(
                        fontSize: 18,
                        color: KitchyColors.stepCompleted,
                      ),
                    ),
                  ),
                )
              else if (esCancelado)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Pedido cancelado 🚫',
                      style: KitchyTypography.heading1.copyWith(
                        fontSize: 18,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                )
              else if (accionPrimariaTexto != null && nuevoEstadoPrimario != null)
                SizedBox(
                  height: 52, // Más de 48dp
                  child: ElevatedButton(
                    onPressed: () => _cambiarEstado(nuevoEstadoPrimario!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorPrimario,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(KitchyRadius.button),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      accionPrimariaTexto,
                      style: KitchyTypography.button.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              if (mostrarBotonCancelar) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 52, // Más de 48dp
                  child: TextButton(
                    onPressed: _mostrarDialogoCancelacion,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(KitchyRadius.button),
                      ),
                    ),
                    child: Text(
                      'Cancelar Pedido',
                      style: KitchyTypography.button.copyWith(
                        fontSize: 16,
                        color: const Color(0xFFDC2626), // Rojo
                      ),
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
