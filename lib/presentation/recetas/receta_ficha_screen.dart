import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import './recetas_providers.dart';

class RecetaFichaScreen extends ConsumerStatefulWidget {
  final String id;
  const RecetaFichaScreen({super.key, required this.id});

  @override
  ConsumerState<RecetaFichaScreen> createState() => _RecetaFichaScreenState();
}

class _RecetaFichaScreenState extends ConsumerState<RecetaFichaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recetaAsync = ref.watch(recetaDetailProvider(widget.id));

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      body: recetaAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFBC985D)),
        ),
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
        data: (receta) => _buildContent(receta),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/recetas/${widget.id}/simulador'),
        backgroundColor: const Color(0xFF7A613E),
        icon: const Icon(Icons.calculate_outlined, color: Colors.white),
        label: const Text(
          'SIMULAR RENTABILIDAD',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(RecetaResponse receta) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverToBoxAdapter(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar manual con flecha y lápiz
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.arrow_back, color: Color(0xFF7A613E)),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final updated = await context.push<bool>(
                            '/recetas/${widget.id}/editar',
                            extra: receta,
                          );
                          if (updated == true) {
                            ref.invalidate(recetaDetailProvider(widget.id));
                          }
                        },
                        child: const Icon(Icons.edit_outlined, color: Color(0xFF7A613E)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Título
                  Text(
                    receta.nombre,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2623),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Chip de porciones
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EAD5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'RINDE: ${receta.porciones} PORCIONES',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB8872A),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarDelegate(
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFBC985D),
              indicatorWeight: 3,
              labelColor: const Color(0xFF2C2623),
              unselectedLabelColor: const Color(0xFFA0AEC0),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(text: 'Ingredientes'),
                Tab(text: 'Preparación'),
              ],
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [
          _TabIngredientes(receta: receta),
          _TabPreparacion(receta: receta),
        ],
      ),
    );
  }
}

// Delegate para el TabBar sticky
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFFBF9F4),
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

// ── TAB 1: INGREDIENTES ──
class _TabIngredientes extends StatelessWidget {
  final RecetaResponse receta;
  const _TabIngredientes({required this.receta});

  @override
  Widget build(BuildContext context) {
    final ingredientes = receta.ingredientes;

    if (ingredientes.isEmpty) {
      return const Center(child: Text('Sin ingredientes registrados'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      itemCount: ingredientes.length,
      separatorBuilder: (_, __) => const Divider(color: Color(0xFFEBE6D9), height: 1),
      itemBuilder: (context, index) {
        final ing = ingredientes[index];
        final cantRaw = double.tryParse(ing.cantidadUsada.toString()) ?? 0.0;
        final cantDisplay = cantRaw == cantRaw.truncateToDouble()
            ? cantRaw.toInt().toString()
            : cantRaw.toString();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F2EA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.inventory_2_outlined, size: 18, color: Color(0xFF7A613E)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  ing.insumo.nombre,
                  style: const TextStyle(fontSize: 15, color: Color(0xFF2C2623)),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$cantDisplay ',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2623),
                      ),
                    ),
                    TextSpan(
                      text: ing.unidad,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7A613E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── TAB 2: PREPARACIÓN ──
class _TabPreparacion extends StatelessWidget {
  final RecetaResponse receta;
  const _TabPreparacion({required this.receta});

  @override
  Widget build(BuildContext context) {
    final pasos = receta.pasos;

    if (pasos.isEmpty) {
      return const Center(child: Text('Sin pasos de preparación'));
    }

    // Ordenar por paso.orden
    final sorted = [...pasos]..sort((a, b) => a.orden.compareTo(b.orden));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final paso = sorted[index];
        final durSeg = paso.duracionSegundos;
        final minutos = (durSeg != null && durSeg != 0)
            ? (durSeg is int ? durSeg ~/ 60 : (durSeg as num).toInt() ~/ 60)
            : null;
        final esCritico = paso.esCritico ?? false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Número de paso (círculo dorado)
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFBC985D),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${paso.orden}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chips de tiempo y paso crítico
                    Row(
                      children: [
                        if (minutos != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF5FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$minutos MIN',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B6CB0),
                              ),
                            ),
                          ),
                        if (minutos != null && esCritico) const SizedBox(width: 6),
                        if (esCritico)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE8E8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'PASO CRÍTICO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC2626),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (minutos != null || esCritico) const SizedBox(height: 8),
                    // Descripción del paso
                    Text(
                      paso.descripcion,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
