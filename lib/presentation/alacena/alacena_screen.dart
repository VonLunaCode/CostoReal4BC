import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';

final alacenaProvider = FutureProvider.autoDispose<List<InsumoResponse>>((ref) async {
  final api = ref.watch(apiProvider);
  final response = await api.apiV1InsumosGet();
  if (!response.isSuccessful) {
    throw Exception('Error al cargar insumos: ${response.error}');
  }
  return response.body ?? [];
});

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

class AlacenaScreen extends ConsumerWidget {
  const AlacenaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insumosAsync = ref.watch(alacenaProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alacena', style: TextStyle(fontFamily: 'serif', fontSize: 28)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE2E8F0),
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
      body: insumosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (insumos) {
          final filtered = insumos.where((i) => i.nombre.toLowerCase().contains(searchQuery.toLowerCase())).toList();
          
          final criticos = filtered.where((i) {
             final cantActual = double.tryParse(i.cantidadActual) ?? 0.0;
             final alertaMin = double.tryParse(i.alertaMinimo ?? '0') ?? 0.0;
             final esCritico = cantActual <= alertaMin;
             final esDesactualizado = DateTime.now().difference(i.fechaUltimoPrecio).inDays > 30;
             return esCritico || esDesactualizado;
          }).toList();

          final regulares = filtered.where((i) => !criticos.contains(i)).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(alacenaProvider);
              await ref.read(alacenaProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar insumo...',
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
                ),
                const SizedBox(height: 24),

                if (criticos.isNotEmpty) ...[
                  const Text(
                    '⚠️ ATENCIÓN NECESARIA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...criticos.map((i) => InsumoCardWidget(insumo: i, isAlert: true)),
                  const SizedBox(height: 24),
                ],

                const Text(
                  'INSUMOS EN ALACENA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 12),
                ...regulares.map((i) => InsumoCardWidget(insumo: i, isAlert: false)),
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/alacena/crear'),
        backgroundColor: const Color(0xFFBC985D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFFBC985D),
        unselectedItemColor: const Color(0xFF718096),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Alacena'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Recetas'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}

class InsumoCardWidget extends StatelessWidget {
  final InsumoResponse insumo;
  final bool isAlert;

  const InsumoCardWidget({super.key, required this.insumo, required this.isAlert});

  @override
  Widget build(BuildContext context) {
    final cantActual = double.tryParse(insumo.cantidadActual) ?? 0.0;
    final alertaMin = double.tryParse(insumo.alertaMinimo ?? '0') ?? 0.0;
    final esCritico = cantActual <= alertaMin;
    final esDesactualizado = DateTime.now().difference(insumo.fechaUltimoPrecio).inDays > 30;

    Color bgColor = Colors.white;
    Color textColor = const Color(0xFF2D3748);
    Color? badgeColor;
    String badgeText = '';

    if (esCritico) {
      bgColor = const Color(0xFFFFF5F5);
      textColor = const Color(0xFFDC2626);
      badgeColor = const Color(0xFFDC2626);
      badgeText = 'STOCK BAJO';
    } else if (esDesactualizado) {
      bgColor = const Color(0xFFFEFCBF);
      textColor = const Color(0xFFD97706);
      badgeColor = const Color(0xFFD97706);
      badgeText = 'PRECIO VIEJO';
    }

    return Card(
      color: bgColor,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () => context.push('/alacena/${insumo.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: esCritico 
                ? const Border(left: BorderSide(color: Color(0xFFDC2626), width: 6)) 
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (badgeColor ?? const Color(0xFFBC985D)).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    esCritico ? Icons.inventory_2 : Icons.warning_amber,
                    color: badgeColor ?? const Color(0xFFBC985D),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insumo.nombre,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                      ),
                      Text(
                        '${insumo.cantidadActual} ${insumo.unidad.toString().split(".").last}',
                        style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13),
                      ),
                      Text(
                        'Precio: $${insumo.precioCompra}',
                        style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (badgeText.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                const Icon(Icons.chevron_right, color: Color(0xFF718096)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
