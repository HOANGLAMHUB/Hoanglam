package com.gamebooster.app.util

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Environment
import timber.log.Timber

class DeviceInfoHelper(private val context: Context) {

    fun getDeviceModel(): String = Build.MODEL
    fun getDeviceManufacturer(): String = Build.MANUFACTURER
    fun getAndroidVersion(): Int = Build.VERSION.SDK_INT
    fun getAndroidVersionName(): String = Build.VERSION.RELEASE

    fun getTotalRAM(): Long {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)
        return memInfo.totalDevMem
    }

    fun getAvailableRAM(): Long {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)
        return memInfo.availMem
    }

    fun getTotalStorage(): Long {
        return try {
            val stat = android.os.StatFs(Environment.getDataDirectory().absolutePath)
            stat.blockCountLong * stat.blockSizeLong
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }

    fun getAvailableStorage(): Long {
        return try {
            val stat = android.os.StatFs(Environment.getDataDirectory().absolutePath)
            stat.availableBlocksLong * stat.blockSizeLong
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }

    fun getCPUCount(): Int = Runtime.getRuntime().availableProcessors()

    fun getDeviceInfo(): String {
        return buildString {
            append("Device: $getDeviceManufacturer $getDeviceModel\n")
            append("Android: $getAndroidVersionName (API $getAndroidVersion)\n")
            append("CPU Cores: $getCPUCount\n")
            append("RAM: ${getTotalRAM() / (1024 * 1024 * 1024)}GB\n")
            append("Storage: ${getTotalStorage() / (1024 * 1024 * 1024)}GB")
        }
    }
}
