package com.gamebooster.app.util

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import timber.log.Timber

class GamingProfiler(private val context: Context) {

    private val packageManager = context.packageManager

    fun detectInstalledGames(): List<GameProfile> {
        return try {
            val games = mutableListOf<GameProfile>()
            val packages = packageManager.getInstalledApplications(
                PackageManager.GET_META_DATA
            )

            val knownGamePackages = setOf(
                // Popular Games
                "com.tencent.ig", // PUBG Mobile
                "com.tencent.tmgp.cod", // Call of Duty Mobile
                "com.netease.legou", // Diablo Immortal
                "com.miHoYo.GenshinImpact", // Genshin Impact
                "com.mihoyo.hk4e.gp", // Genshin Impact Global
                "com.nexon.maplemobile", // MapleStory M
                "com.garena.game.ffh", // Final Fantasy VII
                "com.mojang.minecraftpe", // Minecraft
                "com.gameloft.android.ANMP.GloftFTXM", // Asphalt 9
                "com.supercell.clashroyale", // Clash Royale
                "com.supercell.clashofclans", // Clash of Clans
                "com.playrix.gardenscapes2", // Gardenscapes
                "com.king.candycrushsoda", // Candy Crush
                "com.activision.callofduty.shooter", // COD Mobile
                "com.pearlabyss.blackdesertm", // Black Desert Mobile
                "com.square_enix.android_googleplay.mff", // Marvel Future Fight
                "com.bandainamcoent.sao_integral_factor", // SAO Integral Factor
                "com.Level5.DBZDokkanBattle.gl", // Dragon Ball Z Dokkan
                "jp.co.square_enix.android_googleplay.ffrk", // Final Fantasy Record Keeper
                "com.joga.football2023", // eFootball 2023
                "com.ea.gp.fifamobile" // FIFA Mobile
            )

            for (app in packages) {
                if (isGameApp(app) || app.packageName in knownGamePackages) {
                    val gameProfile = GameProfile(
                        packageName = app.packageName,
                        appName = app.loadLabel(packageManager).toString(),
                        category = getGameCategory(app.packageName),
                        isPopular = app.packageName in knownGamePackages,
                        estimatedRequirements = estimateGameRequirements(app.packageName),
                        optimizationLevel = getOptimizationLevel(app.packageName)
                    )
                    games.add(gameProfile)
                }
            }

            games.sortedByDescending { it.isPopular }
        } catch (e: Exception) {
            Timber.e(e)
            emptyList()
        }
    }

    private fun isGameApp(app: ApplicationInfo): Boolean {
        return app.category == ApplicationInfo.CATEGORY_GAME ||
                (app.flags and ApplicationInfo.FLAG_SYSTEM) == 0
    }

    private fun getGameCategory(packageName: String): String {
        return when {
            packageName.contains("clash") -> "Strategy"
            packageName.contains("pubg") || packageName.contains("cod") -> "Action"
            packageName.contains("candy", ignoreCase = true) -> "Casual"
            packageName.contains("minecraft", ignoreCase = true) -> "Adventure"
            packageName.contains("nba", ignoreCase = true) || packageName.contains("fifa") -> "Sports"
            else -> "Unknown"
        }
    }

    private fun estimateGameRequirements(packageName: String): GameRequirements {
        return when {
            // High-end games
            packageName.contains("pubg") ||
            packageName.contains("cod") ||
            packageName.contains("genshin") -> GameRequirements(
                minRAM = 4,
                minCPUCores = 4,
                minStorageGB = 5,
                recommendedRAM = 8,
                recommendedCPUCores = 8,
                recommendedStorageGB = 10,
                minFPS = 30,
                targetFPS = 60
            )
            // Mid-range games
            packageName.contains("clash") ||
            packageName.contains("candy") -> GameRequirements(
                minRAM = 2,
                minCPUCores = 2,
                minStorageGB = 1,
                recommendedRAM = 4,
                recommendedCPUCores = 4,
                recommendedStorageGB = 2,
                minFPS = 30,
                targetFPS = 60
            )
            else -> GameRequirements() // Default
        }
    }

    private fun getOptimizationLevel(packageName: String): Int {
        return when {
            packageName.contains("pubg") ||
            packageName.contains("cod") -> 3 // High priority
            packageName.contains("clash") -> 2 // Medium priority
            else -> 1 // Low priority
        }
    }

    data class GameProfile(
        val packageName: String,
        val appName: String,
        val category: String,
        val isPopular: Boolean,
        val estimatedRequirements: GameRequirements,
        val optimizationLevel: Int
    )

    data class GameRequirements(
        val minRAM: Int = 1,
        val minCPUCores: Int = 2,
        val minStorageGB: Int = 1,
        val recommendedRAM: Int = 2,
        val recommendedCPUCores: Int = 4,
        val recommendedStorageGB: Int = 2,
        val minFPS: Int = 30,
        val targetFPS: Int = 60
    )
}
