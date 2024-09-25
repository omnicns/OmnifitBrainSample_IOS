# OmnifitBrain
> 영어로 읽기: [ENGLISH](README.en.md)

## 앱 셋팅
1. BrainSample > Frameworks를 복사하여 프로젝트에 추가합니다.
2. Targets > General > Frameworks, Libraries, and Embedded Content로 이동하여 + 버튼을 클릭한 후 BrainLib.xcframework를 추가합니다.
3. Info.plist에 Bluetooth 권한을 추가합니다<br/>
   * Privacy - Bluetooth Always Usage Description<br/>
   * Privacy - Bluetooth Peripheral Usage Description<br/>
4. BrainManager 의 경우 자신에 맞게끔 Custom 해서 사용가능하다.
   
## 개요

본 라이브러리는 옴니핏 제품의 브레인 제품군에 해당하는 장치를 사용하여 
서비스를 제공할 수 있는 안드로이드 앱을 만들 수 있도록 지원하기 위한 것입니다.
라이브러리의 제공되는 기능은 아래와 같이 구성됩니다.

* 브레인 장치 검색 / 취소
* 브레인 장치 연결 / 해제
* 브레인 장치 검색 및 연결 / 취소 및 해제
* 측정 시작 / 종료 (뇌파 데이터 획득)
* 장치 정보 획득
* 장치 상태 모니터링 (연결 상태, 전극 센서 부착 상태, 배터리 잔량)

**검색 중인지를 나타내는 상태, 연결 중인지를 나타내는 상태, 측정 중인지를 나타내는 상태, 뇌파 데이터, 장치 상태 모두 
LiveData 라이브러리를 사용하여 제공하고 있습니다.**

### 측정 시작 / 종료

**startMeasuring 함수**를 호출하면 측정을 시작되고 **isMeasuring 값**이 true로 변경됩니다<br/>
isMeasuring 값이 true 일 때**stopMeasuring 함수**를 호출하면 isMeasuring 값이 false로 바뀌며 측정이 종료됩니다.
또는 인자로 넘긴 측정 시간이 종료되면 측정을 종료합니다.<br/>
측정이 시작되면 2초 단위로 **measurementResult**라는 [LiveData]가 갱신됩니다.<br/>
설정된 뇌파 측정 데이터에 대한 자세한 내용은 다음과 같습니다.

### measurementResult [LiveData] 획득

