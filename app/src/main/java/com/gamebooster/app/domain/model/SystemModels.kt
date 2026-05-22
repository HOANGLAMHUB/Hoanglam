package com.gamebooster.app.domain.model

data class SystemInfo(
    val totalRam: Long = 0L,
    val availableRam: Long = 0L,
    val usedRam: Long = 0L,
    val ramUsagePercent: Float = 0f,
    val cpuUsagePercent: Float = 0f,
    val batteryLevel: Int = 0,
    val temperature: Float = 0f,
    val fpsInfo: FpsInfo = FpsInfo()
)

data class FpsInfo(
    val currentFps: Int = 0,
    val averageFps: Int = 0,
    val maxFps: Int = 0,
    val minFps: Int = 0,
    val fpsDrops: Int = 0
)

data class BoostStats(
    val ramCleared: Long = 0L,
    val appsOptimized: Int = 0,
    val batteryTimeSaved: Long = 0L,
    val fpsImproved: Int = 0,
    val temperatureReduced: Float = 0f,
    val boostDuration: Long = 0L
)
