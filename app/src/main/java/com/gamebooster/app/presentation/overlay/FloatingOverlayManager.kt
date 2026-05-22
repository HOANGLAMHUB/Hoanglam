package com.gamebooster.app.presentation.overlay

import android.content.Context
import android.graphics.PixelFormat
import android.view.Gravity
import android.view.LayoutInflater
import android.view.WindowManager
import android.widget.FrameLayout
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import timber.log.Timber

class FloatingOverlayManager(private val context: Context) {

    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private var overlayView: ComposeView? = null
    private var isOverlayShowing = false

    fun showFloatingOverlay(stats: OverlayStats) {
        try {
            if (isOverlayShowing) return

            val composeView = ComposeView(context).apply {
                setContent {
                    FloatingOverlayContent(stats = stats, onClose = { hideFloatingOverlay() })
                }
            }

            val params = WindowManager.LayoutParams().apply {
                type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                format = PixelFormat.RGBA_8888
                flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                        WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
                        WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
                width = 300
                height = 150
                x = 0
                y = 0
                gravity = Gravity.TOP or Gravity.END
            }

            windowManager.addView(composeView, params)
            overlayView = composeView
            isOverlayShowing = true
            Timber.d("Floating overlay shown")
        } catch (e: Exception) {
            Timber.e(e, "Error showing floating overlay")
        }
    }

    fun updateOverlay(stats: OverlayStats) {
        try {
            overlayView?.setContent {
                FloatingOverlayContent(stats = stats, onClose = { hideFloatingOverlay() })
            }
        } catch (e: Exception) {
            Timber.e(e, "Error updating overlay")
        }
    }

    fun hideFloatingOverlay() {
        try {
            overlayView?.let { windowManager.removeView(it) }
            overlayView = null
            isOverlayShowing = false
            Timber.d("Floating overlay hidden")
        } catch (e: Exception) {
            Timber.e(e, "Error hiding overlay")
        }
    }

    fun isShowing(): Boolean = isOverlayShowing

    data class OverlayStats(
        val fps: Int = 0,
        val ramUsage: String = "0GB",
        val temperature: String = "0°C",
        val batteryPercent: Int = 0,
        val cpuUsage: String = "0%"
    )
}

@Composable
fun FloatingOverlayContent(
    stats: FloatingOverlayManager.OverlayStats,
    onClose: () -> Unit
) {
    var showMenu by remember { mutableStateOf(false) }

    Column(
        modifier = Modifier
            .background(
                Color(0xFF1E1E1E).copy(alpha = 0.9f),
                shape = RoundedCornerShape(12.dp)
            )
            .padding(12.dp)
            .fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        // Header
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                "Game Booster",
                fontSize = 10.sp,
                fontWeight = FontWeight.Bold,
                color = Color(0xFF00D4FF)
            )
            Icon(
                imageVector = Icons.Default.MoreVert,
                contentDescription = null,
                tint = Color(0xFF00D4FF),
                modifier = Modifier
                    .size(16.dp)
                    .clickable { showMenu = !showMenu }
            )
        }

        // Stats
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            StatItem(label = "FPS", value = stats.fps.toString())
            StatItem(label = "RAM", value = stats.ramUsage)
            StatItem(label = "Temp", value = stats.temperature)
        }

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            StatItem(label = "CPU", value = stats.cpuUsage)
            StatItem(label = "Battery", value = "${stats.batteryPercent}%")
        }
    }
}

@Composable
fun StatItem(label: String, value: String) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier.width(40.dp)
    ) {
        Text(
            label,
            fontSize = 8.sp,
            color = Color.White.copy(alpha = 0.6f)
        )
        Text(
            value,
            fontSize = 10.sp,
            fontWeight = FontWeight.Bold,
            color = Color(0xFF00D4FF)
        )
    }
}
