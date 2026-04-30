import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../data/api_generated/openapi.enums.swagger.dart';
import 'alacena_screen.dart';

class InsumoFormScreen extends ConsumerStatefulWidget {
  final InsumoResponse? insumoExistente;
  const InsumoFormScreen({super.key, this.insumoExistente});

  @override
  ConsumerState<InsumoFormScreen> createState() => _InsumoFormScreenState();
}

class _InsumoFormScreenState extends ConsumerState<InsumoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _cantidadController;
  late TextEditingController _alertaController;
  
  InsumoResponseUnidad _unidadSeleccionada = InsumoResponseUnidad.kg;
  bool _isLoading = false;
  late final String _initialPrecio;
  late final String _initialCantidad;

  bool get _isEditing => widget.insumoExistente != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.insumoExistente?.nombre ?? '');
    _precioController = TextEditingController(text: widget.insumoExistente?.precioCompra ?? '');
    _cantidadController = TextEditingController(text: widget.insumoExistente?.cantidadActual ?? '');
    _alertaController = TextEditingController(text: widget.insumoExistente?.alertaMinimo ?? '0');
    
    if (_isEditing) {
      _unidadSeleccionada = widget.insumoExistente!.unidad;
    }

    _initialPrecio = widget.insumoExistente?.precioCompra ?? '';
    _initialCantidad = widget.insumoExistente?.cantidadActual ?? '';

    _precioController.addListener(() => setState(() {}));
    _cantidadController.addListener(() => setState(() {}));
    _nombreController.addListener(() => setState(() {}));
    _alertaController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    _alertaController.dispose();
    super.dispose();
  }

  String get _precioUnitario {
    final precio = double.tryParse(_precioController.text) ?? 0.0;
    final cantidad = double.tryParse(_cantidadController.text) ?? 0.0;
    if (cantidad <= 0) return '—';
    return (precio / cantidad).toStringAsFixed(2);
  }

  bool get _showCostWarning =>
      _isEditing &&
      (_precioController.text != _initialPrecio ||
       _cantidadController.text != _initialCantidad);

  bool get _isDirty {
    if (!_isEditing) return true;
    return _nombreController.text != (widget.insumoExistente?.nombre ?? '') ||
           _precioController.text != _initialPrecio ||
           _cantidadController.text != _initialCantidad ||
           _alertaController.text != (widget.insumoExistente?.alertaMinimo ?? '0') ||
           _unidadSeleccionada != widget.insumoExistente!.unidad;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final api = ref.read(apiProvider);

    try {
      if (_isEditing) {
        final response = await api.apiV1InsumosIdPut(
          id: widget.insumoExistente!.id,
          body: InsumoUpdate(
            nombre: _nombreController.text,
            unidad: _unidadSeleccionada.value,
            precioCompra: _precioController.text,
            cantidadComprada: _cantidadController.text,
            alertaMinimo: _alertaController.text,
          ),
        );
        if (response.isSuccessful) {
          ref.invalidate(alacenaProvider);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Insumo actualizado')),
            );
            context.pop(true);
          }
        } else {
          throw Exception(response.error ?? 'Error al actualizar');
        }
      } else {
        final response = await api.apiV1InsumosPost(
          body: InsumoCreate(
            nombre: _nombreController.text,
            unidad: InsumoCreateUnidad.values.firstWhere((e) => e.value == _unidadSeleccionada.value),
            precioCompra: _precioController.text,
            cantidadComprada: _cantidadController.text,
            alertaMinimo: _alertaController.text,
          ),
        );
        if (response.isSuccessful) {
          ref.invalidate(alacenaProvider);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Insumo creado')),
            );
            context.pop(true);
          }
        } else {
          throw Exception(response.error ?? 'Error al crear');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception:', '')),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF4A4A4A)),
          onPressed: () => context.pop(),
        ),
        title: const Text('Kitchy', style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                _isEditing ? 'Editar Insumo' : 'Nuevo Insumo',
                style: const TextStyle(fontFamily: 'serif', fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ingresa los detalles para actualizar tu alacena artesanal.',
                style: TextStyle(color: Color(0xFF718096), fontSize: 14),
              ),
              const SizedBox(height: 40),
              
              _buildFieldLabel('NOMBRE DEL INSUMO'),
              const SizedBox(height: 8),
              _buildTextField(_nombreController, 'Ej. Harina de Trigo Orgánica', maxLength: 200),
              
              const SizedBox(height: 24),
              _buildFieldLabel('UNIDAD DE MEDIDA'),
              const SizedBox(height: 8),
              DropdownButtonFormField<InsumoResponseUnidad>(
                value: _unidadSeleccionada,
                items: InsumoResponseUnidad.values
                    .where((u) => u != InsumoResponseUnidad.swaggerGeneratedUnknown)
                    .map((u) => DropdownMenuItem(value: u, child: Text(u.value ?? '')))
                    .toList(),
                onChanged: (val) => setState(() => _unidadSeleccionada = val!),
                decoration: _inputStyle(''),
              ),
              
              const SizedBox(height: 24),
              _buildFieldLabel('ALERTA STOCK MÍNIMO'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _alertaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '0.00',
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffix: Text(
                    _unidadSeleccionada.value ?? '',
                    style: const TextStyle(color: Color(0xFF718096), fontWeight: FontWeight.w600),
                  ),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Requerido' : null,
              ),
              
              const SizedBox(height: 24),
              _buildFieldLabel('CANTIDAD COMPRADA'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cantidadController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '0',
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffix: Text(
                    _unidadSeleccionada.value ?? '',
                    style: const TextStyle(color: Color(0xFF718096), fontWeight: FontWeight.w600),
                  ),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Requerido' : null,
              ),

              const SizedBox(height: 24),
              _buildFieldLabel('PRECIO DE COMPRA'),
              const SizedBox(height: 8),
              _buildTextField(_precioController, '0.00', isNumeric: true, prefix: '\$ '),
              const SizedBox(height: 4),
              const Text(
                'Precio total pagado por el empaque/paquete completo.',
                style: TextStyle(fontSize: 10, color: Color(0xFF718096)),
              ),
              const SizedBox(height: 4),
              Text(
                'Precio unitario: \$$_precioUnitario / ${_unidadSeleccionada.value ?? ""}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF718096), fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 40),

              if (_showCostWarning)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFCD34D)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Al cambiar el precio o la cantidad, el costo de todas las recetas que usen este insumo se recalculará automáticamente.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                        ),
                      ),
                    ],
                  ),
                ),
              
              ElevatedButton.icon(
                onPressed: (_isLoading || !_isDirty) ? null : _save,
                icon: _isLoading ? const SizedBox() : const Icon(Icons.save_outlined),
                label: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : Text(_isEditing ? 'Guardar Cambios' : 'Guardar Insumo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDirty ? const Color(0xFF6B9478) : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              Center(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancelar', style: TextStyle(color: Color(0xFFDC2626))),
                ),
              ),
              
              const SizedBox(height: 40),
              _buildChefTip(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4A4A4A), letterSpacing: 0.5));
  }

  InputDecoration _inputStyle(String hint, {String? prefix}) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefix,
      filled: true,
      fillColor: const Color(0xFFEFEFEF),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumeric = false, String? prefix, int? maxLength}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: _inputStyle(hint, prefix: prefix),
      maxLength: maxLength,
      validator: (val) => (val == null || val.isEmpty) ? 'Requerido' : null,
    );
  }

  Widget _buildChefTip() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1E6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tip del Chef', style: TextStyle(fontStyle: FontStyle.italic, fontFamily: 'serif', fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Mantener tu inventario al día asegura que el costo de tus recetas siempre sea preciso y tus márgenes saludables.',
                  style: TextStyle(fontSize: 11, color: const Color(0xFF4A4A4A).withOpacity(0.8), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.restaurant, color: Color(0xFFE2E2D0), size: 40),
        ],
      ),
    );
  }
}
