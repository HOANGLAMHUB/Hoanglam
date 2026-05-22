package com.gamebooster.app.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.gamebooster.app.data.system.SystemManager
import com.gamebooster.app.domain.model.DeviceSpecs
import com.gamebooster.app.util.DeviceInfoHelper
import com.gamebooster.app.util.BatteryOptimizer
import com.gamebooster.app.util.DisplayOptimizer
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import timber.log.Timber
import javax.inject.Inject

@HiltViewModel
class AdvancedStatsViewModel @Inject constructor(
    private val systemManager: SystemManager,
    private val deviceInfoHelper: DeviceInfoHelper,
    private val batteryOptimizer: BatteryOptimizer,
    private val displayOptimizer: DisplayOptimizer
) : ViewModel() {

    private val _deviceSpecs = MutableStateFlow(DeviceSpecs())
    val deviceSpecs = _deviceSpecs.asStateFlow()

    private val _batteryInfo = MutableStateFlow(BatteryOptimizer.BatteryInfo())
    val batteryInfo = _batteryInfo.asStateFlow()

    private val _displayInfo = MutableStateFlow(DisplayOptimizer.DisplayInfo())
    val displayInfo = _displayInfo.asStateFlow()

    init {
        loadDeviceSpecs()
        updateBatteryInfo()
        updateDisplayInfo()
    }

    private fun loadDeviceSpecs() {
        viewModelScope.apply {
            try {
                _deviceSpecs.value = DeviceSpecs(
                    manufacturer = deviceInfoHelper.getDeviceManufacturer(),
                    model = deviceInfoHelper.getDeviceModel(),
                    androidVersion = deviceInfoHelper.getAndroidVersionName(),
                    apiLevel = deviceInfoHelper.getAndroidVersion(),
                    cpuCores = deviceInfoHelper.getCPUCount(),
                    totalRam = deviceInfoHelper.getTotalRAM(),
                    totalStorage = deviceInfoHelper.getTotalStorage(),
                    displayDpi = displayOptimizer.getDisplayInfo().screenDpi,
                    displayRefreshRate = displayOptimizer.getRefreshRate()
                )
            } catch (e: Exception) {
                Timber.e(e, "Error loading device specs")
            }
        }
    }

    private fun updateBatteryInfo() {
        _batteryInfo.value = batteryOptimizer.getBatteryInfo()
    }

    private fun updateDisplayInfo() {
        _displayInfo.value = displayOptimizer.getDisplayInfo()
    }

    fun refreshAllStats() {
        loadDeviceSpecs()
        updateBatteryInfo()
        updateDisplayInfo()
    }
}
