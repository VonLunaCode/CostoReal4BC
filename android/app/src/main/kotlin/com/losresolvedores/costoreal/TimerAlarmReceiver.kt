package com.losresolvedores.costoreal

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class TimerAlarmReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "TimerAlarmReceiver"
        private const val CHANNEL_ID = "kitchen_alarm_v5"
        private const val NOTIFICATION_ID = 999999

        // Shared so MainActivity can stop it when the user confirms
        var activeRingtone: Ringtone? = null
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Alarm fired!")

        val timerId = intent.getStringExtra("timer_id") ?: ""
        val nombreFase = intent.getStringExtra("nombre_fase") ?: "Fase"

        // 1. Wake the screen
        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        @Suppress("DEPRECATION")
        val wl = pm.newWakeLock(
            PowerManager.FULL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "kitchy:timer_alarm"
        )
        wl.acquire(30_000L)

        // 2. Play alarm sound directly (bypasses channel sound caching)
        playAlarmSound(context)

        // 3. Ensure notification channel exists
        ensureChannel(context)

        // 4. Build intent to launch MainActivity
        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra("timer_id", timerId)
            putExtra("nombre_fase", nombreFase)
            putExtra("from_alarm", true)
        }

        val fullScreenPI = PendingIntent.getActivity(
            context,
            timerId.hashCode(),
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // 5. Silent notification (sound comes from Ringtone above)
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle("Kitchy — Alarma")
            .setContentText(nombreFase)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setFullScreenIntent(fullScreenPI, true)
            .setContentIntent(fullScreenPI)
            .setSilent(true)
            .setAutoCancel(true)
            .setOngoing(true)
            .build()

        try {
            NotificationManagerCompat.from(context).notify(NOTIFICATION_ID, notification)
            Log.d(TAG, "Notification posted")
        } catch (e: SecurityException) {
            Log.e(TAG, "Notification permission denied: ${e.message}")
        }

        // 6. Also try direct startActivity
        try {
            context.startActivity(launchIntent)
            Log.d(TAG, "startActivity called")
        } catch (e: Exception) {
            Log.w(TAG, "startActivity failed: ${e.message}")
        }
    }

    private fun playAlarmSound(context: Context) {
        try {
            // Stop any previous alarm
            activeRingtone?.stop()

            val resId = context.resources.getIdentifier("alarm", "raw", context.packageName)
            Log.d(TAG, "alarm resource id=$resId (0=NOT FOUND)")

            val soundUri = if (resId != 0) {
                Uri.parse("android.resource://${context.packageName}/$resId")
            } else {
                // Fallback to system alarm sound
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            }

            val ringtone = RingtoneManager.getRingtone(context, soundUri)
            ringtone?.let {
                it.audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    it.isLooping = true
                }
                it.play()
                activeRingtone = it
                Log.d(TAG, "Ringtone playing (looping)")
            } ?: Log.e(TAG, "Could not get Ringtone for $soundUri")
        } catch (e: Exception) {
            Log.e(TAG, "Error playing alarm sound: ${e.message}")
        }
    }

    private fun ensureChannel(context: Context) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (nm.getNotificationChannel(CHANNEL_ID) != null) return

        // Silent channel — sound is handled by Ringtone API directly
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Alarma de Timer",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Alarma cuando el temporizador llega a cero"
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 500, 200, 500, 200, 500)
            setBypassDnd(true)
            setSound(null, null)
            lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
        }
        nm.createNotificationChannel(channel)
        Log.d(TAG, "Channel $CHANNEL_ID created (silent, sound via Ringtone)")
    }
}
