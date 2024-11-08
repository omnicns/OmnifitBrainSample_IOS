//
//  BrainManager.swift
//  brain
//
//  Created by omni on 9/25/24.
//

import Combine
import CoreBluetooth
import BrainLib

class BrainManager: ObservableObject {
    var brain: OmnifitBrain?
    
    // Combine의 AnyCancellable을 사용하여 구독 관리
    private var cancellables = Set<AnyCancellable>()
    private var measurementEventSubscription: AnyCancellable? // 측정 이벤트 구독
    
    init(brain: OmnifitBrain = OmnifitBrain()) {
        self.brain = brain
        print("BrainManager inited")
        subscribeToOmnifitBrainPublishers()
    }
    
    deinit {
        print("BrainManager deinited")
    }
    
    /**
     State var
     */
    @Published var isBluetoothPermissionState: Int = 0  //  bluetooth state 연결기기 블루투스 on,off 및 권한 상태 체크
    
    @Published var scanState: ScanState? // 스캔상태
    @Published var deviceConnectionState: ConnectionState? // 장치 연결 상태
    @Published var measurementState: MeasurementState? // 측정상태
    
    @Published var scannedDevices: [DiscoveredDevice]? // 스캔 장치목록
    @Published var connectedDevice: CBPeripheral? // 연결된 장치
    
    @Published var measurable: Bool = false   // 착용상태
    @Published var measurementTime: Int = 0 // 측정 진행시간
    @Published var measureEyesState: EyesStatus = .closed // 측정시 눈상태
    @Published var currentBatteryPercent: String = "- %" // 장치 배터리 표시
    
    var measurementResult: [LiveData] = [] // 측정 결과 데이터
    @Published var latestMeasurementData: LiveData? // 최신 측정 실시간 데이터
    
    /**
     Subscriptions
     */
    private func subscribeToOmnifitBrainPublishers() {
        // 장치 이벤트 구독
        brain?.deviceEventPublisher
            .sink { [weak self] subject in
                switch subject {
                    case .scanState(let state):
                        self?.scanState = state
                    case .deviceConnectionState(let state):
                        self?.deviceConnectionState = state
                    case .discoveredDevices(let devices):
                        // DiscoveredDevice 배열에서 CBPeripheral 배열로 변환
                        print("discoveredDevices -> \(devices)")
                        self?.scannedDevices = devices.map { DiscoveredDevice(peripheral: $0.peripheral, name: $0.name, rssi: $0.rssi) }
                    
                        // identifier 로 재연결시 사용
//                        if let device = devices.first {
//                            let uuid = device.peripheral.identifier
//                            self?.brain?.reconnectBrainDevice(with: uuid)
//                        }
                    case .connectedDevice(let device):
                        // 장치 연결 성공 시 스캔 상태 초기화 및 측정 데이터 구독 시작
                        self?.scanState = nil
                        self?.scannedDevices = nil
                        self?.subscribeToMeasurementPublishers() // Data 구독
                        self?.connectedDevice = device
                    @unknown default:
                        break
                }
            }
            .store(in: &cancellables)
        
        // 측정 상태 구독
        brain?.measurementStatePublisher
            .sink { [weak self] state in
                self?.measurementState = state
            }
            .store(in: &cancellables)
        
        // 블루투스 상태 업데이트 구독
        brain?.bluetoothStatePublisher
            .sink { [weak self] state in
                self?.isBluetoothPermissionState = state
            }
            .store(in: &cancellables)
        
    }
    
    /**
        측정 이벤트 구독
     */
    private func subscribeToMeasurementPublishers() {
        measurementEventSubscription = brain?.measurementEventPublisher
            .sink { [weak self] event in
                switch event {
                    case .measurementData(let data):
                        // 측정 진행 중일 때 데이터 업데이트
                        if self?.measurementState == .inProgress {
                            self?.measurementResult.append(data)
                            self?.latestMeasurementData = data // 최신 데이터 업데이트
                        }
                    case .deviceMonitorData(let data):
                        // 장치 배터리 레벨 업데이트
                        let batteryLevel = self?.intToPercentString(value: data.batteryLevel) ?? ""
                        
                        if self?.currentBatteryPercent != batteryLevel {
                            self?.currentBatteryPercent = batteryLevel
                        }
                    case .measurementDuration(let time):
                        // 측정 시간 업데이트
                        self?.measurementTime = time
                    case .measurable(let bool):
                        // 측정 가능 여부 업데이트
                        if self?.measurable != bool {
                            self?.measurable = bool
                        }
                        
                    @unknown default:
                        break
                    }
            }
    }
    
    /**
        측정 이벤트 구독 취소
     */
    private func unsubscribeToMeasurementPublishers() {
        measurementEventSubscription?.cancel()
        measurementEventSubscription = nil
    }
}

/**
 
 Barain 연결상태 , 착용상태, 측정상태 관리
 
 */
extension BrainManager {
    
    // 연결상태
    func stateConnect() -> Bool {
        if deviceConnectionState == .deviceConnected {
            return true
        }else{
            return false
        }
    }
    
    // 착용상태
    func stateWearing() -> Bool {
        if measurable {
            return true
        }else{
            return false
        }
    }
    
    // 측정상태
    func isMeasuring() -> Bool {
        if measurementState == .inProgress {
            return true
        }else{
            return false
        }
    }
}

/**
    BrainManager 스캔 및 연결, 측정 관련 함수
 */
extension BrainManager {
    // 스캔 시작 함수
    // [param]seconds: 스캔 TimeInterval
    func startScanning(for seconds: TimeInterval) {
        guard let brain = brain else {
            print("Brain is nil, cannot start scanning.")
            return
        }
        
        // 스캔시 연결상태 초기화
        deviceConnectionState = nil
        connectedDevice = nil
        scannedDevices = nil
        
        brain.startScanning(for: seconds)
        
        // OmnifitBrain 이벤트 구독
        subscribeToOmnifitBrainPublishers()
    }
    
    // 스캔 중지 함수
    func stopScanning() {
        brain?.stopScanning()
    }
    
    func connect(to device: CBPeripheral) {
        subscribeToMeasurementPublishers() // 측정 이벤트 구독 시작
        brain?.connect(device)
    }
    
    func disconnect() {
        if let currentDevice = connectedDevice {
            unsubscribeToMeasurementPublishers() // 측정 이벤트 구독 취소
            resetResult() // 측정 결과 초기화
            
            brain?.disconnect(currentDevice)
            connectedDevice = nil
        }
    }
    
    // 측정 시작 함수
    func startMeasuring(eyesState: EyesStatus) {
        resetResult()
        // 눈 상태 설정
        brain?.setEyesState(eyesState)
        
        brain?.startMeasuring()
    }
    
    // 측정 중지 함수
    func stopMeasuring() {
        brain?.stopMeasuring()
    }
    
    // 측정 완료 함수
    func completeMeasuring() {
        brain?.completeMeasuring()
    }
    
    // 측정 결과 초기화 함수
    private func resetResult() {
        measurementResult = []
    }
    
    //측정기준 상태값
    func getEyesState() {
        measureEyesState = brain?.getEyesState() ?? .closed
    }
    
    func getBrainScore() -> Int {
        let brainScore = brain?.getBrainScore(results: measurementResult) ?? 0
        return brainScore
    }
    
    // 배터리표현
    private func intToPercentString(value: Int) -> String {
        guard value >= 0 else { return " - %" }
        
        return "\(value)%"
    }
}
