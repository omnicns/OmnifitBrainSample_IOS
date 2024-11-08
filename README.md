# OmnifitBrain
> 영어로 읽기: [ENGLISH](README.en.md)

## 앱 셋팅
1. BrainSample > Frameworks를 복사하여 프로젝트에 추가합니다.
2. Targets > General > Frameworks, Libraries, and Embedded Content로 이동하여 + 버튼을 클릭한 후 BrainLib.xcframework를 추가합니다.
3. Info.plist에 Bluetooth 권한을 추가합니다<br/>
   * Privacy - Bluetooth Always Usage Description<br/>
   * Privacy - Bluetooth Peripheral Usage Description<br/>
4. BrainManager 의 경우 자신에 맞게끔 Custom 해서 사용가능하다.<br/>
   import BrainLib 해준다.
   
## 개요

본 라이브러리는 옴니핏 제품의 브레인 제품군에 해당하는 장치를 사용하여 
서비스를 제공할 수 있는 안드로이드 앱을 만들 수 있도록 지원하기 위한 것입니다.
라이브러리의 제공되는 기능은 아래와 같이 구성됩니다.

* 브레인 장치 검색 / 취소
* 브레인 장치 연결 / 해제
* 측정 시작 / 종료 (뇌파 데이터 획득)
* 장치 정보 획득
* 장치 상태 모니터링 (연결 상태, 전극 센서 부착 상태, 배터리 잔량)

**검색 중인지를 나타내는 상태, 연결 중인지를 나타내는 상태, 측정 중인지를 나타내는 상태, 뇌파 데이터, 장치 상태 모두 
LiveData 라이브러리를 사용하여 제공하고 있습니다.**

### 브레인 장치 검색 / 취소
seconds : 인자 값 만큼 시간 초과 후 스캔 정지<br/>
검색 : startScanning(for seconds: TimeInterval)<br/>
취소 : stopScanning()

### 브레인 장치 연결 / 해제
연결 : <br/>
    func connect(to device: CBPeripheral) {<br/>
        subscribeToMeasurementPublishers() // 측정 이벤트 구독 시작<br/>
        brain?.connect(device)<br/>
    }<br/>
재연결 : uuid: peripheral.identifier<br/>
      reconnectBrainDevice(with: uuid)<br/>
해제 : <br/>
    private func unsubscribeToMeasurementPublishers() {<br/>
        measurementEventSubscription?.cancel()<br/>
        measurementEventSubscription = nil<br/>
    }<br/>

### 측정 시작 / 종료

**startMeasuring 함수**를 호출하면 측정을 시작되고 **isMeasuring 값**이 true로 변경됩니다<br/>
isMeasuring 값이 true 일 때 **stopMeasuring 함수**를 호출하면 isMeasuring 값이 false로 바뀌며 측정이 종료됩니다.<br/>
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

![img](https://github.com/user-attachments/assets/b8c73365-4986-447b-9c7c-6614348d0a89)


* unbalanceIndicatorValue를 제외한 나머지 프로퍼티는 5가 표준이며 0에 수렴할수록 매우 낮은 상태를 의미하고,
  10에 수렴할수록 매우 높은 상태를 의미합니다.
* unbalanceIndicatorValue는 5가 좌우뇌 균형을 의미하고 0에 수렴할수록 우뇌가 활성화되었음을 의미하고,
  10에 수렴할수록 좌뇌가 활성화되었음을 의미합니다.

<br/>

#### startMeasuring 함수 매개 변수
> eyeState : 측정하려는 눈의 상태. Opened 와 Closed 두 개의 타입이 존재. 디폴트 파라미터로 CLOSED가 선언되어있음.<br/>


<br/>

### 장치 정보 획득
장치이벤트 구독(deviceEventPublisher)시 discoveredDevices 에서 장치정보를 획득할수 있다. 

<br/>

### 장치 상태 모니터링

다음과 같은 LiveData를 사용하면 현재 장치의 상태를 파악할 수 있습니다.

* electrodeStatus : 전극 연결 상태
* batteryLevel : 배터리 잔량 상태
* eegStabilityValue : 뇌파 안정 상태

<br/>

### 두뇌 점수 획득

getBrainScore 함수를 호출하면 두뇌 점수를 획득할 수 있습니다.<br/>
인자로 [LiveData] 수집하고 있는 measurementResult 넘기면 되고, 리턴값은 Int 타입의 두뇌 점수입니다.

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

<br/>
