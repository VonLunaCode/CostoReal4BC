import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api_generated/openapi.models.swagger.dart';
import '../../data/api_provider.dart';
import '../../services/alarma_ininterrumpible_service.dart';
import '../../services/foreground_service.dart';
import '../../services/notification_service.dart';
import '../../services/sound_service.dart';
import 'package:flutter/foundation.dart';

class CronometroWidget extends ConsumerStatefulWidget {
  final TemporizadorResponse temporizador;
  final PasoResponse paso;

  const CronometroWidget({
    required this.temporizador,
    required this.paso,
    super.key,
  });

  @override
  ConsumerState<CronometroWidget> createState() => _CronometroWidgetState();
}

class _CronometroWidgetState extends ConsumerState<CronometroWidget> {
  late int _segundosRestantes;
  Timer? _timer;
  late final int _stickyId;
  FlutterLocalNotificationsPlugin get _notificationsPlugin =>
      NotificationService.instance.plugin;

  // Double-tap cancel state
  bool _cancelArmed = false;
  Timer? _cancelArmTimer;

  @override
  void initState() {
    super.initState();
    _stickyId = widget.temporizador.id.hashCode.abs() % 100000;

    if (widget.temporizador.fechaInicio != null) {
      final fechaInicio =
          DateTime.parse(widget.temporizador.fechaInicio.toString());
      _segundosRestantes =
          (widget.temporizador.duracionSegundos -
                  DateTime.now().difference(fechaInicio).inSeconds)
              .clamp(0, widget.temporizador.duracionSegundos);
    } else {
      _segundosRestantes = widget.temporizador.duracionSegundos;
    }

    // Schedule via native AlarmManager.setAlarmClock() — grants BAL exemption
    // so the BroadcastReceiver can launch our Activity even on Android 14-16
    NativeAlarmService.scheduleAlarm(
      duracionSegundos: _segundosRestantes,
      temporizadorId: widget.temporizador.id,
      nombreFase: widget.paso.descripcion,
    );

    // Also schedule via flutter_local_notifications as notification-only fallback
    AlarmaIninterrumpibleService.instance.programarAlarma(
      duracionSegundos: _segundosRestantes,
      nombreFase: widget.paso.descripcion,
      temporizadorId: widget.temporizador.id,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    _actualizarNotificacionSticky();
  }

  Future<void> _onTick(Timer t) async {
    final fechaInicio = widget.temporizador.fechaInicio != null
        ? DateTime.parse(widget.temporizador.fechaInicio.toString())
        : DateTime.now();
    final restantes = (widget.temporizador.duracionSegundos -
            DateTime.now().difference(fechaInicio).inSeconds)
        .clamp(0, widget.temporizador.duracionSegundos);

    setState(() => _segundosRestantes = restantes);
    _actualizarNotificacionSticky();

    if (restantes <= 0) {
      t.cancel();
      _notificationsPlugin.cancel(_stickyId);
      // Cancel the native AlarmManager alarm since we're handling it in-app
      await NativeAlarmService.cancelAlarm(widget.temporizador.id);
      await AlarmaIninterrumpibleService.instance.cancelarAlarma(widget.temporizador.id);
      try {
        await SoundService.instance.playAlarm();
      } catch (e) {
        debugPrint('SoundService error: $e');
      }
      if (mounted) {
        final uri = Uri(
          path: '/confirmar-alarma',
          queryParameters: {
            'temporizadorId': widget.temporizador.id,
            'nombreFase': widget.paso.descripcion,
          },
        );
        await context.push(uri.toString());
        if (mounted) context.pop();
      }
    }
  }

  Future<void> _actualizarNotificacionSticky() async {
    const androidDetails = AndroidNotificationDetails(
      'kitchen_timer',
      'Temporizador en curso',
      channelDescription: 'Progreso del temporizador activo',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      playSound: false,
      enableVibration: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      _stickyId,
      'Kitchy — ${widget.paso.descripcion}',
      _formatearTiempo(_segundosRestantes),
      details,
    );
  }

  String _formatearTiempo(int segundos) {
    final m = (segundos ~/ 60).toString().padLeft(2, '0');
    final s = (segundos % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _handleCancelTap() {
    if (!_cancelArmed) {
      setState(() => _cancelArmed = true);
      _cancelArmTimer = Timer(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() => _cancelArmed = false);
      });
    } else {
      _cancelArmTimer?.cancel();
      _ejecutarCancelar();
    }
  }

  Future<void> _ejecutarCancelar() async {
    _timer?.cancel();
    _notificationsPlugin.cancel(_stickyId);
    await NativeAlarmService.cancelAlarm(widget.temporizador.id);
    await AlarmaIninterrumpibleService.instance.cancelarAlarma(widget.temporizador.id);
    final api = ref.read(apiProvider);
    await api.apiV1TemporizadoresIdCancelarPatch(id: widget.temporizador.id);
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cancelArmTimer?.cancel();
    _notificationsPlugin.cancel(_stickyId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final duracionTotal =
        (widget.temporizador.duracionSegundos as num).toDouble();
    final elapsed = duracionTotal - _segundosRestantes;
    final esCritico = widget.paso.esCritico ?? false;

    const ringSize = 220.0;
    const strokeWidth = 10.0;
    final radius = (ringSize - strokeWidth) / 2;
    final circumference = 2 * math.pi * radius;
    final progress = elapsed / duracionTotal;

    return Scaffold(
      backgroundColor: const Color(0xFF121827),
      body: Stack(
        children: [
          // Ambient gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 0.7,
                  colors: [
                    const Color(0xFF16A34A).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                // ── Step label ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _PulseDot(),
                          const SizedBox(width: 8),
                          Text(
                            'Paso ${widget.paso.orden}  ·  Timer corriendo',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF16A34A),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (esCritico)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7F1D1D),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '⚠ PASO CRÍTICO',
                            style: TextStyle(
                              color: Color(0xFFFC8181),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      Text(
                        widget.paso.descripcion,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.35,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Ring ────────────────────────────────────────
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: ringSize,
                      height: ringSize,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(ringSize, ringSize),
                            painter: _RingPainter(
                              progress: progress,
                              circumference: circumference,
                              radius: radius,
                              strokeWidth: strokeWidth,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatearTiempo(_segundosRestantes),
                                style: const TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'RESTANTE',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.4),
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Elapsed / Total ──────────────────────────────
                Text(
                  '${_formatearTiempo(elapsed.round())} / ${_formatearTiempo(duracionTotal.round())}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 0.5,
                  ),
                ),

                // ── Cancel ───────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(32, 20, 32, 24),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _handleCancelTap,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _cancelArmed
                                ? const Color(0xFF7F1D1D)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _cancelArmed
                                  ? const Color(0xFFEF4444)
                                  : Colors.white.withOpacity(0.12),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _cancelArmed
                                  ? '✕  tocá de nuevo para cancelar'
                                  : '✕  CANCELAR',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: _cancelArmed
                                    ? const Color(0xFFFFCACA)
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _cancelArmed
                            ? 'Esto descartará el temporizador'
                            : 'doble toque para cancelar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.54),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double circumference;
  final double radius;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.circumference,
    required this.radius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final startAngle = -math.pi / 2;

    // Background ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc with glow
    final glowPaint = Paint()
      ..color = const Color(0xFF16A34A).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final progressPaint = Paint()
      ..color = const Color(0xFF16A34A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A).withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16A34A).withOpacity(_anim.value * 0.8),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
