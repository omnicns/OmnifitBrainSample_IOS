//
//  ContentView.swift
//  BrainSample
//
//  Created by omni on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var brainManager = BrainManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 2) {
                btStateView         // 스캔,연결,측정 상태
                scanListInfoView    // 스캔정보
                connectInfoView     // 측정가능여부 상태값 확인
                dataInfoView        // 실시간 Data
                Spacer()
            }
            .padding()
            .onAppear(perform: {
                //블루투스 초기화 및 블루투스 시스템 알림 권한 팝업 노출
                brainManager.brain?.reqBluetoothPermission()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension ContentView {
    @ViewBuilder
    var btStateView: some View {
        Text("** OMNIFIT BRAIN **")
        VStack{
            /**
             스캔상태
             */
            HStack {
                Text("스캔상태: \(brainManager.scanState == .scanningInProgress ? "스캔중...." : "스캔 X")")
                Circle().fill(brainManager.scanState == .scanningInProgress ? Color.green : Color.red).frame(width: 20, height: 20)
                
                Spacer()
                
                //MARK: Start Scanning
                Button(action: {
                    brainManager.startScanning(for: 5) // 5sec scan
                }) {
                    Text("Start Scan")
                }
                .padding()
                .frame(height: 30)
                .background(brainManager.scanState == .scanningInProgress ? Color.gray.opacity(0.3) : Color.blue.opacity(0.3))
                .cornerRadius(10)
                .foregroundColor(Color.black)
                .disabled(brainManager.scanState == .scanningInProgress)
            }
            
            /**
             연결상태
             */
            
            HStack {
                Text("연결상태: \(brainManager.deviceConnectionState == .deviceConnected ? "연결 O" : brainManager.deviceConnectionState == .connectingInProgress ?  "연결중.." : "연결 X")")
                Circle().fill(brainManager.deviceConnectionState == .deviceConnected ? Color.green :
                                brainManager.deviceConnectionState == .connectingInProgress ? Color.yellow : Color.red).frame(width: 20, height: 20)
                Spacer()
            }
            
            Text("[connected device]").foregroundColor(Color.blue).padding(.top, 10)
            
            HStack {
                if let device = brainManager.connectedDevice {
                    HStack(spacing: 15) {
                        Text("\(device.name ?? "Unknown")")
                        Text("\(brainManager.currentBatteryPercent)")
                    }
                }
                Spacer()
                
                if brainManager.connectedDevice != nil {
                    Button(action: {
                        brainManager.disconnect()
                    }) {
                        Text("Disconnect Device")
                    }
                    .padding(8)
                    .frame(height: 30)
                    .background(Color.yellow.opacity(0.5))
                    .cornerRadius(10)
                    .foregroundColor(Color.black)
                }else{
                    
                }
            }
            
            /**
             측정상태
             */
            VStack {
                HStack{
                    
                    // 측정시작
                    /**
                     측정 시작 충족조건 : 연결상태,착용상태,측정상태
                     */
                    Button(action: {
                        brainManager.startMeasuring(eyesState: .closed) // 눈 감은 상태 측정시작
                    }) {
                        Text("측정시작")
                    }
                    .padding(8)
                    .frame(height: 30)
                    .background(brainManager.isMeasuring() ? Color.gray.opacity(0.3) : Color.blue.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(Color.black)
                    .disabled(brainManager.isMeasuring())
                    
                    // 측정완료
                    Button(action: {
                        brainManager.stopMeasuring()
                        /**
                         측정중 수집된 Data 확인
                         */
//                        print("측정Data: \(brainManager.measurementResult)")
                        print("두뇌 점수: \(brainManager.getBrainScore())")
                        
                        
                    }) {
                        Text("측정완료")
                    }
                    .padding(8)
                    .frame(height: 30)
                    .background(!brainManager.isMeasuring() ? Color.gray.opacity(0.3) : Color.blue.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(Color.black)
                    .disabled(!brainManager.isMeasuring())
                }
            }
        }
        .padding()
    }
}

/**
 스캔정보 UI
 */
extension ContentView {
    @ViewBuilder
    var scanListInfoView: some View {
        VStack{
            List {
                if let scannedDevices = brainManager.scannedDevices {
                    ForEach(scannedDevices, id: \.id) { device in
                        Text(device.name ?? "Unknown")
                            .onTapGesture {
                                brainManager.connect(to: device.peripheral)  // 직접 peripheral 전달
                            }
                    }
                }
            }
            .frame(height: 150)
        }
    }
}

/**
 측정가능여부 확인 State
 */
extension ContentView {
    @ViewBuilder
    var connectInfoView: some View {
        VStack{
            Divider().padding()
            HStack{
                Text("연결관리: \(brainManager.stateConnect() ? "연결 o" : "연결 x")")
                Circle().fill(brainManager.stateConnect() ? Color.green : Color.red).frame(width: 20, height: 20)
                Spacer()
            }
            HStack{
                Text("착용상태: \(brainManager.stateWearing() ? "착용 o" : "미착용 x")")
                Circle().fill(brainManager.stateWearing() ? Color.green : Color.red).frame(width: 20, height: 20)
                Spacer()
            }
            HStack{
                Text("측정상태: \(brainManager.isMeasuring() ? "측정 o" : "측정 x")")
                Circle().fill(brainManager.isMeasuring() ? Color.green : Color.red).frame(width: 20, height: 20)
                Spacer()
            }
            HStack{
                Text("측정진행시간: \(brainManager.measurementTime)")
                Spacer()
            }
        }
        .padding(.top, 20)
    }
}

/**
 Data 실시간 Value
 (각 항목별 시시간 Data 수집하여 측정 Data 배열을 만들수 있다)
 */
extension ContentView {
    @ViewBuilder
    var dataInfoView: some View {
        VStack{
            Divider().padding()
            Text("Data leftThetaIndicatorValue-> \(brainManager.latestMeasurementData?.leftThetaIndicatorValue ?? 0)")
            Text("Data rightThetaIndicatorValue-> \(brainManager.latestMeasurementData?.rightThetaIndicatorValue ?? 0)")
            Text("Data leftAlphaIndicatorValue-> \(brainManager.latestMeasurementData?.leftAlphaIndicatorValue ?? 0)")
            // ..... 실시간 최근 Data 한건 획득
        }
        .padding(.top, 10)
    }
}
