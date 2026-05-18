import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_provider.dart';
import '../../services/alarma_ininterrumpible_service.dart';
import '../../services/foreground_service.dart';
import '../../services/sound_service.dart';

class ConfirmarAlarmaScreen extends ConsumerStatefulWidget {
  final String temporizadorId;
  final String nombreFase;

  const ConfirmarAlarmaScreen({
    super.key,
    required this.temporizadorId,
    required this.nombreFase,
  });

  @override
  ConsumerState<ConfirmarAlarmaScreen> createState() =>
      _ConfirmarAlarmaScreenState();
}

class _ConfirmarAlarmaScreenState extends ConsumerState<ConfirmarAlarmaScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<Color?> _colorAnimation;
  late AnimationController _bellCtrl;
  late Animation<double> _bellAnim;
  late List<AnimationController> _ringCtrl;
  bool _confirmando = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _colorAnimation = ColorTween(
      begin: const Color(0xFFDC2626),
      end: const Color(0xFFEF4444),
    ).animate(_pulseCtrl);
    _pulseCtrl.repeat(reverse: true);

    _bellCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bellAnim = Tween<double>(begin: -0.14, end: 0.14).animate(
      CurvedAnimation(parent: _bellCtrl, curve: Curves.easeInOut),
    );
    _bellCtrl.repeat(reverse: true);

    _ringCtrl = List.generate(3, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600),
      );
      Future.delayed(Duration(milliseconds: i * 400), () {
        if (mounted) ctrl.repeat();
      });
      return ctrl;
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _bellCtrl.dispose();
    for (final c in _ringCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _confirmarAlarma() async {
    if (_confirmando) return;
    setState(() => _confirmando = true);
    try {
      final api = ref.read(apiProvider);
      await api.apiV1TemporizadoresIdConfirmarPatch(id: widget.temporizadorId);
      await AlarmaIninterrumpibleService.instance
          .cancelarAlarma(widget.temporizadorId);
      await NativeAlarmService.stopAlarmSound();
      await SoundService.instance.stop();
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _confirmando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) => Scaffold(
        backgroundColor: _colorAnimation.value,
        body: Stack(
          children: [
            // ── Concentric pulse rings ─────────────────────────
            Positioned.fill(
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(3, (i) {
                  return AnimatedBuilder(
                    animation: _ringCtrl[i],
                    builder: (_, __) {
                      final t = _ringCtrl[i].value;
                      return Opacity(
                        opacity: (1 - t) * 0.35,
                        child: Transform.scale(
                          scale: 0.6 + t * 1.6,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  // ── Bell ──────────────────────────────────────
                  AnimatedBuilder(
                    animation: _bellAnim,
                    builder: (_, child) => Transform.rotate(
                      angle: _bellAnim.value,
                      child: child,
                    ),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                        size: 52,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'TIMER COMPLETO',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xD9FFFFFF),
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      '${widget.nombreFase} completada',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Revisá tu trabajo y confirmá para continuar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.78),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // ── CTA ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        onPressed: _confirmando ? null : _confirmarAlarma,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFDC2626),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 12,
                          shadowColor: Colors.black38,
                        ),
                        child: _confirmando
                            ? const CircularProgressIndicator(
                                color: Color(0xFFDC2626),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_rounded,
                                      size: 26,
                                      color: Color(0xFFDC2626)),
                                  SizedBox(width: 10),
                                  Text(
                                    'CONFIRMAR',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2,
                                      color: Color(0xFFDC2626),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
