import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../alacena/alacena_screen.dart';
import './recetas_providers.dart';
import './models/receta_form_data.dart';
import 'package:decimal/decimal.dart';

class RecetaFormScreen extends ConsumerStatefulWidget {
  final RecetaResponse? recetaExistente;
  const RecetaFormScreen({super.key, this.recetaExistente});

  @override
  ConsumerState<RecetaFormScreen> createState() => _RecetaFormScreenState();
}

class _RecetaFormScreenState extends ConsumerState<RecetaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _porcionesController = TextEditingController(text: '1');

  final List<IngredienteFormData> _ingredientes = [];
  final List<PasoFormData> _pasos = [PasoFormData()];

  bool _isSaving = false;
  TextEditingController? _autocompleteController;
  late final String _initialNombre;
  late final int _initialPorciones;

  @override
  void initState() {
    super.initState();
    if (widget.recetaExistente != null) {
      final r = widget.recetaExistente!;
      _nombreController.text = r.nombre;
      _porcionesController.text = r.porciones.toString();
      
      _ingredientes.clear();
      for (var i in r.ingredientes) {
        _ingredientes.add(IngredienteFormData()
          ..insumo = i.insumo
          ..cantidad = i.cantidadUsada
          ..unidad = i.unidad
          ..unidadInput = i.unidad);
      }
      
      _pasos.clear();
      for (var p in r.pasos) {
        _pasos.add(PasoFormData()
          ..descripcion = p.descripcion
          ..duracionSegundos = p.duracionSegundos
          ..esCritico = p.esCritico ?? false);
      }
    }

    _initialNombre = widget.recetaExistente?.nombre ?? '';
    _initialPorciones = widget.recetaExistente?.porciones ?? 1;
    
    _nombreController.addListener(() => setState(() {}));
    _porcionesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _porcionesController.dispose();
    super.dispose();
  }

  bool _isDirty() {
    if (widget.recetaExistente == null) {
      return _nombreController.text.isNotEmpty || _ingredientes.isNotEmpty;
    }
    
    final currentValues = _nombreController.text + 
                        _porcionesController.text + 
                        _ingredientes.map((i) => "${i.cantidad}${i.unidadInput}").join() +
                        _pasos.map((p) => p.descripcion).join();
    
    final initialValues = _initialNombre + 
                         _initialPorciones.toString() + 
                         (widget.recetaExistente?.ingredientes.map((i) => "${i.cantidadUsada}${i.unidad}").join() ?? '') +
                         (widget.recetaExistente?.pasos.map((p) => p.descripcion).join() ?? '');

    return currentValues != initialValues;
  }

  String _formatNumber(String value) {
    final n = double.tryParse(value) ?? 0.0;
    return n == n.toInt() ? n.toInt().toString() : n.toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '');
  }

  int _getTotalTime() {
    return _pasos.fold(0, (sum, paso) => sum + (paso.duracionSegundos != null ? (paso.duracionSegundos! ~/ 60) : 0));
  }

  Future<void> _saveReceta() async {
    if (!_formKey.currentState!.validate()) return;

    final validIngredientes = _ingredientes.where((i) => i.insumo != null).toList();
    if (validIngredientes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, añade al menos un ingrediente válido.')),
      );
      return;
    }

    // VALIDACIÓN: Evitar duplicados de insumo_id
    final insumoIds = validIngredientes.map((i) => i.insumo!.id).toSet();
    if (insumoIds.length < validIngredientes.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puedes añadir el mismo ingrediente dos veces. Ajusta la cantidad en uno solo.'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() => _isSaving = false);
      return;
    }

    try {
      final api = ref.read(apiProvider);
      final ingredientesData = validIngredientes.map((i) {
        // Usar Decimal para precisión financiera
        Decimal cantDecimal = Decimal.tryParse(i.cantidad) ?? Decimal.zero;
        
        if (i.unidadInput == 'g' || i.unidadInput == 'ml') {
          cantDecimal = (cantDecimal / Decimal.fromInt(1000)).toDecimal();
        }
        
        return IngredienteCreate(
          insumoId: i.insumo!.id,
          cantidadUsada: cantDecimal.toStringAsFixed(4),
          unidad: (i.insumo!.unidad.value ?? '').toUpperCase(),
        );
      }).toList();

      final pasosData = _pasos.asMap().entries.map((entry) {
        final duracion = (entry.value.duracionSegundos ?? 0) > 0 
            ? entry.value.duracionSegundos 
            : null;

        return PasoCreate(
          orden: entry.key + 1,
          descripcion: entry.value.descripcion,
          duracionSegundos: duracion,
          esCritico: entry.value.esCritico,
        );
      }).toList();

      final response;
      // El backend espera margen_pct como String con decimales (visto en logs previos)
      final String margenStr = Decimal.parse('30.0').toStringAsFixed(2);

      if (widget.recetaExistente != null) {
        final body = RecetaUpdate(
          nombre: _nombreController.text,
          porciones: int.tryParse(_porcionesController.text) ?? 1,
          margenPct: margenStr, 
          ingredientes: ingredientesData,
          pasos: pasosData,
        );
        debugPrint('DEBUG RECETA UPDATE (V3): ${jsonEncode(body.toJson())}');
        response = await api.apiV1RecetasIdPut(
          id: widget.recetaExistente!.id,
          body: body,
        );
      } else {
        final body = RecetaCreate(
          nombre: _nombreController.text,
          porciones: int.tryParse(_porcionesController.text) ?? 1,
          margenPct: margenStr,
          ingredientes: ingredientesData,
          pasos: pasosData,
        );
        debugPrint('DEBUG RECETA CREATE (V3): ${jsonEncode(body.toJson())}');
        response = await api.apiV1RecetasPost(body: body);
      }

      setState(() => _isSaving = false);

      if (response.isSuccessful) {
        if (mounted) {
          ref.invalidate(recetasProvider);
          if (widget.recetaExistente != null) {
            // Invalidar específicamente esta receta para que el detalle se refresque
            ref.invalidate(recetaDetailProvider(widget.recetaExistente!.id));
          }
          context.pop();
        }
      } else {
        throw Exception(response.error ?? 'Error al guardar');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final insumosAsync = ref.watch(alacenaProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            // ── HEADER FIGMA ──
            SliverToBoxAdapter(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Icon(Icons.arrow_back, color: Color(0xFF7A613E)), 
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.restaurant, color: Color(0xFF7A613E), size: 20),
                          const SizedBox(width: 4),
                          const Text(
                            'KITCHY',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                              color: Color(0xFF7A613E),
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFF2C2623),
                        child: Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── NOMBRE DE LA RECETA ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CREAR NUEVA OBRA',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: Color(0xFF7A613E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F2EA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: _nombreController,
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontStyle: FontStyle.italic,
                          fontSize: 28,
                          color: Color(0xFF2C2623),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Nombre de la Receta',
                          hintStyle: TextStyle(
                            fontFamily: 'Georgia',
                            fontStyle: FontStyle.italic,
                            fontSize: 28,
                            color: Color(0xFFD5D1C6),
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── PORCIONES / TIEMPO ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F2EA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -10,
                              top: -10,
                              child: Icon(Icons.people_alt, size: 70, color: const Color(0xFF7A613E).withOpacity(0.05)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('PORCIONES', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.0, color: Color(0xFF807667))),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: _porcionesController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (v) => setState(() {}),
                                  validator: (v) {
                                    if (v!.isEmpty) return 'Requerido';
                                    if (int.tryParse(v) == null || int.parse(v) <= 0) return '> 0';
                                    return null;
                                  },
                                  style: const TextStyle(fontFamily: 'Georgia', fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF7A613E)),
                                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F2EA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -10,
                              top: 0,
                              child: Icon(Icons.schedule, size: 60, color: const Color(0xFF7A613E).withOpacity(0.05)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('TIEMPO EST.', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.0, color: Color(0xFF807667))),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text('${_getTotalTime()}', style: const TextStyle(fontFamily: 'Georgia', fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF7A613E))),
                                    const SizedBox(width: 4),
                                    const Text('min', style: TextStyle(fontSize: 12, color: Color(0xFF807667))),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── INGREDIENTES ──
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2623),
                      ),
                    ),
                    Text(
                      'PRECISIÓN GARANTIZADA',
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFFA0AEC0), letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ),

            // Buscador de ingrediente
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              sliver: SliverToBoxAdapter(
                child: insumosAsync.when(
                  data: (insumos) => Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBE6D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Autocomplete<InsumoResponse>(
                      displayStringForOption: (o) => o.nombre,
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text.isEmpty) return const Iterable.empty();
                        return insumos.where((i) => i.nombre.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (selection) {
                        final baseUnit = selection.unidad.value ?? 'pz';
                        setState(() => _ingredientes.add(
                          IngredienteFormData()
                            ..insumo = selection
                            ..unidad = baseUnit
                            ..unidadInput = baseUnit,
                        ));
                        _autocompleteController?.clear();
                      },
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        _autocompleteController = controller;
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Buscar ingrediente (ej. Harina de fuerza)...',
                            hintStyle: TextStyle(color: Color(0xFF807667), fontSize: 13),
                            prefixIcon: Icon(Icons.search, color: Color(0xFF807667)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(16),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    leading: const Icon(Icons.inventory_2_outlined, size: 18, color: Color(0xFF7A613E)),
                                    title: Text(option.nombre, style: const TextStyle(fontSize: 14)),
                                    subtitle: Text(option.unidad.value ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF807667))),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  loading: () => const LinearProgressIndicator(color: Color(0xFF7A613E)),
                  error: (e, s) => const Text('Error al cargar insumos'),
                ),
              ),
            ),

            // Cards de ingredientes
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildIngredienteCard(index),
                  childCount: _ingredientes.length,
                ),
              ),
            ),

            // ── PREPARACIÓN ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Preparación',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2623),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _pasos.add(PasoFormData())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBE6D9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_circle_outline, size: 14, color: Color(0xFF7A613E)),
                            SizedBox(width: 4),
                            Text('AÑADIR PASO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF7A613E), letterSpacing: 1)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              sliver: SliverReorderableList(
                itemBuilder: (context, index) => ReorderableDragStartListener(
                  key: ValueKey('step_$index'),
                  index: index,
                  child: _buildPasoCard(index),
                ),
                itemCount: _pasos.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _pasos.removeAt(oldIndex);
                    _pasos.insert(newIndex, item);
                  });
                },
              ),
            ),

            // ── BOTÓN GUARDAR FIGMA ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (_isSaving || !_isDirty()) ? null : _saveReceta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A613E),
                        disabledBackgroundColor: const Color(0xFFD5D1C6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : const Text(
                              'GUARDAR RECETA',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  // ── CARD DE INGREDIENTE ESTILO FIGMA ──
  Widget _buildIngredienteCard(int index) {
    final data = _ingredientes[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Info del insumo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.insumo?.nombre ?? 'Ingrediente ${index + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: data.insumo != null ? const Color(0xFF2D3748) : const Color(0xFFA0AEC0),
                  ),
                ),
                if (data.insumo != null)
                  Text(
                    (data.insumo!.unidad.value ?? '').toUpperCase(),
                    style: const TextStyle(fontSize: 10, color: Color(0xFF718096), letterSpacing: 0.5),
                  ),
              ],
            ),
          ),

          // Stepper oval estilo Figma
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEBE6D9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    final curr = double.tryParse(data.cantidad) ?? 0;
                    if (curr > 0) setState(() => data.cantidad = (curr - 1).toStringAsFixed(0));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.remove, size: 16, color: Color(0xFF8B6B3D)),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2623)),
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                    controller: TextEditingController(text: _formatNumber(data.cantidad)),
                    onChanged: (v) => setState(() => data.cantidad = v),
                  ),
                ),
                _buildUnidadDropdown(data),
                GestureDetector(
                  onTap: () {
                    final curr = double.tryParse(data.cantidad) ?? 0;
                    setState(() => data.cantidad = (curr + 1).toStringAsFixed(0));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.add, size: 16, color: Color(0xFF8B6B3D)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Botón eliminar
          GestureDetector(
            onTap: () => setState(() => _ingredientes.removeAt(index)),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnidadDropdown(IngredienteFormData data) {
    final base = data.insumo?.unidad.value ?? '';
    final opciones = _getOpcionesUnidad(base);
    if (opciones.length <= 1) {
      return Text(base, style: const TextStyle(fontSize: 11, color: Color(0xFF8B6B3D)));
    }
    return DropdownButton<String>(
      value: opciones.contains(data.unidadInput) ? data.unidadInput : base,
      underline: const SizedBox(),
      isDense: true,
      style: const TextStyle(fontSize: 11, color: Color(0xFF8B6B3D), fontWeight: FontWeight.w600),
      items: opciones.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
      onChanged: (val) {
        if (val == null || val == data.unidadInput) return;
        setState(() {
          final oldVal = double.tryParse(data.cantidad) ?? 0.0;
          if (data.unidadInput == 'kg' && val == 'g') data.cantidad = (oldVal * 1000).toString();
          if (data.unidadInput == 'g' && val == 'kg') data.cantidad = (oldVal / 1000).toString();
          if (data.unidadInput == 'l' && val == 'ml') data.cantidad = (oldVal * 1000).toString();
          if (data.unidadInput == 'ml' && val == 'l') data.cantidad = (oldVal / 1000).toString();
          data.unidadInput = val;
        });
      },
    );
  }

  List<String> _getOpcionesUnidad(String base) {
    if (base == 'kg') return ['kg', 'g'];
    if (base == 'l') return ['l', 'ml'];
    return [base];
  }

  // ── CARD DE PASO ESTILO FIGMA ──
  Widget _buildPasoCard(int index) {
    final data = _pasos[index];

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F2EA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Número del paso
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: index == 0 ? const Color(0xFF7A613E) : const Color(0xFFD5D1C6),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: index == 0 ? Colors.white : const Color(0xFF7A613E),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // TextField descripción
                Expanded(
                  child: TextFormField(
                    initialValue: data.descripcion,
                    onChanged: (v) => setState(() => data.descripcion = v),
                    validator: (v) => (v == null || v.length < 5) ? 'Mínimo 5 caracteres' : null,
                    maxLines: null,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF4A4A4A), height: 1.5, fontWeight: FontWeight.normal),
                    decoration: const InputDecoration(
                      hintText: 'Describe este paso...',
                      hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer del paso: PASO CRÍTICO + eliminar
          Padding(
            padding: const EdgeInsets.fromLTRB(52, 0, 16, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE6D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF2C2623)),
                      const SizedBox(width: 6),
                      const Text('DURACIÓN', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF2C2623), letterSpacing: 0.5)),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 25,
                        child: TextFormField(
                          initialValue: data.duracionSegundos != null ? (data.duracionSegundos! ~/ 60).toString() : '',
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7A613E)),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '0',
                          ),
                          onChanged: (v) {
                            setState(() {
                              data.duracionSegundos = int.tryParse(v) != null ? int.parse(v) * 60 : null;
                            });
                          },
                        ),
                      ),
                      const Text('min', style: TextStyle(fontSize: 10, color: Color(0xFF7A613E))),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  children: [
                    Text(
                      'PASO',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9E3A3A), // Reddish
                      ),
                    ),
                    Text(
                      'CRÍTICO',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9E3A3A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 20,
                  width: 36,
                  child: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: data.esCritico,
                      activeColor: Colors.white,
                      activeTrackColor: const Color(0xFF7A613E),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFFD5D1C6),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (v) => setState(() => data.esCritico = v),
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.drag_indicator, color: Color(0xFF807667), size: 20),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
