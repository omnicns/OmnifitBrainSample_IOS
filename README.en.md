# OmnifitBrain
> Read in Korean: [KOREAN](README.md)

## App Settings
1. Copy BrainSample > Frameworks and add it to your project.
2. Go to Targets > General > Frameworks, Libraries, and Embedded Content, click the + button, and add BrainLib.xcframework.
3. Add Bluetooth permission to Info.plist<br/>
* Privacy - Bluetooth Always Usage Description<br/>
* Privacy - Bluetooth Peripheral Usage Description<br/>
4. BrainManager can be customized to suit your needs.

## Summary

This library is to support creating Android apps that can provide services using a device corresponding to Brain headsets among Omnifit products.
The functions provided by the library are organized below.

* Scanning/Cancelling Brain Headsets
* Connecting/Disconnecting Brain Headset
* Scanning and Connecting Brain Headset in Sequential
* Starting/terminating Measurement (Acquiring EEG Data)
* Obtaining Brain Score
* Obtaining Headset Information
* Monitoring Headset Status; connectivity status, electrode sensor attachment status, battery remaining, and more.

** The state indicating whether it is being searched, being connected, being measured, the state of the device, and the measured EEG data are all provided using Android's LiveData library.**

<br/>
### Starting/terminating Measurement

<br/>

When you call the **startMeasuring function**, the measurement starts and the **isMeasuring value** changes to true.<br/>
When the isMeasuring value is true, if you call the **stopMeasuring function**, the isMeasuring value changes to false and the measurement ends.
Or, when the measurement time passed as an argument ends, the measurement ends.<br/>
When the measurement starts, [LiveData] called **measurementResult** is updated every 2 seconds.<br/>
The details of the set EEG measurement data are as follows.

### Obtaining measurementResult [LiveData]

|**Property**|**Data Classification**|**Definition**|**Range**|
|:---:|:---:|:---:|:---:|
|isLossOccur|`Packet loss occurrence check value`|boolean to check whether packet loss has occurred|true, false|
|leftThetaIndicatorValue|`Left brain theta size value`|size value for absolute power of left brain theta wave(4-8Hz)|0~10|
|rightThetaIndicatorValue|`Right brain theta size value`|size value for absolute power of right brain theta wave(4-8Hz)|0~10|
|leftAlphaIndicatorValue|`Left brain alpha size value`|size value for absolute power of left brain alpha wave(8-12Hz)|0~10|
|rightAlphaIndicatorValue|`Right brain alpha size value`|size value for absolute power of right brain alpha wave(8-12Hz)|0~10|
|leftLowBetaIndicatorValue|`Left brain low-beta size value`|size value for absolute power of left brain low-beta wave(12-15Hz)|0~10|
|rightLowBetaIndicatorValue|`Right brain low-beta size value`|size value for absolute power of right brain low-beta wave(12-15Hz)|0~10|
|leftMiddleBetaIndicatorValue|`Left brain middle-beta size value`|size value for absolute power of left brain middle-beta wave(15-20Hz)|0~10|
|rightMiddleBetaIndicatorValue|`Right brain middle-beta size value`|size value for absolute power of right brain middle-beta wave(15-20Hz)|0~10|
|leftHighBetaIndicatorValue|`Left brain high-beta size value`|size value for absolute power of left brain high-beta wave(20-30Hz)|0~10|
|rightHighBetaIndicatorValue|`Right brain high-beta size value`|size value for absolute power of right brain high-beta wave(20-30Hz)|0~10|
|leftGammaIndicatorValue|`Left brain gamma size value`|size value for absolute power of left brain gamma wave(30-40Hz)|0~10|
|rightGammaIndicatorValue|`Right brain gamma size value`|size value for absolute power of right brain gamma wave(30-40Hz)|0~10|
|concentrationIndicatorValue|`Concentration size value`|size value of concentration|0~10|
|leftRelaxationIndicatorValue|`Left brain relaxation size value`|size value of left brain relaxation|0~10|
|rightRelaxationIndicatorValue|`Right brain relaxation size value`|size value of right brain relaxation|0~10|
|unbalanceIndicatorValue|`Left-Right brain balance size value`|size value of left-right brain balance|0~10|
|leftPowerSpectrum|`Left Brain Power Spectrum`|left brain power spectrum (double array with indices 0 to 81)|each element is between 0 and 655.35|
|rightPowerSpectrum|`Right Brain Power Spectrum`|right brain power spectrum (double array with indices 0 to 81)|each element is between 0 and 655.35|
|leftThetaPowerSpectrum|`Left brain theta power spectrum value`|theta power spectrum value of left brain|0~655.35 * 8|
|rightThetaPowerSpectrum|`Right brain theta power spectrum value`|theta power spectrum value of right brain|0~655.35 * 8|
|leftAlphaPowerSpectrum|`Left brain alpha power spectrum value`|alpha power spectrum value of left brain|0~655.35 * 8|
|rightAlphaPowerSpectrum|`Right brain alpha power spectrum value`|alpha power spectrum value of right brain|0~655.35 * 8|
|leftLowBetaPowerSpectrum|`Left brain low-beta power spectrum value`|low-beta power spectrum value of left brain|0~655.35 * 6|
|rightLowBetaPowerSpectrum|`Right brain low-beta power spectrum value`|low-beta power spectrum value of right brain|0~655.35 * 6|
|leftMidBetaPowerSpectrum|`Left brain middle-beta power spectrum value`|middle-beta power spectrum value of left brain|0~655.35 * 10|
|rightMidBetaPowerSpectrum|`Right brain middle-beta power spectrum value`|middle-beta power spectrum value of right brain|0~655.35 * 10|
|leftHighBetaPowerSpectrum|`Left brain high-beta power spectrum value`|high-beta power spectrum value of left brain|0~655.35 * 21|
|rightHighBetaPowerSpectrum|`Right brain high-beta power spectrum value`|high-beta power spectrum value of right brain|0~655.35 * 21|
|leftGammaPowerSpectrum|`Left brain gamma power spectrum value`|gamma power spectrum value of left brain|0~655.35 * 21|
|rightGammaPowerSpectrum|`Right brain gamma power spectrum value`|gamma power spectrum value of right brain|0~655.35 * 21|
|leftTotalPowerSpectrum|`Left brain total power spectrum value`|total power spectrum value of left brain|0~655.35 * 82|
|rightTotalPowerSpectrum|`Right brain total power spectrum value`|total power spectrum value of right brain|0~655.35 * 82|
|leftThetaRatio|`Left brain theta ratio`|ratio of left brain theta waves|0~100|
|leftAlphaRatio|`Left brain alpha ratio`|ratio of left brain alpha waves|0~100|
|leftLowBetaRatio|`Left brain low-beta ratio`|ratio of left brain low-beta waves|0~100|
|leftMidBetaRatio|`Left brain middle-beta ratio`|ratio of left brain middle-beta waves|0~100|
|leftHighBetaRatio|`Left brain high-beta ratio`|ratio of left brain high-beta waves|0~100|
|leftGammaRatio|`Left brain gamma ratio`|ratio of left brain gamma waves|0~100|
|rightThetaRatio|`Right brain theta ratio`|ratio of right brain theta waves|0~100|
|rightAlphaRatio|`Right brain alpha ratio`|ratio of right brain alpha waves|0~100|
|rightLowBetaRatio|`Right brain low-beta ratio`|ratio of right brain low-beta waves|0~100|
|rightMidBetaRatio|`Right brain middle-beta ratio`|ratio of right brain middle-beta waves|0~100|
|rightHighBetaRatio|`Right brain high-beta ratio`|ratio of right brain high-beta waves|0~100|
|rightGammaRatio|`Right brain gamma ratio`|ratio of right brain gamma waves|0~100|
|leftSEF90|`Left brain SEF90`|left brain SEF90|0~36.11|
|rightSEF90|`Right brain SEF90`|right brain SEF90|0~36.11|

