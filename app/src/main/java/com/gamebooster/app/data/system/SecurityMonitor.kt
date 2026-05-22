package com.gamebooster.app.data.system

import android.content.Context
import android.content.pm.PackageManager
import timber.log.Timber

class SecurityMonitor(private val context: Context) {

    private val packageManager = context.packageManager

    fun checkSuspiciousApps(): List<SuspiciousApp> {
        return try {
            val suspiciousApps = mutableListOf<SuspiciousApp>()
            val packages = packageManager.getInstalledApplications(
                PackageManager.GET_PERMISSIONS or PackageManager.GET_META_DATA
            )

            for (app in packages) {
                val permissions = packageManager.getPackageInfo(
                    app.packageName,
                    PackageManager.GET_PERMISSIONS
                ).requestedPermissions ?: emptyArray()

                val suspiciousPerms = permissions.filter {
                    isSuspiciousPermission(it)
                }

                if (suspiciousPerms.isNotEmpty()) {
                    suspiciousApps.add(
                        SuspiciousApp(
                            packageName = app.packageName,
                            appName = app.loadLabel(packageManager).toString(),
                            suspiciousPermissions = suspiciousPerms,
                            riskLevel = calculateRiskLevel(suspiciousPerms)
                        )
                    )
                }
            }

            suspiciousApps.sortByDescending { it.riskLevel }
        } catch (e: Exception) {
            Timber.e(e)
            emptyList()
        }
    }

    private fun isSuspiciousPermission(permission: String): Boolean {
        val suspiciousPermissions = listOf(
            "android.permission.READ_CONTACTS",
            "android.permission.READ_CALL_LOG",
            "android.permission.ACCESS_FINE_LOCATION",
            "android.permission.RECORD_AUDIO",
            "android.permission.CAMERA",
            "android.permission.READ_SMS",
            "android.permission.READ_EXTERNAL_STORAGE"
        )
        return permission in suspiciousPermissions
    }

    private fun calculateRiskLevel(permissions: List<String>): Int {
        return when {
            permissions.size > 5 -> 3 // High risk
            permissions.size > 2 -> 2 // Medium risk
            else -> 1 // Low risk
        }
    }

    data class SuspiciousApp(
        val packageName: String,
        val appName: String,
        val suspiciousPermissions: List<String>,
        val riskLevel: Int
    )
}
