package com.gamebooster.app.data.repository

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.drawable.Drawable
import com.gamebooster.app.domain.model.GameInfo
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import timber.log.Timber
import javax.inject.Inject

class GameRepositoryImpl @Inject constructor(
    private val context: Context
) : GameRepository {

    private val packageManager: PackageManager = context.packageManager

    override fun getInstalledGames(): Flow<List<GameInfo>> = flow {
        try {
            val games = mutableListOf<GameInfo>()
            val packages = packageManager.getInstalledApplications(
                PackageManager.GET_META_DATA
            )

            for (app in packages) {
                if (isGameApp(app)) {
                    val gameInfo = createGameInfo(app)
                    games.add(gameInfo)
                }
            }

            emit(games.sortedBy { it.appName })
        } catch (e: Exception) {
            Timber.e(e, "Error getting installed games")
            emit(emptyList())
        }
    }.flowOn(Dispatchers.IO)

    override fun getGameDetails(packageName: String): Flow<GameInfo?> = flow {
        try {
            val appInfo = packageManager.getApplicationInfo(
                packageName,
                PackageManager.GET_META_DATA
            )
            emit(createGameInfo(appInfo))
        } catch (e: PackageManager.NameNotFoundException) {
            Timber.e(e, "Game not found: $packageName")
            emit(null)
        }
    }.flowOn(Dispatchers.IO)

    override suspend fun updateGameBoostStatus(
        packageName: String,
        isBoosted: Boolean
    ) {
        // Implement boost status persistence using SharedPreferences or Room
        val prefs = context.getSharedPreferences(
            "game_boost_prefs",
            Context.MODE_PRIVATE
        )
        prefs.edit().putBoolean(packageName, isBoosted).apply()
    }

    override suspend fun getGameIcon(packageName: String): ByteArray? {
        return try {
            val drawable = packageManager.getApplicationIcon(packageName)
            drawableToByteArray(drawable)
        } catch (e: PackageManager.NameNotFoundException) {
            null
        }
    }

    private fun isGameApp(app: ApplicationInfo): Boolean {
        val flags = app.flags
        val isSystemApp = (flags and ApplicationInfo.FLAG_SYSTEM) != 0
        val isGameApp = app.category == ApplicationInfo.CATEGORY_GAME

        return !isSystemApp || isGameApp
    }

    private fun createGameInfo(appInfo: ApplicationInfo): GameInfo {
        val label = try {
            packageManager.getApplicationLabel(appInfo).toString()
        } catch (e: Exception) {
            appInfo.packageName
        }

        val prefs = context.getSharedPreferences(
            "game_boost_prefs",
            Context.MODE_PRIVATE
        )
        val isBoosted = prefs.getBoolean(appInfo.packageName, false)

        return GameInfo(
            packageName = appInfo.packageName,
            appName = label,
            versionName = getVersionName(appInfo.packageName),
            installTime = appInfo.firstInstallTime,
            updateTime = appInfo.lastUpdateTime,
            isBoosted = isBoosted
        )
    }

    private fun getVersionName(packageName: String): String {
        return try {
            packageManager.getPackageInfo(packageName, 0).versionName ?: "1.0"
        } catch (e: PackageManager.NameNotFoundException) {
            "1.0"
        }
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        // Convert drawable to bytearray implementation
        return ByteArray(0)
    }
}
