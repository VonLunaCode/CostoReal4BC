import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'puntos_entrega_providers.dart';
import '../../data/api_generated/openapi.models.swagger.dart';

class PuntoEntregaFormScreen extends ConsumerStatefulWidget {
  final PuntoEntregaRead? punto;

  const PuntoEntregaFormScreen({super.key, this.punto});

  @override
  ConsumerState<PuntoEntregaFormScreen> createState() => _PuntoEntregaFormScreenState();
}

class _PuntoEntregaFormScreenState extends ConsumerState<PuntoEntregaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _direccionController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.punto?.nombre);
    _descripcionController = TextEditingController(text: widget.punto?.descripcion);
    _direccionController = TextEditingController(text: widget.punto?.direccion);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.punto != null;
    final notifierStatus = ref.watch(puntoEntregaNotifierProvider);

    // Escuchar cambios en el estado para cerrar al completar con éxito
    ref.listen(puntoEntregaNotifierProvider, (previous, next) {
      if (next is AsyncData && previous is AsyncLoading) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Punto actualizado correctamente' : 'Punto creado correctamente',
            ),
            backgroundColor: const Color(0xFF7A613E),
          ),
        );
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: const Color(0xFFC53030),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          isEditing ? 'Editar Punto' : 'Nuevo Punto',
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2623),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Nombre del Punto *'),
              TextFormField(
                controller: _nombreController,
                decoration: _buildInputDecoration('Ej: Casa, Oficina, Gimnasio...'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildLabel('Dirección (opcional)'),
              TextFormField(
                controller: _direccionController,
                maxLines: 2,
                decoration: _buildInputDecoration('Dirección completa para Maps/Waze'),
              ),
              const SizedBox(height: 24),
              _buildLabel('Descripción (opcional)'),
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: _buildInputDecoration('Indicaciones adicionales, timbre, etc.'),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: notifierStatus is AsyncLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A613E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: notifierStatus is AsyncLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          isEditing ? 'Guardar Cambios' : 'Crear Punto de Entrega',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7A613E),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFD5D1C6), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7A613E), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFC53030), width: 1),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim().isEmpty ? null : _descripcionController.text.trim();
    final direccion = _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim();

    if (widget.punto != null) {
      ref.read(puntoEntregaNotifierProvider.notifier).update(
            widget.punto!.id,
            PuntoEntregaUpdate(
              nombre: nombre,
              descripcion: descripcion,
              direccion: direccion,
            ),
          );
    } else {
      ref.read(puntoEntregaNotifierProvider.notifier).create(
            PuntoEntregaCreate(
              nombre: nombre,
              descripcion: descripcion,
              direccion: direccion,
            ),
          );
    }
  }
}
