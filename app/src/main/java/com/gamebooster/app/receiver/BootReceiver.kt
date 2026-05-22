package com.gamebooster.app.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import timber.log.Timber

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            Timber.d("Boot completed - Game Booster ready")
            // Start monitoring service on boot
            val serviceIntent = Intent(context, com.gamebooster.app.service.MonitoringService::class.java)
            context.startService(serviceIntent)
        }
    }
}
