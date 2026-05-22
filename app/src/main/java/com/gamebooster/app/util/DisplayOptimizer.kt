package com.gamebooster.app.util

import android.content.Context
import android.provider.Settings
import android.view.Display
import android.view.WindowManager
import timber.log.Timber

class DisplayOptimizer(private val context: Context) {

    fun getScreenBrightness(): Int {
        return try {
            Settings.System.getInt(context.contentResolver, Settings.System.SCREEN_BRIGHTNESS, 128)
        } catch (e: Exception) {
            Timber.e(e)
            128
        }
    }

    fun getRefreshRate(): Float {
        return try {
            val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            windowManager.defaultDisplay.refreshRate
        } catch (e: Exception) {
            Timber.e(e)
            60f
        }
    }

    fun getScreenResolution(): Pair<Int, Int> {
        return try {
            val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val display = windowManager.defaultDisplay
            Pair(display.width, display.height)
        } catch (e: Exception) {
            Timber.e(e)
            Pair(1080, 1920)
        }
    }

    fun getDisplayInfo(): DisplayInfo {
        return DisplayInfo(
            brightness = getScreenBrightness(),
            refreshRate = getRefreshRate(),
            resolution = getScreenResolution(),
            screenDensity = context.resources.displayMetrics.density,
            screenDpi = context.resources.displayMetrics.densityDpi
        )
    }

    data class DisplayInfo(
        val brightness: Int = 0,
        val refreshRate: Float = 60f,
        val resolution: Pair<Int, Int> = Pair(1080, 1920),
        val screenDensity: Float = 1f,
        val screenDpi: Int = 420
    )
}