<br/>

#### Power spectral interval (frequency increment per index is 0.488 Hz)

|**Data Classification**|**Hz Range**|**Index Range**|**Count**|
|:---:|:---:|:---:|:---:|
|THETA|4 ~ 8Hz|left/rightPowerSpectrum[8 ~ 15]|8|
|ALPHA|8 ~ 12Hz|left/rightPowerSpectrum[16 ~ 23]|8|
|L-BETA|12 ~ 15Hz|left/rightPowerSpectrum[24 ~ 29]|6|
|M-BETA|15 ~ 20Hz|left/rightPowerSpectrum[30 ~ 39]|10|
|H-BETA|20 ~ 30Hz|left/rightPowerSpectrum[40 ~ 60]|21|
|GAMMA|30 ~ 40Hz|left/rightPowerSpectrum[61 ~ 81]|21|

<br/>

#### Use of Result data size values

The properties up to leftThetaIndicatorValue, rightThetaIndicatorValue, leftAlphaIndicatorValue, ..., leftRelaxationIndicatorValue, rightRelaxationIndicatorValue, and unbalanceIndicatorValue of Result data have size values.

![img.png](img.png)

* For all other properties except unbalanceIndicatorValue, 5 is the standard, and the more it converges to 0, the lower the state. Converging to 10 means a very high state.
* As for unbalanceIndicatorValue, 5 means left and right brain balance, and as it converges to 0, it means that the right brain is activated, and as it converges to 10, it means that the left brain is activated.

<br/>

#### startMeasuring() Function Parameters

> measuringTime : measurement run time. 60 is declared as a default parameter.<br/>
> eyeState      : state of whether the eyes are open or closed. CLOSED is declared as a default parameter.<br/>
> onError       : A callback that is called when an error occurs. Throwable is passed as an argument.

#### Usage Example

