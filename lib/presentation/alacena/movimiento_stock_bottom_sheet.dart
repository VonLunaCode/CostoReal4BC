import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../data/api_generated/openapi.enums.swagger.dart';

/// Función global para mostrar el bottom sheet de movimientos
void showMovimientoStockBottomSheet({
  required BuildContext context,
  required InsumoResponse insumo,
  required VoidCallback onMovimientoRegistrado,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MovimientoStockBottomSheet(
      insumo: insumo,
      onMovimientoRegistrado: onMovimientoRegistrado,
    ),
  );
}

class MovimientoStockBottomSheet extends ConsumerStatefulWidget {
  final InsumoResponse insumo;
  final VoidCallback onMovimientoRegistrado;

  const MovimientoStockBottomSheet({
    super.key,
    required this.insumo,
    required this.onMovimientoRegistrado,
  });

  @override
  ConsumerState<MovimientoStockBottomSheet> createState() => _MovimientoStockBottomSheetState();
}

class _MovimientoStockBottomSheetState extends ConsumerState<MovimientoStockBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final List<bool> _isSelected = [true, false]; // [Entrada, Salida]
  final TextEditingController _cantidadController = TextEditingController();
  
  MovimientoCreateMotivo _motivoSeleccionado = MovimientoCreateMotivo.compra;
  String? _errorMessage;
  bool _isLoading = false;

  double get _cantidadActual => double.tryParse(widget.insumo.cantidadActual) ?? 0.0;
  
  double get _nuevaCantidad {
    final cantidadIngresada = double.tryParse(_cantidadController.text) ?? 0.0;
    return _isSelected[0] 
        ? _cantidadActual + cantidadIngresada 
        : _cantidadActual - cantidadIngresada;
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final api = ref.read(apiProvider);
    try {
      final response = await api.apiV1InsumosIdMovimientosPost(
        id: widget.insumo.id,
        body: MovimientoCreate(
          tipo: _isSelected[0] ? MovimientoCreateTipo.entrada : MovimientoCreateTipo.salida,
          cantidad: _cantidadController.text,
          motivo: _motivoSeleccionado,
        ),
      );

      if (response.isSuccessful) {
        widget.onMovimientoRegistrado();
        if (mounted) Navigator.pop(context);
      } else {
        setState(() => _errorMessage = response.error?.toString() ?? 'Error al registrar');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        top: 24, left: 24, right: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Registrar Movimiento', style: TextStyle(fontSize: 20, fontFamily: 'serif', fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Toggle Buttons para Tipo
            Center(
              child: ToggleButtons(
                isSelected: _isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _isSelected.length; i++) {
                      _isSelected[i] = i == index;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(12),
                constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 64) / 2, minHeight: 48),
                selectedColor: Colors.white,
                fillColor: const Color(0xFFC29F5C),
                children: const [
                  Text('ENTRADA', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('SALIDA', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel('CANTIDAD'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _cantidadController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF1F1F1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                suffixText: widget.insumo.unidad.value,
              ),
              onChanged: (_) => setState(() {}), // Disparar rebuild para el preview
              validator: (val) => (double.tryParse(val ?? '') ?? 0) <= 0 ? 'Monto inválido' : null,
            ),
            const SizedBox(height: 24),

            _buildLabel('MOTIVO'),
            const SizedBox(height: 8),
            DropdownButtonFormField<MovimientoCreateMotivo>(
              value: _motivoSeleccionado,
              items: MovimientoCreateMotivo.values
                  .where((m) => m != MovimientoCreateMotivo.swaggerGeneratedUnknown)
                  .map((m) {
                    String label;
                    switch (m) {
                      case MovimientoCreateMotivo.compra: label = 'Compra'; break;
                      case MovimientoCreateMotivo.usoProduccion: label = 'Uso en producción'; break;
                      case MovimientoCreateMotivo.merma: label = 'Merma'; break;
                      default: label = m.value ?? '';
                    }
                    return DropdownMenuItem(value: m, child: Text(label));
                  })
                  .toList(),
              onChanged: (val) => setState(() => _motivoSeleccionado = val!),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF1F1F1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),

            // Stock Preview Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF1F1E6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PROYECCIÓN DE STOCK', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFA0AEC0), letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ACTUAL', style: TextStyle(fontSize: 8, color: Color(0xFF718096))),
                          Text('${_cantidadActual.toStringAsFixed(1)} ${widget.insumo.unidad.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward, color: Color(0xFFCBD5E0), size: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('NUEVO', style: TextStyle(fontSize: 8, color: Color(0xFF718096))),
                          Text(
                            '${_nuevaCantidad.toStringAsFixed(1)} ${widget.insumo.unidad.value}', 
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC29F5C))
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(_errorMessage!, style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13)),
            ],

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC29F5C),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('REGISTRAR MOVIMIENTO', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFA0AEC0), letterSpacing: 1));
  }
}
