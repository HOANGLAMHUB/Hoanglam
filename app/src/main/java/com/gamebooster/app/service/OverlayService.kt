package com.gamebooster.app.service

import android.app.Service
import android.content.Intent
import android.os.IBinder
import com.gamebooster.app.data.system.SystemManager
import com.gamebooster.app.presentation.overlay.FloatingOverlayManager
import com.gamebooster.app.presentation.notification.NotificationManager as NotifManager
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import timber.log.Timber
import javax.inject.Inject

@AndroidEntryPoint
class OverlayService : Service() {

    @Inject
    lateinit var systemManager: SystemManager

    private lateinit var overlayManager: FloatingOverlayManager
    private lateinit var notifManager: NotifManager
    private val serviceScope = CoroutineScope(Dispatchers.Default)
    private var isRunning = false

    override fun onCreate() {
        super.onCreate()
        overlayManager = FloatingOverlayManager(this)
        notifManager = NotifManager(this)
        Timber.d("OverlayService Created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Timber.d("OverlayService Started")
        
        if (!isRunning) {
            isRunning = true
            startOverlayMonitoring()
        }
        
        return START_STICKY
    }

    private fun startOverlayMonitoring() {
        serviceScope.launch {
            while (isRunning) {
                try {
                    systemManager.getSystemInfo().collect { systemInfo ->
                        val overlayStats = FloatingOverlayManager.OverlayStats(
                            fps = 60,
                            ramUsage = "${(systemInfo.usedRam / (1024 * 1024 * 1024))}GB",
                            temperature = "${systemInfo.temperature.toInt()}°C",
                            batteryPercent = systemInfo.batteryLevel,
                            cpuUsage = "${systemInfo.cpuUsagePercent.toInt()}%"
                        )

                        overlayManager.updateOverlay(overlayStats)
                    }
                    delay(1000)
                } catch (e: Exception) {
                    Timber.e(e, "Error in overlay monitoring")
                }
            }
        }
    }

    fun showOverlay() {
        val stats = FloatingOverlayManager.OverlayStats(
            fps = 60,
            ramUsage = "8GB",
            temperature = "42°C",
            batteryPercent = 85,
            cpuUsage = "45%"
        )
        overlayManager.showFloatingOverlay(stats)
    }

    fun hideOverlay() {
        overlayManager.hideFloatingOverlay()
    }

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false
        overlayManager.hideFloatingOverlay()
        Timber.d("OverlayService Destroyed")
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
