package com.gamebooster.app.util

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat
import timber.log.Timber

class PermissionManager(private val context: Context) {

    fun hasPermission(permission: String): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ContextCompat.checkSelfPermission(
                context,
                permission
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
    }

    fun hasAllPermissions(permissions: Array<String>): Boolean {
        return permissions.all { hasPermission(it) }
    }

    fun getMissingPermissions(permissions: Array<String>): Array<String> {
        return permissions.filter { !hasPermission(it) }.toTypedArray()
    }

    fun checkGameBoosterPermissions(): Boolean {
        val requiredPermissions = arrayOf(
            android.Manifest.permission.PACKAGE_USAGE_STATS,
            android.Manifest.permission.READ_EXTERNAL_STORAGE,
            android.Manifest.permission.QUERY_ALL_PACKAGES
        )
        return hasAllPermissions(requiredPermissions).also {
            if (!it) {
                Timber.w("Missing permissions: ${getMissingPermissions(requiredPermissions).toList()}")
            }
        }
    }
}
