package com.gamebooster.app.di

import android.content.Context
import com.gamebooster.app.data.system.AdvancedBoostEngine
import com.gamebooster.app.presentation.overlay.FloatingOverlayManager
import com.gamebooster.app.presentation.notification.NotificationManager as NotifManager
import com.gamebooster.app.util.FlagshipIntegration
import com.gamebooster.app.util.GamingProfiler
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AdvancedModule {

    @Provides
    @Singleton
    fun provideFloatingOverlayManager(
        @ApplicationContext context: Context
    ): FloatingOverlayManager = FloatingOverlayManager(context)

    @Provides
    @Singleton
    fun provideNotificationManager(
        @ApplicationContext context: Context
    ): NotifManager = NotifManager(context)

    @Provides
    @Singleton
    fun provideAdvancedBoostEngine(
        @ApplicationContext context: Context
    ): AdvancedBoostEngine = AdvancedBoostEngine(context)

    @Provides
    @Singleton
    fun provideFlagshipIntegration(
        @ApplicationContext context: Context
    ): FlagshipIntegration = FlagshipIntegration(context)

    @Provides
    @Singleton
    fun provideGamingProfiler(
        @ApplicationContext context: Context
    ): GamingProfiler = GamingProfiler(context)
}