|**프로퍼티**|**데이터구분**|**의미**|**범위**|
|:---:|:---:|:---:|:---:|
|isLossOccur|`패킷 유실 발생체크값`|패킷 유실이 발생했는지 체크하는값(사용하면 안되는 값인지를 나타냄)|true, false|
|leftThetaIndicatorValue|`좌뇌쎄타 크기판정값`|좌뇌 쎄타파(4-8Hz미만) 절대파워의 크기판정값|0~10|
|rightThetaIndicatorValue|`우뇌쎄타 크기판정값`|우뇌 쎄타파(4-8Hz미만) 절대파워의 크기판정값|0~10|
|leftAlphaIndicatorValue|`좌뇌알파 크기판정값`|좌뇌 알파파(8-12Hz미만) 절대파워의 크기판정값|0~10|
|rightAlphaIndicatorValue|`우뇌알파 크기판정값`|우뇌 알파파(8-12Hz미만) 절대파워의 크기판정값|0~10|
|leftLowBetaIndicatorValue|`좌뇌Low베타 크기판정값`|좌뇌 Low베타파(12-15Hz미만) 절대파워의 크기판정값|0~10|
|rightLowBetaIndicatorValue|`우뇌Low베타 크기판정값`|우뇌 Low베타파(12-15Hz미만) 절대파워의 크기판정값|0~10|
|leftMiddleBetaIndicatorValue|`좌뇌Middle베타 크기판정값`|좌뇌 Middle베타파(15-20Hz미만) 절대파워의 크기판정값|0~10|
|rightMiddleBetaIndicatorValue|`우뇌Middle베타 크기판정값`|우뇌 Middle베타파(15-20Hz미만) 절대파워의 크기판정값|0~10|
|leftHighBetaIndicatorValue|`좌뇌High베타 크기판정값`|좌뇌 High베타파(20-30Hz미만) 절대파워의 크기판정값|0~10|
|rightHighBetaIndicatorValue|`우뇌High베타 크기판정값`|우뇌 High베타파(20-30Hz미만) 절대파워의 크기판정값|0~10|
|leftGammaIndicatorValue|`좌뇌감마 크기판정값`|좌뇌 감마파(30-40Hz미만) 절대파워의 크기판정값|0~10|
|rightGammaIndicatorValue|`우뇌감마 크기판정값`|우뇌 감마파(30-40Hz미만) 절대파워의 크기판정값|0~10|
|concentrationIndicatorValue|`집중 크기판정값`|집중 크기판정값|0~10|
|leftRelaxationIndicatorValue|`좌뇌이완 크기판정값`|좌뇌이완 크기판정값|0~10|
|rightRelaxationIndicatorValue|`우뇌 이완 크기판정값`|우뇌 이완 크기판정값|0~10|
|unbalanceIndicatorValue|`좌우뇌균형 크기판정값`|좌우뇌균형 크기판정값|0~10|
|leftPowerSpectrum|`좌뇌 파워스펙트럼`|좌뇌 파워 스펙트럼(0 ~ 81번 인덱스를 가진 Double Array)|각 인덱스의 값 0~655.35|
|rightPowerSpectrum|`우뇌 파워스펙트럼`|우뇌 파워 스펙트럼(0 ~ 81번 인덱스를 가진 Double Array)|각 인덱스의 값 0~655.35|
|leftThetaPowerSpectrum|`좌뇌세타 파워스펙트럼`|좌뇌세타 파워스펙트럼|0~655.35 * 8|
|rightThetaPowerSpectrum|`우뇌세타 파워스펙트럼`|우뇌세타 파워스펙트럼|0~655.35 * 8|
|leftAlphaPowerSpectrum|`좌뇌알파 파워스펙트럼`|좌뇌알파 파워스펙트럼|0~655.35 * 8|
|rightAlphaPowerSpectrum|`우뇌알파 파워스펙트럼`|우뇌알파 파워스펙트럼|0~655.35 * 8|
|leftLowBetaPowerSpectrum|`좌뇌Low베타 파워스펙트럼`|좌뇌Low베타 파워스펙트럼|0~655.35 * 6|
|rightLowBetaPowerSpectrum|`우뇌Low베타 파워스펙트럼`|우뇌Low베타 파워스펙트럼|0~655.35 * 6|
|leftMidBetaPowerSpectrum|`좌뇌Middle베타 파워스펙트럼`|좌뇌Middle베타 파워스펙트럼|0~655.35 * 10|
|rightMidBetaPowerSpectrum|`우뇌Middle베타 파워스펙트럼`|우뇌Middle베타 파워스펙트럼|0~655.35 * 10|
|leftHighBetaPowerSpectrum|`좌뇌High베타 파워스펙트럼`|좌뇌High베타 파워스펙트럼|0~655.35 * 21|
|rightHighBetaPowerSpectrum|`우뇌High베타 파워스펙트럼`|우뇌High베타 파워스펙트럼|0~655.35 * 21|
|leftGammaPowerSpectrum|`좌뇌감마 파워스펙트럼`|좌뇌감마 파워스펙트럼|0~655.35 * 21|
|rightGammaPowerSpectrum|`우뇌감마 파워스펙트럼`|우뇌감마 파워스펙트럼|0~655.35 * 21|
|leftTotalPowerSpectrum|`좌뇌 파워스펙트럼 합`|좌뇌 파워스펙트럼 합|0~655.35 * 82|
|rightTotalPowerSpectrum|`우뇌 파워스펙트럼 합`|우뇌 파워스펙트럼 합|0~655.35 * 82|
|leftThetaRatio|`좌뇌쎄타 비율`|좌뇌쎄타 비율|0~100|
|leftAlphaRatio|`좌뇌알파 비율`|좌뇌알파 비율|0~100|
|leftLowBetaRatio|`좌뇌Low베타 비율`|좌뇌Low베타 비율|0~100|
|leftMidBetaRatio|`좌뇌Mid베타 비율`|좌뇌Mid베타 비율|0~100|
|leftHighBetaRatio|`좌뇌High베타 비율`|좌뇌High베타 비율|0~100|
|leftGammaRatio|`좌뇌감마 비율`|좌뇌감마 비율|0~100|
|rightThetaRatio|`우뇌쎄타 비율`|우뇌쎄타 비율|0~100|
|rightAlphaRatio|`우뇌알파 비율`|우뇌알파 비율|0~100|
|rightLowBetaRatio|`우뇌Low베타 비율`|우뇌Low베타 비율|0~100|
|rightMidBetaRatio|`우뇌Mid베타 비율`|우뇌Mid베타 비율|0~100|
|rightHighBetaRatio|`우뇌High베타 비율`|우뇌High베타 비율|0~100|
|rightGammaRatio|`우뇌감마 비율`|우뇌감마 비율|0~100|
|leftSEF90|`좌뇌 SEF90`|좌뇌 SEF90|0~36.11|
|rightSEF90|`우뇌 SEF90`|우뇌 SEF90|0~36.11|

