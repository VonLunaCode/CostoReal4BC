import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../alacena/alacena_screen.dart';
import './recetas_providers.dart';
import './models/receta_form_data.dart';
import './widgets/costeo_bar_widget.dart';
import './widgets/gastos_ocultos_widget.dart';
import './widgets/margen_slider_widget.dart';
import './widgets/dona_chart_widget.dart';

class RecetaFormScreen extends ConsumerStatefulWidget {
  const RecetaFormScreen({super.key});

  @override
  ConsumerState<RecetaFormScreen> createState() => _RecetaFormScreenState();
}

class _RecetaFormScreenState extends ConsumerState<RecetaFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _porcionesController = TextEditingController(text: '1');

  final List<IngredienteFormData> _ingredientes = [];
  final List<PasoFormData> _pasos = [PasoFormData()];

  bool _empaqueActivo = false;
  double _empaqueValor = 0.0;
  bool _gasLuzActivo = false;
  double _gasLuzPorcentaje = 0.0;
  double _margenSeleccionado = 30.0;

  bool _isSaving = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _porcionesController.dispose();
    super.dispose();
  }

  double _getSubtotalIngredientes() {
    double subtotal = 0.0;
    for (var ing in _ingredientes) {
      if (ing.insumo == null) continue;
      final double precioCompra = double.tryParse(ing.insumo!.precioCompra.toString()) ?? 0.0;
      final double cantidadComprada = double.tryParse(ing.insumo!.cantidadComprada.toString()) ?? 1.0;
      if (cantidadComprada == 0) continue;
      subtotal += (precioCompra / cantidadComprada) * (double.tryParse(ing.cantidad) ?? 0.0);
    }
    return subtotal;
  }

  double _getCalculatedCostoPorPorcion() {
    double subtotalIngredientes = _getSubtotalIngredientes();
    double costoTotal = subtotalIngredientes;
    if (_empaqueActivo) costoTotal += _empaqueValor;
    if (_gasLuzActivo) costoTotal += (subtotalIngredientes * _gasLuzPorcentaje / 100);
    final int porciones = int.tryParse(_porcionesController.text) ?? 1;
    return porciones > 0 ? costoTotal / porciones : 0.0;
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

    setState(() => _isSaving = true);

    try {
      final api = ref.read(apiProvider);

      final recetaData = RecetaCreate(
        nombre: _nombreController.text,
        porciones: int.parse(_porcionesController.text),
        margenPct: _margenSeleccionado.toString(),
        ingredientes: validIngredientes.map((i) => IngredienteCreate(
          insumoId: i.insumo!.id,
          cantidadUsada: i.cantidad,
          unidad: i.insumo!.unidad.value ?? 'g',
        )).toList(),
        pasos: _pasos.asMap().entries.map((entry) => PasoCreate(
          orden: entry.key + 1,
          descripcion: entry.value.descripcion,
          duracionSegundos: entry.value.duracionSegundos,
          esCritico: entry.value.esCritico,
        )).toList(),
      );

      final response = await api.apiV1RecetasPost(body: recetaData);

      if (response.isSuccessful) {
        if (mounted) {
          context.pop();
          ref.invalidate(recetasProvider);
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
                            child: const Icon(Icons.arrow_back, color: Color(0xFF4A5568)),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'KITCHY',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                              color: Color(0xFFB8872A),
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFFE9DCC8),
                        child: Icon(Icons.person, color: Color(0xFF718096), size: 20),
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
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: Color(0xFFB8872A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE8DF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: _nombreController,
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 22,
                          color: Color(0xFF4A4035),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Nombre de la Receta',
                          hintStyle: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 22,
                            color: Color(0xFFB0A898),
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
                          color: const Color(0xFFEDE8DF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PORCIONES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Color(0xFF718096))),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _porcionesController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (v) => setState(() {}),
                                    validator: (v) {
                                      if (v!.isEmpty) return 'Requerido';
                                      if (int.tryParse(v) == null || int.parse(v) <= 0) return '> 0';
                                      return null;
                                    },
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF2D3748)),
                                    decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                                  ),
                                ),
                                const Icon(Icons.restaurant, color: Color(0xFFB8872A), size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE8DF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TIEMPO EST.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Color(0xFF718096))),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text('—', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF2D3748))),
                                SizedBox(width: 4),
                                Text('min', style: TextStyle(fontSize: 14, color: Color(0xFF718096))),
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
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFB8872A)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'PRECISIÓN GRAMATINAL',
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFFB8872A), letterSpacing: 1),
                      ),
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
                      color: const Color(0xFFEDE8DF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Autocomplete<InsumoResponse>(
                      displayStringForOption: (o) => o.nombre,
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text.isEmpty) return const Iterable.empty();
                        return insumos.where((i) => i.nombre.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (selection) {
                        setState(() => _ingredientes.add(IngredienteFormData()..insumo = selection));
                      },
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Buscar ingrediente (ej. Harina de fuerza)...',
                            hintStyle: TextStyle(color: Color(0xFF9E9480), fontSize: 13),
                            prefixIcon: Icon(Icons.search, color: Color(0xFF9E9480)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        );
                      },
                    ),
                  ),
                  loading: () => const LinearProgressIndicator(color: Color(0xFFB8872A)),
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

            // ── GASTOS OCULTOS ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              sliver: SliverToBoxAdapter(
                child: GastosOcultosWidget(
                  onGastosChanged: (empaqueActivo, empaqueValor, gasLuzActivo, gasLuzPorcentaje) {
                    setState(() {
                      _empaqueActivo = empaqueActivo;
                      _empaqueValor = empaqueValor;
                      _gasLuzActivo = gasLuzActivo;
                      _gasLuzPorcentaje = gasLuzPorcentaje;
                    });
                  },
                ),
              ),
            ),

            // ── MARGEN ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverToBoxAdapter(
                child: MargenSliderWidget(
                  margen: _margenSeleccionado,
                  costoPorPorcion: _getCalculatedCostoPorPorcion(),
                  onChanged: (val) => setState(() => _margenSeleccionado = val),
                ),
              ),
            ),

            // ── DONA ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverToBoxAdapter(
                child: DonaChartWidget(
                  costoInsumos: _getSubtotalIngredientes(),
                  costoEmpaque: _empaqueActivo ? _empaqueValor : 0.0,
                  costoEnergia: _gasLuzActivo ? (_getSubtotalIngredientes() * _gasLuzPorcentaje / 100) : 0.0,
                  precioVenta: _getCalculatedCostoPorPorcion() * (1 + _margenSeleccionado / 100),
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
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _pasos.add(PasoFormData())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFB8872A)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_circle_outline, size: 14, color: Color(0xFFB8872A)),
                            SizedBox(width: 4),
                            Text('AÑADIR PASO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB8872A), letterSpacing: 1)),
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
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPasoCard(index),
                  childCount: _pasos.length,
                ),
              ),
            ),

            // ── BOTÓN GUARDAR FIGMA ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveReceta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7A6330),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        : const Text(
                            'GUARDAR RECETA',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2),
                          ),
                  ),
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
      // Barra de costeo flotante sutil (no bloquea el botón Figma)
      bottomSheet: CosteoBarWidget(
        ingredientes: _ingredientes,
        porciones: int.tryParse(_porcionesController.text) ?? 0,
        insumosDisponibles: insumosAsync.value ?? [],
        extraEmpaque: _empaqueActivo ? _empaqueValor : 0.0,
        extraGasLuzPct: _gasLuzActivo ? _gasLuzPorcentaje : 0.0,
        isSaving: _isSaving,
        onSave: _saveReceta,
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
              color: const Color(0xFFEDE8DF),
              borderRadius: BorderRadius.circular(20),
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
                    child: Icon(Icons.remove, size: 16, color: Color(0xFF4A5568)),
                  ),
                ),
                Text(
                  '${data.cantidad.isEmpty ? "0" : data.cantidad}${_getUnidadLabel(data)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3748)),
                ),
                GestureDetector(
                  onTap: () {
                    final curr = double.tryParse(data.cantidad) ?? 0;
                    setState(() => data.cantidad = (curr + 1).toStringAsFixed(0));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.add, size: 16, color: Color(0xFF4A5568)),
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
              decoration: const BoxDecoration(color: Color(0xFFFFEBEB), shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline, color: Colors.red, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _getUnidadLabel(IngredienteFormData data) {
    return data.insumo?.unidad.value ?? data.unidad;
  }

  // ── CARD DE PASO ESTILO FIGMA ──
  Widget _buildPasoCard(int index) {
    final data = _pasos[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
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
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: data.esCritico ? Colors.red.shade100 : const Color(0xFFEDE8DF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: data.esCritico ? Colors.red : const Color(0xFFB8872A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // TextField descripción
                Expanded(
                  child: TextFormField(
                    initialValue: data.descripcion,
                    onChanged: (v) => data.descripcion = v,
                    validator: (v) => (v == null || v.length < 5) ? 'Mínimo 5 caracteres' : null,
                    maxLines: null,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568), height: 1.5),
                    decoration: const InputDecoration(
                      hintText: 'Describe este paso...',
                      hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                // Ícono reordenar
                const Icon(Icons.drag_indicator, color: Color(0xFFCBD5E0), size: 20),
              ],
            ),
          ),

          // Footer del paso: PASO CRÍTICO + eliminar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Text(
                  'PASO CRÍTICO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: data.esCritico ? Colors.red : const Color(0xFFB8872A),
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: data.esCritico,
                  activeColor: Colors.red.shade400,
                  inactiveThumbColor: const Color(0xFFCBD5E0),
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (v) => setState(() => data.esCritico = v),
                ),
                const Spacer(),
                if (_pasos.length > 1)
                  GestureDetector(
                    onTap: () => setState(() => _pasos.removeAt(index)),
                    child: const Icon(Icons.delete_outline, color: Color(0xFFCBD5E0), size: 18),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
