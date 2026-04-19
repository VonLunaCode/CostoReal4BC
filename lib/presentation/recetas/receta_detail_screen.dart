import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../data/api_generated/openapi.enums.swagger.dart' as enums;
import '../../data/api_provider.dart';
import './recetas_providers.dart';
import './widgets/gastos_ocultos_widget.dart';
import './widgets/margen_slider_widget.dart';
import './widgets/dona_chart_widget.dart';

class RecetaDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const RecetaDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RecetaDetailScreen> createState() => _RecetaDetailScreenState();
}

class _RecetaDetailScreenState extends ConsumerState<RecetaDetailScreen> {
  double _margen = 30.0;
  bool _empaqueActivo = false;
  double _empaqueValor = 0.0;
  bool _gasLuzActivo = false;
  double _gasLuzPorcentaje = 0.0;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final recetaAsync = ref.watch(recetaDetailProvider(widget.id));
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: recetaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFBC985D))),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $err'),
              ElevatedButton(
                onPressed: () => ref.invalidate(recetaDetailProvider(widget.id)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (receta) {
          final costoLocal = _calcularCostoInsumos(receta);
          
          final costoEmpaqueTotal = _empaqueActivo ? _empaqueValor : 0.0;
          final costoEnergiaTotal = _gasLuzActivo ? (costoLocal * _gasLuzPorcentaje / 100) : 0.0;
          
          final costoSubtotalPorUnidad = receta.porciones > 0 ? costoLocal / receta.porciones : 0.0;
          // Asumir que empaque y energía son totales
          final costoTotalGeneral = costoLocal + costoEmpaqueTotal + costoEnergiaTotal;
          final costoPorPorcion = receta.porciones > 0 ? costoTotalGeneral / receta.porciones : 0.0;
          
          final precioVenta = costoPorPorcion * (1 + _margen / 100);

          return CustomScrollView(
            slivers: [
              // ── APP BAR FIGMA-STYLE ──
              SliverAppBar(
                pinned: true,
                expandedHeight: 200,
                backgroundColor: const Color(0xFFF5F0E8),
                foregroundColor: const Color(0xFF2D3748),
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  title: Text(
                    receta.nombre,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      color: Color(0xFF2D3748),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  background: Container(
                    color: const Color(0xFFF5F0E8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 60, 20, 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9DCC8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${receta.porciones} porciones',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF8B6914), fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${receta.ingredientes.length} ingredientes',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF065F46), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // ── SIMULADOR BENTO ──
                    const Text('SIMULADOR DE COSTEO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB8872A), letterSpacing: 2)),
                    const SizedBox(height: 16),

                    MargenSliderWidget(
                      margen: _margen,
                      costoPorPorcion: costoPorPorcion,
                      onChanged: (val) => setState(() => _margen = val),
                    ),
                    const SizedBox(height: 16),

                    GastosOcultosWidget(
                      onGastosChanged: (emp, empVal, gas, gasPct) {
                        setState(() {
                          _empaqueActivo = emp;
                          _empaqueValor = empVal;
                          _gasLuzActivo = gas;
                          _gasLuzPorcentaje = gasPct;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── PRECIO DE VENTA SUGERIDO ──
                    _buildSuggestedPriceCard(precioVenta, costoPorPorcion, formatter),
                    const SizedBox(height: 20),

                    // ── DONA CHART ──
                    DonaChartWidget(
                      costoInsumos: costoLocal,
                      costoEmpaque: costoEmpaqueTotal,
                      costoEnergia: costoEnergiaTotal,
                      precioVenta: precioVenta,
                    ),
                    const SizedBox(height: 20),

                    // ── INGREDIENTES CLAVE ──
                    _buildIngredientesCard(receta, formatter),
                    const SizedBox(height: 20),

                    // ── PREPARACIÓN ──
                    _buildPreparacionCard(receta.pasos),
                    const SizedBox(height: 32),

                    // ── BOTÓN GUARDAR SIMULACIÓN ──
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : () => _guardarSimulacion(receta),
                        icon: _isSaving ? const SizedBox.shrink() : const Icon(Icons.save_outlined),
                        label: _isSaving 
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Guardar Simulación', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A6330),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _calcularCostoInsumos(RecetaResponse receta) {
    double costo = 0.0;
    for (final ing in receta.ingredientes) {
      final precio = double.tryParse(ing.insumo.precioCompra.toString()) ?? 0.0;
      final cantComp = double.tryParse(ing.insumo.cantidadComprada.toString()) ?? 1.0;
      final cantUsada = double.tryParse(ing.cantidadUsada.toString()) ?? 0.0;
      if (cantComp > 0) costo += (precio / cantComp) * cantUsada;
    }
    return costo > 0 ? costo : (double.tryParse(receta.costoCalculado ?? '0') ?? 0.0);
  }

  Future<void> _guardarSimulacion(RecetaResponse receta) async {
    setState(() => _isSaving = true);
    try {
      final api = ref.read(apiProvider);
      
      // Enviar empaque
      await api.apiV1RecetasIdGastosOcultosPost(
        id: receta.id,
        body: GastoOcultoCreate(
          tipo: enums.GastoOcultoCreateTipo.empaque,
          valor: _empaqueValor.toString(),
          esPorcentaje: false,
          activo: _empaqueActivo,
        ),
      );

      // Enviar gas/luz
      await api.apiV1RecetasIdGastosOcultosPost(
        id: receta.id,
        body: GastoOcultoCreate(
          tipo: enums.GastoOcultoCreateTipo.gasLuz,
          valor: _gasLuzPorcentaje.toString(),
          esPorcentaje: true,
          activo: _gasLuzActivo,
        ),
      );

      // (Opcional) Si quieres actualizar también el margen al backend,
      // necesitarías otro endpoint para actualizar margen de la receta.
      // O puedes intentar un PATCH general a la receta en un futuro.

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulación guardada con éxito'), backgroundColor: Color(0xFF6A9B7A)));
        ref.invalidate(recetaDetailProvider(widget.id));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildSuggestedPriceCard(double precioVenta, double costoPorPorcion, NumberFormat formatter) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDE8DF)),
      ),
      child: Column(
        children: [
          const Text('PRECIO SUGERIDO DE VENTA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFFA0AEC0))),
          const SizedBox(height: 8),
          Text(formatter.format(precioVenta), style: const TextStyle(fontSize: 48, fontFamily: 'Georgia', fontWeight: FontWeight.bold, color: Color(0xFF7A6330))),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFEAE8E1), borderRadius: BorderRadius.circular(20)),
            child: Text('Basado en margen del ${_margen.toInt()}%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF718096))),
          )
        ],
      ),
    );
  }

  Widget _buildIngredientesCard(RecetaResponse receta, NumberFormat formatter) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredientes Clave',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB8872A),
            ),
          ),
          const SizedBox(height: 16),
          ...receta.ingredientes.map((ing) {
            final precio = double.tryParse(ing.insumo.precioCompra.toString()) ?? 0.0;
            final cantComprada = double.tryParse(ing.insumo.cantidadComprada.toString()) ?? 1.0;
            final cantUsada = double.tryParse(ing.cantidadUsada.toString()) ?? 0.0;
            final costoIng = cantComprada > 0 ? (precio / cantComprada) * cantUsada : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${ing.insumo.nombre} (${ing.cantidadUsada}${ing.unidad})',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
                    ),
                  ),
                  Text(
                    formatter.format(costoIng),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPreparacionCard(List<PasoResponse> pasos) {
    if (pasos.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preparación',
            style: const TextStyle(fontFamily: 'Georgia', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
          ),
          const SizedBox(height: 16),
          ...pasos.map((paso) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: (paso.esCritico ?? false) ? Colors.red.shade100 : const Color(0xFFE9DCC8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      paso.orden.toString(),
                      style: TextStyle(color: (paso.esCritico ?? false) ? Colors.red : const Color(0xFFB8872A), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(paso.descripcion, style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF4A5568))),
                      if (paso.esCritico ?? false)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('PASO CRÍTICO', style: TextStyle(fontSize: 9, color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ]),
                        ),
                      if (paso.duracionSegundos != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(children: [
                            const Icon(Icons.timer_outlined, size: 12, color: Color(0xFFA0AEC0)),
                            const SizedBox(width: 4),
                            Text('${(paso.duracionSegundos! / 60).toStringAsFixed(1)} min', style: const TextStyle(fontSize: 12, color: Color(0xFFA0AEC0))),
                          ]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
