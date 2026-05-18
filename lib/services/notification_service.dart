import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import '../core/app_keys.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  static const AndroidNotificationChannel _kitchenAlarmChannel =
      AndroidNotificationChannel(
    'kitchen_alarms',
    'Alarmas de Cocina',
    description: 'Notificaciones críticas para temporizadores de cocina',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
  );

  static const AndroidNotificationChannel _kitchenTimerChannel =
      AndroidNotificationChannel(
    'kitchen_timer',
    'Temporizador en curso',
    description: 'Progreso del temporizador activo',
    importance: Importance.low,
    enableVibration: false,
    playSound: false,
  );

  Future<void> initialize() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(_kitchenAlarmChannel);
    await androidImpl?.createNotificationChannel(_kitchenTimerChannel);

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  void _onNotificationResponse(NotificationResponse response) {
    try {
      if (response.payload != null && response.payload!.isNotEmpty) {
        final payload = jsonDecode(response.payload!);
        final temporizadorId = payload['temporizadorId']?.toString() ?? '';
        final nombreFase = payload['nombreFase']?.toString() ?? 'Fase';
        if (temporizadorId.isNotEmpty) {
          final ctx = appNavigatorKey.currentContext;
          if (ctx != null) {
            final location = GoRouterState.of(ctx).matchedLocation;
            if (!location.startsWith('/confirmar-alarma')) {
              final uri = Uri(
                path: '/confirmar-alarma',
                queryParameters: {
                  'temporizadorId': temporizadorId,
                  'nombreFase': nombreFase,
                },
              );
              ctx.push(uri.toString());
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error procesando notificación: $e');
    }
  }

  Future<bool> requestPermissions() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final androidGranted =
        await androidImpl?.requestNotificationsPermission() ?? false;

    // Required on Android 14+ for fullScreenIntent to show over other apps
    await requestFullScreenIntentPermission();

    final iosGranted = await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
              critical: true,
            ) ??
        false;

    return androidGranted || iosGranted;
  }

  Future<void> requestFullScreenIntentPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestFullScreenIntentPermission();
  }

  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'kitchen_alarms',
      'Alarmas de Cocina',
      channelDescription: 'Canal de alarmas de cocina',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      interruptionLevel: InterruptionLevel.critical,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      0,
      'Kitchy — Alarma Test',
      'Si ves esto con pantalla bloqueada, el setup funciona.',
      details,
    );
  }
}
