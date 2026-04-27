import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../data/api_provider.dart';

import '../widgets/kitchy_bottom_nav.dart';
import './recetas_providers.dart';

class RecetasListScreen extends ConsumerStatefulWidget {
  const RecetasListScreen({super.key});

  @override
  ConsumerState<RecetasListScreen> createState() => _RecetasListScreenState();
}

class _RecetasListScreenState extends ConsumerState<RecetasListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recetasAsync = ref.watch(recetasProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'KITCHY',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3,
                            color: Color(0xFFB8872A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Recetario Propio',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/perfil'),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFE2D9C5),
                      child: Icon(Icons.person, color: Color(0xFF718096)),
                    ),
                  ),
                ],
              ),
            ),

            // ── SEARCH BAR ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Buscar receta artesanal...',
                  hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFA0AEC0)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── LISTA ──
            Expanded(
              child: recetasAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFFBC985D)),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Color(0xFFDC2626)),
                      const SizedBox(height: 16),
                      Text('Error: $err', textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(recetasProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBC985D),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
                data: (recetas) {
                  final filtered = _query.isEmpty
                      ? recetas
                      : recetas.where((r) => r.nombre.toLowerCase().contains(_query)).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.restaurant_menu, size: 80, color: Color(0xFFE2D9C5)),
                          const SizedBox(height: 24),
                          Text(
                            _query.isEmpty ? 'Crea tu primera receta' : 'Sin resultados para "$_query"',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_query.isEmpty)
                            const Text(
                              'Podrás ver el costo real por porción.',
                              style: TextStyle(color: Color(0xFFA0AEC0)),
                            ),
                          if (_query.isEmpty) ...[
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/recetas/crear'),
                              icon: const Icon(Icons.add),
                              label: const Text('Nueva Receta'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFBC985D),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '${filtered.length} RECETAS',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => ref.refresh(recetasProvider.future),
                          color: const Color(0xFFBC985D),
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) => RecetaCardWidget(receta: filtered[index]),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/recetas/crear'),
        backgroundColor: const Color(0xFFC29F5C),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      extendBody: true,
      bottomNavigationBar: const KitchyBottomNav(currentIndex: 1),
    );
  }
}

class RecetaCardWidget extends ConsumerWidget {
  final RecetaResponse receta;
  const RecetaCardWidget({super.key, required this.receta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double costoTotal = double.tryParse(receta.costoCalculado?.toString() ?? '0') ?? 0.0;
    final double costoPorPorcion = receta.porciones > 0 ? costoTotal / receta.porciones : 0.0;

    return Dismissible(
      key: ValueKey(receta.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              '¿Eliminarás ${receta.nombre}?',
              style: const TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold),
            ),
            content: const Text('Perderá sus costos calculados.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancelar', style: TextStyle(color: Color(0xFF718096))),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );

        if (confirmed != true) return false;

        try {
          final api = ref.read(apiProvider);
          final response = await api.apiV1RecetasIdDelete(id: receta.id);
          if (response.isSuccessful) {
            ref.invalidate(recetasProvider);
            return true;
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error al eliminar la receta'),
                  backgroundColor: Color(0xFFDC2626),
                ),
              );
            }
            return false;
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $e'),
                backgroundColor: const Color(0xFFDC2626),
              ),
            );
          }
          return false;
        }
      },
      child: GestureDetector(
        onTap: () => context.push('/recetas/${receta.id}'),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      gradient: LinearGradient(colors: [
                        const Color(0xFFBC985D).withOpacity(0.3),
                        const Color(0xFF1A2B4A).withOpacity(0.4),
                      ]),
                    ),
                    child: Center(child: Icon(Icons.restaurant_menu, size: 60, color: Colors.white.withOpacity(0.6))),
                  ),
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.55), borderRadius: BorderRadius.circular(20)),
                      child: Row(children: [
                        const Icon(Icons.people_outline, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('${receta.porciones} PORCIONES', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(receta.nombre, style: const TextStyle(fontFamily: 'Georgia', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('PRECIO SUGERIDO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFBC985D))),
                            Text(
                              costoPorPorcion > 0
                                  ? '\$${(costoPorPorcion * (1 + (double.tryParse(receta.margenPct.toString()) ?? 0.0) / 100)).toStringAsFixed(2)}'
                                  : '—',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2D3748)),
                            ),
                            Text(
                              'Costo: \$${costoPorPorcion.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 10, color: Color(0xFFA0AEC0)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: [
                        _chip(_categoryFromMargen(receta.margenPct), const Color(0xFFF3EAD5), const Color(0xFFB8872A)),
                        _chip('${receta.porciones} porc.', const Color(0xFFEBF5FF), const Color(0xFF2B6CB0)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryFromMargen(String margenPct) {
    final m = double.tryParse(margenPct) ?? 0;
    if (m >= 80) return 'ELITE';
    if (m >= 40) return 'PREMIUM';
    return 'TRADICIONAL';
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg, letterSpacing: 0.5)),
    );
  }
}

