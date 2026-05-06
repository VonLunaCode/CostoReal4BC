import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../data/api_generated/openapi.models.swagger.dart';

class ModoCocinaScreen extends ConsumerStatefulWidget {
  final RecetaResponse receta;

  const ModoCocinaScreen({super.key, required this.receta});

  @override
  ConsumerState<ModoCocinaScreen> createState() => _ModoCocinaScreenState();
}

class _ModoCocinaScreenState extends ConsumerState<ModoCocinaScreen> {
  int _pasoActual = 0;

  List<PasoResponse> get _pasos => widget.receta.pasos;
  PasoResponse get _paso => _pasos[_pasoActual];

  @override
  Widget build(BuildContext context) {
    final total = _pasos.length;
    final progress = ((_pasoActual + 1) / total);
    final duracion = (_paso.duracionSegundos as num?)?.toInt();
    final esCritico = _paso.esCritico ?? false;
    final upcoming = _pasos.skip(_pasoActual + 1).take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121827),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _confirmarSalir,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COCINANDO',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.4),
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.receta.nombre,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Progress bar ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Paso ${_pasoActual + 1} de $total',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      color: const Color(0xFF16A34A),
                      backgroundColor: Colors.white.withOpacity(0.08),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            // ── Active step card ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.08)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x59000000),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF16A34A).withOpacity(0.25),
                            blurRadius: 0,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${_paso.orden}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (esCritico) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7F1D1D),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.warning_amber_rounded,
                                      color: Color(0xFFFFCACA),
                                      size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    'PASO CRÍTICO',
                                    style: TextStyle(
                                      color: Color(0xFFFFCACA),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Text(
                            _paso.descripcion,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              height: 1.4,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (duracion != null) ...[
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Icon(Icons.timer_outlined,
                                    color: Color(0xFFC8913A), size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'Timer: ${_formatDuration(duracion)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFC8913A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Action row ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  // Prev
                  _ActionButton(
                    onTap: _pasoActual > 0
                        ? () => setState(() => _pasoActual--)
                        : null,
                    width: 64,
                    child: Icon(
                      Icons.arrow_back,
                      color: _pasoActual > 0
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Timer
                  Expanded(
                    child: _ActionButton(
                      onTap: duracion != null ? () => _iniciarTemporizador(_paso) : null,
                      color: duracion != null
                          ? const Color(0xFFC8913A)
                          : Colors.white.withOpacity(0.08),
                      shadow: duracion != null
                          ? const Color(0x88C8913A)
                          : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: duracion != null
                                ? const Color(0xFF1A1206)
                                : Colors.white.withOpacity(0.4),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            duracion != null
                                ? 'Iniciar · ${_formatDuration(duracion)}'
                                : 'Sin timer',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                              color: duracion != null
                                  ? const Color(0xFF1A1206)
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Next / Finalizar
                  _pasoActual < _pasos.length - 1
                      ? _ActionButton(
                          onTap: () => setState(() => _pasoActual++),
                          color: const Color(0xFF16A34A),
                          shadow: const Color(0x8816A34A),
                          width: 64,
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.white, size: 20),
                        )
                      : _ActionButton(
                          onTap: _mostrarRecetaTerminada,
                          color: const Color(0xFF16A34A),
                          shadow: const Color(0x8816A34A),
                          width: 64,
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 22),
                        ),
                ],
              ),
            ),

            // ── Coming up ────────────────────────────────────────
            if (upcoming.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRÓXIMOS PASOS',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.4),
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Opacity(
                          opacity: 0.55,
                          child: Column(
                            children: upcoming.map((s) {
                              final d = (s.duracionSegundos as num?)?.toInt();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white.withOpacity(0.4),
                                            width: 1.5),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${s.orden}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: RichText(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: s.descripcion,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    Colors.white.withOpacity(0.7),
                                                height: 1.4,
                                              ),
                                            ),
                                            if (d != null)
                                              TextSpan(
                                                text:
                                                    ' · ${_formatDuration(d)}',
                                                style: const TextStyle(
                                                  color: Color(0xFFC8913A),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Spacer(),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seg) {
    if (seg >= 60) return '${seg ~/ 60}m ${seg % 60}s';
    return '${seg}s';
  }

  void _mostrarRecetaTerminada() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF16A34A), size: 44),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Receta completada!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.receta.nombre,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/agenda'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC8913A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Ver pedidos',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/recetas'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Volver a recetas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarSalir() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Salir del modo cocina?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) context.pop();
  }

  Future<void> _iniciarTemporizador(PasoResponse paso) async {
    final duracion = (paso.duracionSegundos as num).toInt();
    final api = ref.read(apiProvider);
    try {
      final response = await api.apiV1TemporizadoresPost(
        body: TemporizadorCreate(
          pasoRecetaId: paso.id,
          duracionSegundos: duracion,
        ),
      );
      if (response.isSuccessful && response.body != null && mounted) {
        await context.push('/cocina/cronometro', extra: {
          'temporizador': response.body!,
          'paso': paso,
        });
        // Cuando cronometro vuelve (timer confirmado)
        if (!mounted) return;
        if (_pasoActual < _pasos.length - 1) {
          setState(() => _pasoActual++);
        } else {
          _mostrarRecetaTerminada();
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error ${response.statusCode}: ${response.error}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Color color;
  final Color shadow;
  final double? width;

  const _ActionButton({
    required this.onTap,
    required this.child,
    this.color = const Color(0x14FFFFFF),
    this.shadow = Colors.transparent,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: shadow != Colors.transparent
              ? [BoxShadow(color: shadow, blurRadius: 20, offset: const Offset(0, 6))]
              : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}
