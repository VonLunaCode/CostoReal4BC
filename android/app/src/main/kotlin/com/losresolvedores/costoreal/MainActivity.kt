package com.losresolvedores.costoreal

import android.app.ActivityManager
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.kitchy/alarm"
    private val TAG = "KitchyAlarm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleAlarmClock" -> {
                        val triggerAtMs = call.argument<Long>("triggerAtMs") ?: 0L
                        val timerId = call.argument<String>("timerId") ?: ""
                        val nombreFase = call.argument<String>("nombreFase") ?: "Fase"
                        scheduleAlarmClock(triggerAtMs, timerId, nombreFase)
                        result.success(true)
                    }
                    "cancelAlarmClock" -> {
                        val timerId = call.argument<String>("timerId") ?: ""
                        cancelAlarmClock(timerId)
                        result.success(true)
                    }
                    "bringToForeground" -> {
                        bringToForeground()
                        result.success(true)
                    }
                    "stopAlarmSound" -> {
                        TimerAlarmReceiver.activeRingtone?.stop()
                        TimerAlarmReceiver.activeRingtone = null
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // When launched from alarm, notify Flutter via method channel
        if (intent.getBooleanExtra("from_alarm", false)) {
            val timerId = intent.getStringExtra("timer_id") ?: ""
            val nombreFase = intent.getStringExtra("nombre_fase") ?: "Fase"
            Log.d(TAG, "onNewIntent from alarm: timerId=$timerId")
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod(
                    "onAlarmFired",
                    mapOf("timerId" to timerId, "nombreFase" to nombreFase)
                )
            }
        }
    }

    private fun scheduleAlarmClock(triggerAtMs: Long, timerId: String, nombreFase: String) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = Intent(this, TimerAlarmReceiver::class.java).apply {
            putExtra("timer_id", timerId)
            putExtra("nombre_fase", nombreFase)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            timerId.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // setAlarmClock grants BAL exemption — the BroadcastReceiver can start an Activity
        val alarmClockInfo = AlarmManager.AlarmClockInfo(triggerAtMs, pendingIntent)
        alarmManager.setAlarmClock(alarmClockInfo, pendingIntent)
        Log.d(TAG, "Alarm scheduled for $triggerAtMs (in ${(triggerAtMs - System.currentTimeMillis()) / 1000}s)")
    }

    private fun cancelAlarmClock(timerId: String) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, TimerAlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            timerId.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
        Log.d(TAG, "Alarm cancelled for $timerId")
    }

    private fun bringToForeground() {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        if (!pm.isInteractive) {
            @Suppress("DEPRECATION")
            val wl = pm.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "kitchy:alarm_fg"
            )
            wl.acquire(5000)
        }
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        am.moveTaskToFront(taskId, ActivityManager.MOVE_TASK_WITH_HOME)
    }
}
