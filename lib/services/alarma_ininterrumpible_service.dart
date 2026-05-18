import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';

class AlarmaIninterrumpibleService {
  static final AlarmaIninterrumpibleService _instance =
      AlarmaIninterrumpibleService._();

  static AlarmaIninterrumpibleService get instance => _instance;

  AlarmaIninterrumpibleService._();

  FlutterLocalNotificationsPlugin get _plugin => NotificationService.instance.plugin;

  bool _timezoneInitialized = false;

  Future<void> _ensureTimezoneInitialized() async {
    if (_timezoneInitialized) return;

    final timezoneName = await FlutterTimezone.getLocalTimezone();
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(timezoneName));
    _timezoneInitialized = true;
  }

  Future<void> programarAlarma({
    required int duracionSegundos,
    required String nombreFase,
    required String temporizadorId,
  }) async {
    await _ensureTimezoneInitialized();

    // Offset by 100000 to avoid colliding with the sticky timer notification
    final notificationId = (temporizadorId.hashCode.abs() % 100000) + 100000;
    // Minimum 2 seconds so Android alarm manager fires reliably
    final effectiveSecs = duracionSegundos < 2 ? 2 : duracionSegundos;
    final scheduledTime = tz.TZDateTime.now(tz.local)
        .add(Duration(seconds: effectiveSecs));

    final payload = jsonEncode({
      'temporizadorId': temporizadorId,
      'nombreFase': nombreFase,
    });

    const androidDetails = AndroidNotificationDetails(
      'kitchen_alarms',
      'Alarmas de Cocina',
      channelDescription: 'Notificaciones críticas para temporizadores',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      playSound: true,
      enableVibration: true,
      autoCancel: false,
      ongoing: true,
      category: AndroidNotificationCategory.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      interruptionLevel: InterruptionLevel.critical,
      sound: 'alarm.aiff',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      notificationId,
      'Kitchy',
      nombreFase,
      scheduledTime,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> mostrarAlarmaInmediata({
    required String nombreFase,
    required String temporizadorId,
  }) async {
    final notificationId = (temporizadorId.hashCode.abs() % 100000) + 100000;
    final payload = jsonEncode({
      'temporizadorId': temporizadorId,
      'nombreFase': nombreFase,
    });

    const androidDetails = AndroidNotificationDetails(
      'kitchen_alarms',
      'Alarmas de Cocina',
      channelDescription: 'Notificaciones críticas para temporizadores',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      playSound: true,
      enableVibration: true,
      autoCancel: false,
      ongoing: true,
      category: AndroidNotificationCategory.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      interruptionLevel: InterruptionLevel.critical,
      sound: 'alarm.aiff',
    );

    await _plugin.show(
      notificationId,
      'Kitchy',
      nombreFase,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  Future<void> cancelarAlarma(String temporizadorId) async {
    final id = (temporizadorId.hashCode.abs() % 100000) + 100000;
    await _plugin.cancel(id);
  }
}