```kotlin
// Start device measurement
viewModel.startMeasuring(measuringTime = 60, eyesState = Result.EyesState.CLOSED, onError = { throwable ->
    runOnUiThread {
      Toast.makeText(applicationContext, throwable.message.toString(), Toast.LENGTH_SHORT).show()
    }
})
// End device measurement
viewModel.stopMeasuring()
// Check measurement status
viewModel.isMeasuring.observe(this@SampleActivity) { value ->
  if (value) {
    // true -> 'Measuring'
  } else {
    // false -> 'Waiting'
  }
}
// EEG data
viewModel.result.observe(this@SampleActivity) { value ->
    println("Result : $value")
}
```

<br/>

### Obtaining Brain Score
    
You can get the brain score by calling the **getBrainScore() function** of the ViewModel.
The function requires an ArrayList<Result> as an argument, and returns an Int value.
<br/>
However, IllegalArgumentException is thrown if the list passed as an argument is empty or the entire EEG data cannot be used because the device is worn incorrectly during measurement.
Errors can be checked through the message property of the error object.

#### getBrainScore() Function Parameters

> results : ArrayList<Result> type parameter. While the measurement is in progress, collect the Result data class as an ArrayList and pass it as an argument.

#### Usage Example
```kotlin
// resultList(Assume ArrayList<Result> is not empty)
try {
    val score = viewModel.getBrainScore(resultList)
    println("[SCORE] : $score")
} catch (e: IllegalArgumentException) {
    println("[IllegalArgumentException] - error : ${e.message}")
}
```

<br/>
    
### Obtaining Headset Information

Once the connection with the device is established, you can get the **device serial number, measurement state transition time, and signal stability threshold**.<br/>
When you call the following functions, the result is passed to the callback function.

* Device serial number: A serial number assigned to the device
* Measurement status conversion time: Measurement status conversion time value applied to the device
* Signal stabilization reference value: EEG stabilization value recorded in the device

#### Usage Example

```kotlin
// Device serial number
viewModel.readSerialNo(block = { serialNumber ->
    Toast.makeText(applicationContext, serialNumber, Toast.LENGTH_LONG).show()
})

// Measurement status conversion time
viewModel.readMeasureStartChangeTime(block = { time ->
    Toast.makeText(applicationContext, time, Toast.LENGTH_LONG).show()
})

// Signal stabilization reference value
viewModel.readSignalStability(block = { signalStability ->
    Toast.makeText(applicationContext, signalStability, Toast.LENGTH_LONG).show()
})
```

<br/>

### Monitoring Headset Status

You can use the following LiveData to determine the current state of your device.

* electrodeStatus : electrode sensor attachment status
* batteryLevel : remaining battery status
* eegStabilityValue : eeg stability status

#### Electrode Sensor Attachment Status

```kotlin
/**
 * ALL_DETACHED -> all detached
 * LEFT_ELECTRODE_DETACHED -> left eeg sensor detached
 * RIGHT_ELECTRODE_DETACHED -> right eeg sensor detached
 * LEFT_EARPHONE_DETACHED -> left earphone detached
 * RIGHT_EARPHONE_DETACHED -> right earphone detached
 * ALL_ATTACHED -> all attached
 */
viewModel.electrodeStatus.observe(this@SampleActivity) { state ->
    when (state) {
        Result.Electrode.ALL_DETACHED              -> {}
        Result.Electrode.LEFT_ELECTRODE_DETACHED   -> {}
        Result.Electrode.RIGHT_ELECTRODE_DETACHED  -> {}
        Result.Electrode.LEFT_EARPHONE_DETACHED    -> {}
        Result.Electrode.RIGHT_EARPHONE_DETACHED   -> {}
        Result.Electrode.ALL_ATTACHED              -> {}
    }
}
```

<br/>

#### Remaining Battery Status

```kotlin
/**
 * INSUFFICIENT -> device battery is low
 * SUFFICIENT -> device battery is sufficient
 */
viewModel.batteryLevel.observe(this@SampleActivity) { level ->
    when (level) {
        Result.BatteryLevel.INSUFFICIENT -> {}
        Result.BatteryLevel.SUFFICIENT   -> {}
    }
}
```

<br/>

#### EEG Stability Status

```kotlin
/**
 * UNSTABILIZED -> unstabilized eeg
 * STABILIZED -> stabilized eeg
 */
viewModel.eegStabilityValue.observe(this@MainActivity) { value ->
    when (value) {
        Result.EEGStability.UNSTABILIZED -> {}
        Result.EEGStability.STABILIZED   -> {}
    }
}
```

<br/>

### Setting Library Reference

#### Gradle File (App Level)

```groovy
dependencies {
    implementation 'omnifit.sdk:omnifit-brain-ktx:0.0.4'
}
```

<br/>

#### settings.gradle File

```groovy
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven { url 'http://maven.omnicns.co.kr/nexus/content/repositories/releases/'; allowInsecureProtocol true }
    }
}
```

<br/>

## License

    Copyright 2022 omniC&S

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software

<br/>
