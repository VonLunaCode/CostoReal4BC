import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'puntos_entrega_providers.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../pedidos/widgets/mapa_button_widget.dart';

class PuntosEntregaScreen extends ConsumerWidget {
  const PuntosEntregaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puntosAsync = ref.watch(puntosEntregaProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Puntos de Entrega',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C2623),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF7A613E)),
            onPressed: () => context.push('/perfil/puntos-entrega/new'),
          ),
        ],
      ),
      body: puntosAsync.when(
        data: (puntos) {
          if (puntos.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: puntos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final punto = puntos[index];
              return _PuntoEntregaCard(punto: punto);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Color(0xFFC53030)),
              const SizedBox(height: 16),
              Text('Error al cargar puntos: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(puntosEntregaProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, size: 64, color: Color(0xFFD5D1C6)),
            const SizedBox(height: 24),
            const Text(
              'No tienes puntos guardados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C2623),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega tus lugares frecuentes para seleccionarlos rápido en tus pedidos.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF807667)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push('/perfil/puntos-entrega/new'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A613E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Agregar Punto de Entrega'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PuntoEntregaCard extends ConsumerWidget {
  final PuntoEntregaRead punto;

  const _PuntoEntregaCard({required this.punto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2623).withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  punto.nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2623),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF807667)),
                onPressed: () => context.push('/perfil/puntos-entrega/${punto.id}/edit', extra: punto),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFC53030)),
                onPressed: () => _confirmarEliminacion(context, ref),
              ),
            ],
          ),
          if (punto.direccion != null && punto.direccion!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Color(0xFF7A613E)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    punto.direccion!,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF807667)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MapaButtonWidget(direccion: punto.direccion),
          ],
          if (punto.descripcion != null && punto.descripcion!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              punto.descripcion!,
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Color(0xFF807667),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar punto de entrega?'),
        content: Text('¿Estás seguro de que quieres eliminar "${punto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF807667))),
          ),
          TextButton(
            onPressed: () {
              ref.read(puntoEntregaNotifierProvider.notifier).delete(punto.id);
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Color(0xFFC53030))),
          ),
        ],
      ),
    );
  }
}
