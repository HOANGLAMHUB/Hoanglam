package com.gamebooster.app.di

import android.content.Context
import com.gamebooster.app.data.system.FileSystemCleaner
import com.gamebooster.app.data.system.PerformanceProfiler
import com.gamebooster.app.data.system.SecurityMonitor
import com.gamebooster.app.util.BatteryOptimizer
import com.gamebooster.app.util.DeviceInfoHelper
import com.gamebooster.app.util.DisplayOptimizer
import com.gamebooster.app.util.NetworkOptimizer
import com.gamebooster.app.util.PermissionManager
import com.gamebooster.app.util.ProcessManager
import com.gamebooster.app.util.StorageAnalyzer
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object UtilModule {

    @Provides
    @Singleton
    fun providePermissionManager(
        @ApplicationContext context: Context
    ): PermissionManager = PermissionManager(context)

    @Provides
    @Singleton
    fun provideDeviceInfoHelper(
        @ApplicationContext context: Context
    ): DeviceInfoHelper = DeviceInfoHelper(context)

    @Provides
    @Singleton
    fun provideNetworkOptimizer(
        @ApplicationContext context: Context
    ): NetworkOptimizer = NetworkOptimizer(context)

    @Provides
    @Singleton
    fun provideBatteryOptimizer(
        @ApplicationContext context: Context
    ): BatteryOptimizer = BatteryOptimizer(context)

    @Provides
    @Singleton
    fun provideDisplayOptimizer(
        @ApplicationContext context: Context
    ): DisplayOptimizer = DisplayOptimizer(context)

    @Provides
    @Singleton
    fun provideProcessManager(
        @ApplicationContext context: Context
    ): ProcessManager = ProcessManager(context)

    @Provides
    @Singleton
    fun provideStorageAnalyzer(
        @ApplicationContext context: Context
    ): StorageAnalyzer = StorageAnalyzer(context)

    @Provides
    @Singleton
    fun providePerformanceProfiler(): PerformanceProfiler = PerformanceProfiler()

    @Provides
    @Singleton
    fun provideFileSystemCleaner(
        @ApplicationContext context: Context
    ): FileSystemCleaner = FileSystemCleaner(context)

    @Provides
    @Singleton
    fun provideSecurityMonitor(
        @ApplicationContext context: Context
    ): SecurityMonitor = SecurityMonitor(context)
}
