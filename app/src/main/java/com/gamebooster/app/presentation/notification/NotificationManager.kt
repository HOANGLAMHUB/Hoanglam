package com.gamebooster.app.presentation.notification

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import com.gamebooster.app.ui.MainActivity
import timber.log.Timber

class NotificationManager(private val context: Context) {

    companion object {
        const val CHANNEL_ID = "game_booster_channel"
        const val CHANNEL_NAME = "Game Booster"
        const val NOTIFICATION_ID = 1001
        const val BOOST_NOTIFICATION_ID = 1002
    }

    private val notificationManager =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    init {
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_LOW
            val channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, importance).apply {
                description = "Game Booster notifications"
                enableLights(true)
                lightColor = 0xFF00D4FF.toInt()
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun showBoostingNotification(progress: Int) {
        try {
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_menu_info_details)
                .setContentTitle("Game Booster")
                .setContentText("Boosting... $progress%")
                .setProgress(100, progress, false)
                .setContentIntent(pendingIntent)
                .setAutoCancel(false)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .build()

            notificationManager.notify(BOOST_NOTIFICATION_ID, notification)
        } catch (e: Exception) {
            Timber.e(e)
        }
    }

    fun showBoostCompletedNotification(ramCleared: Long, appsOptimized: Int) {
        try {
            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val message = "Cleared ${ramCleared / (1024 * 1024)}MB, Optimized $appsOptimized apps"
            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_menu_info_details)
                .setContentTitle("Boost Completed! ✨")
                .setContentText(message)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setStyle(NotificationCompat.BigTextStyle().bigText(message))
                .build()

            notificationManager.notify(BOOST_NOTIFICATION_ID, notification)
        } catch (e: Exception) {
            Timber.e(e)
        }
    }

    fun showWarningNotification(title: String, message: String) {
        try {
            val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(android.R.drawable.ic_dialog_alert)
                .setContentTitle(title)
                .setContentText(message)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .build()

            notificationManager.notify(System.currentTimeMillis().toInt(), notification)
        } catch (e: Exception) {
            Timber.e(e)
        }
    }

    fun dismissNotification(id: Int = BOOST_NOTIFICATION_ID) {
        notificationManager.cancel(id)
    }
}
