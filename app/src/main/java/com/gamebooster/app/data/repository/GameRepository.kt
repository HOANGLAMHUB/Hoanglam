package com.gamebooster.app.data.repository

import com.gamebooster.app.domain.model.GameInfo
import kotlinx.coroutines.flow.Flow

interface GameRepository {
    fun getInstalledGames(): Flow<List<GameInfo>>
    fun getGameDetails(packageName: String): Flow<GameInfo?>
    suspend fun updateGameBoostStatus(packageName: String, isBoosted: Boolean)
    suspend fun getGameIcon(packageName: String): ByteArray?
}
