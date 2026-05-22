package com.gamebooster.app.domain.model

import java.io.Serializable

// Performance Benchmark
data class PerformanceBenchmark(
    val testName: String = "",
    val score: Float = 0f,
    val maxScore: Float = 100f,
    val timestamp: Long = System.currentTimeMillis()
) : Serializable

// Device Specs
data class DeviceSpecs(
    val manufacturer: String = "",
    val model: String = "",
    val androidVersion: String = "",
    val apiLevel: Int = 34,
    val cpuCores: Int = 0,
    val totalRam: Long = 0L,
    val totalStorage: Long = 0L,
    val displayDpi: Int = 0,
    val displayRefreshRate: Float = 60f
) : Serializable

// App Usage Statistics
data class AppUsageStats(
    val packageName: String = "",
    val appName: String = "",
    val lastUsedTime: Long = 0L,
    val totalTimeInForeground: Long = 0L,
    val launchCount: Int = 0,
    val cpuUsage: Float = 0f,
    val memoryUsage: Long = 0L
) : Serializable

// Thermal Management
data class ThermalInfo(
    val coreTemperatures: List<Float> = emptyList(),
    val averageTemperature: Float = 0f,
    val thermalThrottle: Boolean = false,
    val thermalLevel: Int = 0, // 0-2
    val thermalWarning: String = ""
) : Serializable

// Network Statistics
data class NetworkStats(
    val totalBytesSent: Long = 0L,
    val totalBytesReceived: Long = 0L,
    val wifi: NetworkTypeStats = NetworkTypeStats(),
    val mobile: NetworkTypeStats = NetworkTypeStats()
) : Serializable

data class NetworkTypeStats(
    val bytesSent: Long = 0L,
    val bytesReceived: Long = 0L,
    val packetsSent: Long = 0L,
    val packetsReceived: Long = 0L
) : Serializable

// Gaming Session
data class GamingSession(
    val gamePackage: String = "",
    val gameName: String = "",
    val startTime: Long = 0L,
    val endTime: Long = 0L,
    val averageFps: Int = 0,
    val minFps: Int = 0,
    val maxFps: Int = 0,
    val fpsDrops: Int = 0,
    val ramUsagePercent: Float = 0f,
    val temperatureIncrease: Float = 0f,
    val batteryDrained: Int = 0
) : Serializable
