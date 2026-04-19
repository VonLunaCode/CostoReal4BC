import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import './recetas_providers.dart';

class RecetaDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const RecetaDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RecetaDetailScreen> createState() => _RecetaDetailScreenState();
}

class _RecetaDetailScreenState extends ConsumerState<RecetaDetailScreen> {
  double _margen = 50.0;

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
          // Calcular costo localmente desde los ingredientes (costoCalculado del
          // backend puede llegar nulo o en cero para recetas recién creadas).
          double costoLocal = 0.0;
          for (final ing in receta.ingredientes) {
            final precio    = double.tryParse(ing.insumo.precioCompra.toString())     ?? 0.0;
            final cantComp  = double.tryParse(ing.insumo.cantidadComprada.toString()) ?? 1.0;
            final cantUsada = double.tryParse(ing.cantidadUsada.toString())           ?? 0.0;
            if (cantComp > 0) costoLocal += (precio / cantComp) * cantUsada;
          }
          // Fallback a costoCalculado si no hay ingredientes detallados.
          final costoTotal = costoLocal > 0
              ? costoLocal
              : (double.tryParse(receta.costoCalculado ?? '0') ?? 0.0);
          final costoPorPorcion = receta.porciones > 0 ? costoTotal / receta.porciones : 0.0;
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

                    // ── GRÁFICA DE DONA ──
                    _buildDonaCard(costoPorPorcion, precioVenta, formatter),
                    const SizedBox(height: 20),

                    // ── INGREDIENTES CLAVE ──
                    _buildIngredientesCard(receta, formatter),
                    const SizedBox(height: 20),

                    // ── SIMULADOR DE COSTEO ──
                    _buildSimuladorCard(costoPorPorcion, precioVenta, formatter),
                    const SizedBox(height: 20),

                    // ── PREPARACIÓN ──
                    _buildPreparacionCard(receta.pasos),
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

  Widget _buildDonaCard(double costoPorPorcion, double precioVenta, NumberFormat formatter) {
    final ganancia = precioVenta - costoPorPorcion;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF4A7C6F), // Verde (utilidad)
                        value: ganancia > 0 ? ganancia : 0.01,
                        title: '',
                        radius: 40,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFFB8872A), // Dorado (insumos)
                        value: costoPorPorcion * 0.7,
                        title: '',
                        radius: 40,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFF2D3748), // Oscuro (labor)
                        value: costoPorPorcion * 0.3,
                        title: '',
                        radius: 40,
                      ),
                    ],
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 400),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('VENTA FINAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Color(0xFF718096))),
                    const SizedBox(height: 4),
                    Text(
                      formatter.format(precioVenta),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2D3748)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(const Color(0xFFB8872A), 'INSUMOS'),
              const SizedBox(width: 16),
              _legendDot(const Color(0xFF2D3748), 'LABOR'),
              const SizedBox(width: 16),
              _legendDot(const Color(0xFF4A7C6F), 'UTILIDAD'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF718096), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ],
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

  Widget _buildSimuladorCard(double costoPorPorcion, double precioVenta, NumberFormat formatter) {
    final ganancia = precioVenta - costoPorPorcion;
    final esPerdida = precioVenta < costoPorPorcion && costoPorPorcion > 0;

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
            'Simulador de Costeo',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB8872A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('MARGEN DE GANANCIA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1, color: Color(0xFF718096))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFB8872A), borderRadius: BorderRadius.circular(20)),
                child: Text('${_margen.toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFB8872A),
              inactiveTrackColor: const Color(0xFFE9DCC8),
              thumbColor: const Color(0xFFB8872A),
              overlayColor: const Color(0xFFB8872A).withOpacity(0.2),
            ),
            child: Slider(
              value: _margen,
              min: 0,
              max: 200,
              divisions: 200,
              onChanged: (val) => setState(() => _margen = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('30%', style: TextStyle(fontSize: 10, color: Color(0xFFA0AEC0))),
                Text('50%', style: TextStyle(fontSize: 10, color: Color(0xFFA0AEC0))),
                Text('100%', style: TextStyle(fontSize: 10, color: Color(0xFFA0AEC0))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Ganancia neta', style: TextStyle(fontSize: 11, color: Color(0xFF718096))),
                Text(formatter.format(ganancia), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: esPerdida ? Colors.red : const Color(0xFF2D8A52))),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text('Precio de venta', style: TextStyle(fontSize: 11, color: Color(0xFF718096))),
                Text(formatter.format(precioVenta), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFB8872A))),
              ]),
            ],
          ),
          if (esPerdida)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('⚠️ Precio de venta a pérdida — revisa tu costeo', style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
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
