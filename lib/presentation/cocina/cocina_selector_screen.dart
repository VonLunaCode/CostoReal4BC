import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/kitchy_colors.dart';
import '../../theme/kitchy_typography.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../recetas/recetas_providers.dart';

class CocinaSelectorScreen extends ConsumerWidget {
  const CocinaSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recetasAsync = ref.watch(recetasProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0E8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C1F0E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'MODO COCINA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: Color(0xFF2C1F0E),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Text(
                '¿Qué vas a preparar hoy?',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF2C1F0E),
                  fontFamily: 'Georgia',
                ),
              ),
            ),
            Expanded(
              child: recetasAsync.when(
                data: (recetas) {
                  if (recetas.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 64,
                            color: const Color(0xFF8B7355).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Aún no tenés recetas.\n¡Creá una primero!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8B7355),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: recetas.length,
                    itemBuilder: (context, index) {
                      final receta = recetas[index];
                      final porcionesText = receta.porciones != null
                          ? 'RINDE ${receta.porciones} PORCIONES'
                          : 'RINDE 4 PORCIONES';
                      final ingredientesCount =
                          receta.ingredientes?.length ?? 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receta.nombre ?? 'Sin nombre',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C1F0E),
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                porcionesText,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Color(0xFF8B7355),
                                  letterSpacing: 1,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$ingredientesCount ingredientes',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF8B7355),
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.push('/cocina/modo', extra: receta);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFC8913A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    '▶ INICIAR PREPARACIÓN',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'DM Sans',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFFC8913A),
                    ),
                  ),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Error al cargar recetas',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF2C1F0E).withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