<br/>

#### 파워 스펙트럼 구간(1 인덱스당 주파수 증가 단위는 0.488Hz)

|**데이터 구분**|**Hz 범위**|**인덱스 구간**|**수량**|
|:---:|:---:|:---:|:---:|
|THETA|4 ~ 8Hz 미만|left/rightPowerSpectrum[8 ~ 15]|8|
|ALPHA|8 ~ 12Hz 미만|left/rightPowerSpectrum[16 ~ 23]|8|
|L-BETA|12 ~ 15Hz 미만|left/rightPowerSpectrum[24 ~ 29]|6|
|M-BETA|15 ~ 20Hz 미만|left/rightPowerSpectrum[30 ~ 39]|10|
|H-BETA|20 ~ 30Hz 미만|left/rightPowerSpectrum[40 ~ 60]|21|
|GAMMA|30 ~ 40Hz 미만|left/rightPowerSpectrum[61 ~ 81]|21|

<br/>

#### 뇌파 분석 데이터 크기 판정값 활용

뇌파 데이터의 leftThetaIndicatorValue, rightThetaIndicatorValue, leftAlphaIndicatorValue, ... ,
leftRelaxationIndicatorValue, rightRelaxationIndicatorValue, unbalanceIndicatorValue 까지의 프로퍼티는 크기 판정값이 있습니다.

![img.png](img.png)

* unbalanceIndicatorValue를 제외한 나머지 프로퍼티는 5가 표준이며 0에 수렴할수록 매우 낮은 상태를 의미하고,
  10에 수렴할수록 매우 높은 상태를 의미합니다.
* unbalanceIndicatorValue는 5가 좌우뇌 균형을 의미하고 0에 수렴할수록 우뇌가 활성화되었음을 의미하고,
  10에 수렴할수록 좌뇌가 활성화되었음을 의미합니다.

<br/>

#### startMeasuring 함수 매개 변수

> measuringTime : 측정 진행 시간. 디폴트 파라미터로 60초가 선언되어있음.<br/>
> eyeState : 측정하려는 눈의 상태. Opened 와 Closed 두 개의 타입이 존재. 디폴트 파라미터로 CLOSED가 선언되어있음.<br/>
> onError : 에러가 발생했을 때 호출되는 콜백. 인자로 Throwable이 들어옴.

