package com.gamebooster.app.util

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import timber.log.Timber

class NetworkOptimizer(private val context: Context) {

    fun isNetworkAvailable(): Boolean {
        return try {
            val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val network = connectivityManager.activeNetwork ?: return false
                val capabilities = connectivityManager.getNetworkCapabilities(network) ?: return false
                capabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            } else {
                connectivityManager.activeNetworkInfo?.isConnected ?: false
            }
        } catch (e: Exception) {
            Timber.e(e)
            false
        }
    }

    fun getNetworkType(): NetworkType {
        return try {
            val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val network = connectivityManager.activeNetwork ?: return NetworkType.NONE
                val capabilities = connectivityManager.getNetworkCapabilities(network) ?: return NetworkType.NONE
                when {
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> NetworkType.WIFI
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> NetworkType.CELLULAR
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> NetworkType.ETHERNET
                    else -> NetworkType.UNKNOWN
                }
            } else {
                when (connectivityManager.activeNetworkInfo?.type) {
                    ConnectivityManager.TYPE_WIFI -> NetworkType.WIFI
                    ConnectivityManager.TYPE_MOBILE -> NetworkType.CELLULAR
                    else -> NetworkType.UNKNOWN
                }
            }
        } catch (e: Exception) {
            Timber.e(e)
            NetworkType.UNKNOWN
        }
    }

    enum class NetworkType {
        WIFI, CELLULAR, ETHERNET, NONE, UNKNOWN
    }
}
