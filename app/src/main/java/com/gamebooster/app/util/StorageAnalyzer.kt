package com.gamebooster.app.util

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Environment
import timber.log.Timber

class StorageAnalyzer(private val context: Context) {

    private val packageManager = context.packageManager

    fun getTotalCacheSize(): Long {
        return try {
            var totalSize = 0L
            val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
            for (app in packages) {
                totalSize += getAppCacheSize(app.packageName)
            }
            totalSize
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }

    fun getAppCacheSize(packageName: String): Long {
        return try {
            val cacheDir = context.packageManager.getPackageInfo(packageName, 0).let {
                context.cacheDir
            }
            getDirSize(cacheDir)
        } catch (e: Exception) {
            0L
        }
    }

    fun getLargeApps(limit: Int = 10): List<AppStorage> {
        return try {
            val apps = mutableListOf<AppStorage>()
            val packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
            
            for (app in packages) {
                try {
                    val appDir = context.getExternalFilesDir(null)?.parentFile?.child(app.packageName)
                    val size = if (appDir?.exists() == true) getDirSize(appDir) else 0L
                    
                    if (size > 0) {
                        apps.add(
                            AppStorage(
                                packageName = app.packageName,
                                appName = app.loadLabel(packageManager).toString(),
                                size = size
                            )
                        )
                    }
                } catch (e: Exception) {
                    Timber.w(e)
                }
            }
            
            apps.sortByDescending { it.size }.take(limit)
        } catch (e: Exception) {
            Timber.e(e)
            emptyList()
        }
    }

    private fun getDirSize(dir: java.io.File): Long {
        return try {
            if (!dir.exists()) return 0L
            if (dir.isFile) return dir.length()
            
            var size = 0L
            dir.listFiles()?.forEach { file ->
                size += if (file.isDirectory) getDirSize(file) else file.length()
            }
            size
        } catch (e: Exception) {
            0L
        }
    }

    private fun java.io.File.child(name: String): java.io.File {
        return java.io.File(this, name)
    }

    data class AppStorage(
        val packageName: String,
        val appName: String,
        val size: Long
    )
}
