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
  bool _isInitialized = false;

  void _initializeState(RecetaResponse receta) {
    if (_isInitialized) return;
    
    _margen = double.tryParse(receta.margenPct.toString()) ?? 30.0;
    
    for (var gasto in receta.gastosOcultos) {
      if (gasto.tipo == enums.GastoOcultoResponseTipo.empaque) {
        _empaqueActivo = gasto.activo ?? false;
        _empaqueValor = double.tryParse(gasto.valor) ?? 0.0;
      } else if (gasto.tipo == enums.GastoOcultoResponseTipo.gasLuz) {
        _gasLuzActivo = gasto.activo ?? false;
        _gasLuzPorcentaje = double.tryParse(gasto.valor) ?? 0.0;
      }
    }
    
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final recetaAsync = ref.watch(recetaDetailProvider(widget.id));
    
    // Inicializar estado una vez que la receta cargue
    recetaAsync.whenData((receta) => _initializeState(receta));
    
    final formatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
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
              // ── CABECERA KITCHY ──
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
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
                        const SizedBox(height: 32),
                        const Text(
                          'SIMULADOR DE COSTEO',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Color(0xFF7A613E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          receta.nombre,
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2623),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Última actualización: 12 Oct, 2023',
                          style: TextStyle(fontSize: 10, color: Color(0xFF807667)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([


                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F2EA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.tune, color: Color(0xFF7A613E), size: 16),
                              SizedBox(width: 8),
                              Text(
                                'Parámetros de Simulación',
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2623),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Número de porciones
                          const Text('Número de Porciones', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF4A4035))),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(color: const Color(0xFFEBE6D9), borderRadius: BorderRadius.circular(8)),
                            child: Text('${receta.porciones}', style: const TextStyle(fontSize: 14, color: Color(0xFF2C2623))),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFEBE6D9), thickness: 1),
                          const SizedBox(height: 24),

                          MargenSliderWidget(
                            margen: _margen,
                            costoPorPorcion: costoPorPorcion,
                            onChanged: (val) => setState(() => _margen = val),
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xFFEBE6D9), thickness: 1),
                          const SizedBox(height: 16),

                          GastosOcultosWidget(
                            initialEmpaqueActivo: _empaqueActivo,
                            initialEmpaqueValor: _empaqueValor,
                            initialGasLuzActivo: _gasLuzActivo,
                            initialGasLuzPorcentaje: _gasLuzPorcentaje,
                            onGastosChanged: (emp, empVal, gas, gasPct) {
                              setState(() {
                                _empaqueActivo = emp;
                                _empaqueValor = empVal;
                                _gasLuzActivo = gas;
                                _gasLuzPorcentaje = gasPct;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── DESGLOSE DE COSTOS ──
                    _buildDesgloseCostos(costoLocal, costoEmpaqueTotal, costoEnergiaTotal, costoTotalGeneral, formatter),
                    const SizedBox(height: 20),

                    // ── PRECIO DE VENTA SUGERIDO ──
                    _buildSuggestedPriceCard(precioVenta, costoPorPorcion, formatter),
                    const SizedBox(height: 20),

                    // ── DONA CHART ──
                    DonaChartWidget(
                      costoInsumos: receta.porciones > 0 ? costoLocal / receta.porciones : costoLocal,
                      costoEmpaque: receta.porciones > 0 ? costoEmpaqueTotal / receta.porciones : costoEmpaqueTotal,
                      costoEnergia: receta.porciones > 0 ? costoEnergiaTotal / receta.porciones : costoEnergiaTotal,
                      precioVenta: precioVenta,
                    ),
                    const SizedBox(height: 32),

                    // ── BOTÓN GUARDAR SIMULACIÓN ──
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : () => _guardarSimulacion(receta),
                          icon: _isSaving ? const SizedBox.shrink() : const Icon(Icons.save_outlined, size: 16),
                          label: _isSaving 
                              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              : const Text('Guardar Simulación', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7A613E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            elevation: 0,
                          ),
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

  // Convierte cantidadUsada a la misma unidad base que cantidadComprada del insumo.
  // El form ya normaliza al guardar, pero esto protege contra datos creados por API directamente.
  double _factorConversion(String unidadInsumo, String unidadIngrediente) {
    final base = unidadInsumo.toLowerCase();
    final uso = unidadIngrediente.toLowerCase();
    if (base == uso) return 1.0;
    if (base == 'kg' && uso == 'g') return 0.001;
    if (base == 'g' && uso == 'kg') return 1000.0;
    if (base == 'l' && uso == 'ml') return 0.001;
    if (base == 'ml' && uso == 'l') return 1000.0;
    return 1.0;
  }

  double _calcularCostoInsumos(RecetaResponse receta) {
    double costo = 0.0;
    for (final ing in receta.ingredientes) {
      final precio = double.tryParse(ing.insumo.precioCompra.toString()) ?? 0.0;
      final cantComp = double.tryParse(ing.insumo.cantidadComprada.toString()) ?? 1.0;
      final cantUsadaRaw = double.tryParse(ing.cantidadUsada.toString()) ?? 0.0;
      final factor = _factorConversion(
        ing.insumo.unidad.value ?? '',
        ing.unidad,
      );
      final cantUsada = cantUsadaRaw * factor;
      if (cantComp > 0) costo += (precio / cantComp) * cantUsada;
    }
    return costo > 0
        ? costo
        : (double.tryParse(receta.costoPorPorcion?.toString() ?? '0') ?? 0.0) *
            (receta.porciones > 0 ? receta.porciones : 1);
  }

  Future<void> _guardarSimulacion(RecetaResponse receta) async {
    setState(() => _isSaving = true);
    try {
      final api = ref.read(apiProvider);
      
      // Orquestar las 3 peticiones en paralelo
      await Future.wait([
        // 1. Actualizar el Margen de la receta
        api.apiV1RecetasIdPut(
          id: receta.id,
          body: RecetaUpdate(
            margenPct: _margen.toString(),
          ),
        ),
        
        // 2. Actualizar Gasto de Empaque
        api.apiV1RecetasIdGastosOcultosPost(
          id: receta.id,
          body: GastoOcultoCreate(
            tipo: enums.GastoOcultoCreateTipo.empaque,
            valor: _empaqueValor.toString(),
            esPorcentaje: false,
            activo: _empaqueActivo,
          ),
        ),

        // 3. Actualizar Gasto de Gas/Luz (Energías)
        api.apiV1RecetasIdGastosOcultosPost(
          id: receta.id,
          body: GastoOcultoCreate(
            tipo: enums.GastoOcultoCreateTipo.gasLuz,
            valor: _gasLuzPorcentaje.toString(),
            esPorcentaje: true,
            activo: _gasLuzActivo,
          ),
        ),
      ]);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Simulación y parámetros guardados con éxito'), 
            backgroundColor: Color(0xFF16A34A)
          )
        );
        ref.invalidate(recetaDetailProvider(widget.id));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la simulación: $e'),
            backgroundColor: const Color(0xFFDC2626),
          )
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildDesgloseCostos(double insumos, double empaque, double energia, double total, NumberFormat fmt) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF5F2EA), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Color(0xFF807667), size: 16),
              const SizedBox(width: 8),
              const Text('Desglose de Costos de Producción', style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2623))),
            ],
          ),
          const SizedBox(height: 16),
          _buildDesgloseRow('Costo de Insumos', fmt.format(insumos)),
          const SizedBox(height: 12),
          _buildDesgloseRow('Costo de Empaque', fmt.format(empaque)),
          const SizedBox(height: 12),
          _buildDesgloseRow('Costo de Energía', fmt.format(energia)),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFEBE6D9), thickness: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Costo Total de Producción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF2C2623))),
              Text(fmt.format(total), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF7A613E))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesgloseRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF807667))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF2C2623))),
      ],
    );
  }

  Widget _buildSuggestedPriceCard(double precioVenta, double costoPorPorcion, NumberFormat formatter) {
    final double bruts = precioVenta - costoPorPorcion;
    
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
              colors: [Color(0xFFEBE6D9), Color(0xFFFBF9F4)]
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2D9C5), width: 1),
          ),
          child: Column(
            children: [
              const Text(
                'PRECIO SUGERIDO DE VENTA', 
                style: TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.w800, 
                  letterSpacing: 2.0, 
                  color: Color(0xFF807667)
                )
              ),
              const SizedBox(height: 16),
              Text(
                formatter.format(precioVenta), 
                style: const TextStyle(
                  fontSize: 54, 
                  fontFamily: 'Georgia', 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFF7A613E),
                  letterSpacing: -1,
                )
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A613E).withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(
                  'Basado en margen del ${_margen.toInt()}%', 
                  style: const TextStyle(
                    fontSize: 11, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF7A613E)
                  )
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Costo por Porción', 
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF718096))
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatter.format(costoPorPorcion), 
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w900, 
                        color: Color(0xFF4A5568)
                      )
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4), 
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDCFCE7), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Utilidad Bruta', 
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534))
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatter.format(bruts), 
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w900, 
                        color: Color(0xFF22C55E) // Verde Brillante
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
