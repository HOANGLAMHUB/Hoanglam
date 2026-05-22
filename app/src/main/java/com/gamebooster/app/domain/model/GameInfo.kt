package com.gamebooster.app.domain.model

data class GameInfo(
    val packageName: String,
    val appName: String,
    val icon: ByteArray? = null,
    val versionName: String = "",
    val installTime: Long = 0L,
    val updateTime: Long = 0L,
    val isBoosted: Boolean = false,
    val boostLevel: Int = 0,
    val lastBoostTime: Long = 0L
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as GameInfo

        if (packageName != other.packageName) return false
        if (appName != other.appName) return false
        if (icon != null) {
            if (other.icon == null) return false
            if (!icon.contentEquals(other.icon)) return false
        } else if (other.icon != null) return false
        if (versionName != other.versionName) return false

        return true
    }

    override fun hashCode(): Int {
        var result = packageName.hashCode()
        result = 31 * result + appName.hashCode()
        result = 31 * result + (icon?.contentHashCode() ?: 0)
        return result
    }
}
