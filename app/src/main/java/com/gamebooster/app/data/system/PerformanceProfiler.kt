package com.gamebooster.app.data.system

import android.os.Debug
import timber.log.Timber
import kotlin.system.measureTimeMillis

class PerformanceProfiler {

    fun profileMemoryUsage(): MemoryProfile {
        return try {
            val runtime = Runtime.getRuntime()
            val totalMemory = runtime.totalMemory()
            val freeMemory = runtime.freeMemory()
            val maxMemory = runtime.maxMemory()
            val usedMemory = totalMemory - freeMemory

            MemoryProfile(
                totalMemory = totalMemory,
                freeMemory = freeMemory,
                usedMemory = usedMemory,
                maxMemory = maxMemory,
                nativeHeap = Debug.getNativeHeap().size.toLong()
            )
        } catch (e: Exception) {
            Timber.e(e)
            MemoryProfile()
        }
    }

    fun measureOperationTime(operationName: String, operation: () -> Unit): Long {
        return measureTimeMillis {
            try {
                operation()
            } catch (e: Exception) {
                Timber.e(e, "Error in operation: $operationName")
            }
        }.also {
            Timber.d("Operation '$operationName' took ${it}ms")
        }
    }

    fun getThreadInfo(): ThreadInfo {
        return try {
            val threadGroup = Thread.currentThread().threadGroup
            var parent = threadGroup
            while (parent?.parent != null) {
                parent = parent.parent
            }

            ThreadInfo(
                activeThreadCount = parent?.activeCount() ?: 0,
                peakThreadCount = parent?.activeCount() ?: 0,
                threadDaemonCount = Thread.activeCount()
            )
        } catch (e: Exception) {
            Timber.e(e)
            ThreadInfo()
        }
    }

    data class MemoryProfile(
        val totalMemory: Long = 0L,
        val freeMemory: Long = 0L,
        val usedMemory: Long = 0L,
        val maxMemory: Long = 0L,
        val nativeHeap: Long = 0L
    )

    data class ThreadInfo(
        val activeThreadCount: Int = 0,
        val peakThreadCount: Int = 0,
        val threadDaemonCount: Int = 0
    )
}
