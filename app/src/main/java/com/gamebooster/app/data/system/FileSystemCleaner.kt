package com.gamebooster.app.data.system

import android.content.Context
import timber.log.Timber
import java.io.File

class FileSystemCleaner(private val context: Context) {

    fun clearAppCache(): Long {
        return try {
            var clearedSize = 0L
            context.cacheDir.let {
                if (it.exists()) {
                    clearedSize += deleteDir(it)
                }
            }
            Timber.d("Cleared ${clearedSize / (1024 * 1024)}MB from cache")
            clearedSize
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }

    fun clearTemporaryFiles(): Long {
        return try {
            var clearedSize = 0L
            val tempDir = File(context.filesDir, "temp")
            if (tempDir.exists()) {
                clearedSize += deleteDir(tempDir)
            }
            Timber.d("Cleared ${clearedSize / (1024 * 1024)}MB from temp")
            clearedSize
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }

    fun clearOldFiles(olderThanDays: Int = 7): Long {
        return try {
            var clearedSize = 0L
            val filesDir = context.filesDir
            val currentTime = System.currentTimeMillis()
            val thresholdTime = currentTime - (olderThanDays * 24 * 60 * 60 * 1000L)

            filesDir.listFiles()?.forEach { file ->
                if (file.lastModified() < thresholdTime) {
                    clearedSize += if (file.isDirectory) {
                        deleteDir(file)
                    } else {
                        file.length().also { file.delete() }
                    }
                }
            }

            Timber.d("Cleared ${clearedSize / (1024 * 1024)}MB old files")
            clearedSize
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }

    fun deleteDir(dir: File): Long {
        return try {
            var size = 0L
            dir.listFiles()?.forEach { file ->
                size += if (file.isDirectory) {
                    deleteDir(file)
                } else {
                    file.length().also { file.delete() }
                }
            }
            dir.delete()
            size
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }

    fun getDirSize(dir: File): Long {
        return try {
            if (!dir.exists()) return 0L
            if (dir.isFile) return dir.length()

            var size = 0L
            dir.listFiles()?.forEach { file ->
                size += if (file.isDirectory) getDirSize(file) else file.length()
            }
            size
        } catch (e: Exception) {
            Timber.e(e)
            0L
        }
    }
}
