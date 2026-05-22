package com.gamebooster.app.util

import android.app.ActivityManager
import android.content.Context
import timber.log.Timber

class ProcessManager(private val context: Context) {

    private val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager

    fun getRunningProcesses(): List<ProcessInfo> {
        return try {
            val processes = activityManager.runningAppProcesses ?: return emptyList()
            processes.map { process ->
                ProcessInfo(
                    processName = process.processName,
                    pid = process.pid,
                    uid = process.uid,
                    importance = when (process.importance) {
                        ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND -> "Foreground"
                        ActivityManager.RunningAppProcessInfo.IMPORTANCE_VISIBLE -> "Visible"
                        ActivityManager.RunningAppProcessInfo.IMPORTANCE_SERVICE -> "Service"
                        ActivityManager.RunningAppProcessInfo.IMPORTANCE_BACKGROUND -> "Background"
                        ActivityManager.RunningAppProcessInfo.IMPORTANCE_EMPTY -> "Empty"
                        else -> "Unknown"
                    }
                )
            }
        } catch (e: Exception) {
            Timber.e(e)
            emptyList()
        }
    }

    fun getBackgroundProcesses(): List<ProcessInfo> {
        return getRunningProcesses().filter { it.importance == "Background" || it.importance == "Empty" }
    }

    fun getForegroundProcess(): ProcessInfo? {
        return getRunningProcesses().firstOrNull { it.importance == "Foreground" }
    }

    fun killProcess(packageName: String) {
        try {
            activityManager.killBackgroundProcesses(packageName)
            Timber.d("Killed process: $packageName")
        } catch (e: Exception) {
            Timber.e(e, "Failed to kill process: $packageName")
        }
    }

    fun getMemoryUsageForProcess(pid: Int): Long {
        return try {
            val runtime = Runtime.getRuntime()
            val process = runtime.exec("cat /proc/$pid/status")
            val reader = process.inputStream.bufferedReader()
            var memoryUsage = 0L
            var line: String?
            while (reader.readLine().also { line = it } != null) {
                if (line!!.startsWith("VmRSS")) {
                    val parts = line!!.split("\\s+".toRegex())
                    if (parts.size > 1) {
                        memoryUsage = parts[1].toLongOrNull() ?: 0L
                    }
                    break
                }
            }
            reader.close()
            memoryUsage
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }

    data class ProcessInfo(
        val processName: String,
        val pid: Int,
        val uid: Int,
        val importance: String
    )
}
