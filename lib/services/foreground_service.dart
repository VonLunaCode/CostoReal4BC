import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Bridges to native Android AlarmManager.setAlarmClock() which grants
/// the Background Activity Launch (BAL) exemption on Android 14-16.
class NativeAlarmService {
  static const _channel = MethodChannel('com.kitchy/alarm');

  /// Callback set by the widget tree when the alarm fires while the app is alive.
  static VoidCallback? onAlarmFired;

  static bool _listenerRegistered = false;

  /// Must be called once (e.g. in main) to listen for alarms that
  /// bring the activity back via onNewIntent.
  static void registerListener() {
    if (_listenerRegistered) return;
    _listenerRegistered = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onAlarmFired') {
        debugPrint('NativeAlarmService: onAlarmFired callback');
        onAlarmFired?.call();
      }
    });
  }

  /// Schedule an alarm using AlarmManager.setAlarmClock().
  /// When it fires, Android launches MainActivity via BroadcastReceiver
  /// (BAL exemption), even from background on Android 14-16.
  static Future<void> scheduleAlarm({
    required int duracionSegundos,
    required String temporizadorId,
    required String nombreFase,
  }) async {
    final triggerAtMs =
        DateTime.now().millisecondsSinceEpoch + (duracionSegundos * 1000);
    try {
      await _channel.invokeMethod('scheduleAlarmClock', {
        'triggerAtMs': triggerAtMs,
        'timerId': temporizadorId,
        'nombreFase': nombreFase,
      });
    } catch (e) {
      debugPrint('NativeAlarmService.scheduleAlarm error: $e');
    }
  }

  /// Cancel a previously scheduled alarm.
  static Future<void> cancelAlarm(String temporizadorId) async {
    try {
      await _channel.invokeMethod('cancelAlarmClock', {
        'timerId': temporizadorId,
      });
    } catch (e) {
      debugPrint('NativeAlarmService.cancelAlarm error: $e');
    }
  }

  /// Stop the native Ringtone alarm sound.
  static Future<void> stopAlarmSound() async {
    try {
      await _channel.invokeMethod('stopAlarmSound');
    } catch (e) {
      debugPrint('NativeAlarmService.stopAlarmSound error: $e');
    }
  }

  /// Best-effort bring to foreground (works when app is in recents).
  static Future<void> bringToForeground() async {
    try {
      await _channel.invokeMethod('bringToForeground');
    } catch (e) {
      debugPrint('NativeAlarmService.bringToForeground error: $e');
    }
  }
}