#### 사용 예시

```kotlin
// 장치 측정 시작
viewModel.startMeasuring(measuringTime = 60, eyesState = Result.EyesState.CLOSED, onError = { throwable ->
    runOnUiThread {
      Toast.makeText(applicationContext, throwable.message.toString(), Toast.LENGTH_SHORT).show()
    }
})

// 장치 측정 종료
viewModel.stopMeasuring()

// 측정 상태
viewModel.isMeasuring.observe(this@SampleActivity) { value ->
  if (value) {
    // true -> 측정 중
  } else {
    // false -> 대기 중
  }
}

// 뇌파 데이터
viewModel.result.observe(this@SampleActivity) { value ->
    println("Result : $value")
}
```

<br/>

### 두뇌 점수 획득

ViewModel의 **getBrainScore 함수**를 호출하면 두뇌 점수를 획득할 수 있습니다.
인자로 ArrayList<Result>를 넘기면 되고, 리턴값은 Int 타입의 두뇌 점수입니다.
<br/>
단, getBrainScore는 인자로 넘긴 리스트가 비어있거나, 측정하는 동안 장치를 잘못 착용하여 뇌파 데이터 전체가 사용할 수 없는 경우 IllegalArgumentException을 던집니다.
오류의 내용은 에러 객체의 message 프로퍼티를 통해서 확인할 수 있습니다.

#### getBrainScore 함수 매개 변수

> results : ArrayList<Result> 타입의 매개 변수. 측정이 진행된 시간동안 Result 데이터 클래스를 ArrayList로 모은 후 인자로 넘기면 됨.

#### 사용 예시
```kotlin
// resultList(ArrayList<Result>에 값이 있다고 가정)
try {
    val score = viewModel.getBrainScore(resultList)
    println("[SCORE] : $score")
} catch (e: IllegalArgumentException) {
    println("[IllegalArgumentException] - error : ${e.message}")
}
```

<br/>

### 장치 정보 획득

장치와의 연결이 성립되면 **장치 시리얼 번호, 측정 상태 변환 시간, 신호 안정화 기준값**을 획득할 수 있습니다.<br/>
다음과 같은 함수를 호출하면 콜백 함수로 결과가 전달됩니다.

* 장치 시리얼 번호 : 장치에 부여된 고유번호(Serial number)
* 측정 상태 변환 시간 : 장치에 적용된 측정 상태 변환 시간 값
* 신호 안정화 기준값 : 장치에 기록된 뇌파 안정화 기준 값

#### 사용 예시
```kotlin
// 장치 시리얼 번호
viewModel.readSerialNo(block = { serialNumber ->
    Toast.makeText(applicationContext, serialNumber, Toast.LENGTH_SHORT).show()
})

// 측정 상태 변환 시간
viewModel.readMeasureStartChangeTime(block = { time ->
    Toast.makeText(applicationContext, time, Toast.LENGTH_SHORT).show()
})

// 신호 안정화 기준값
viewModel.readSignalStability(block = { signalStability ->
    Toast.makeText(applicationContext, signalStability, Toast.LENGTH_SHORT).show()
})
```

<br/>

### 장치 상태 모니터링

다음과 같은 LiveData를 사용하면 현재 장치의 상태를 파악할 수 있습니다.

* electrodeStatus : 전극 연결 상태
* batteryLevel : 배터리 잔량 상태
* eegStabilityValue : 뇌파 안정 상태

#### 전극 센서 부착 상태

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

#### 배터리 잔량 상태

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

#### 뇌파 안정 상태

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

### 라이브러리 참조 설정

#### Gradle 파일(앱 레벨)

```groovy
dependencies {
    implementation 'omnifit.sdk:omnifit-brain-ktx:0.0.4'
}
```

<br/>

#### settings.gradle 파일

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

## 라이센스

    Copyright 2022 omniC&S

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
