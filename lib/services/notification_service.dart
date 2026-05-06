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

  static const AndroidNotificationChannel _kitchenAlarmChannel =
      AndroidNotificationChannel(
    'kitchen_alarms',
    'Alarmas de Cocina',
    description: 'Notificaciones críticas para temporizadores de cocina',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
  );

  Future<void> initialize() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_kitchenAlarmChannel);

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
        final nombreFase = Uri.encodeComponent(payload['nombreFase']?.toString() ?? 'Fase');
        if (temporizadorId.isNotEmpty) {
          appNavigatorKey.currentContext?.go(
            '/confirmar-alarma?temporizadorId=$temporizadorId&nombreFase=$nombreFase',
          );
        }
      }
    } catch (e) {
      debugPrint('Error procesando notificación: $e');
    }
  }

  Future<bool> requestPermissions() async {
    final androidGranted = await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;

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
