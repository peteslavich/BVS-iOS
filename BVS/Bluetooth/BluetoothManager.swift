//
//  BluetoothManager.swift
//  BVS
//
//  Created by Peter Slavich on 4/19/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
import CoreData

enum BluetoothStatus {
    case inactive   //not powered on
    case poweringOn
    case scanningForDevice
    case attemptingToConnect //both connect and service/characteristic discovery wrapped into this
    case connected
    case reading
    case disconnected //powered on, disconnected and idle
}

protocol BVSBluetoothManagerDelegate {
    func deviceDiscovered()
    func deviceConnected()
    func deviceDisconnected()
    func deviceReadData(data:[[Int32]])
    
    func errorConnecting(error:Error?)
    func errorReading(error:Error?)
}


class BVSBluetoothManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    let bladderVolumeServiceUUID = CBUUID(string: "00000000-7E10-41C1-B16F-4430B506CDE7")
    
    let led1CharacteristicUUID = CBUUID(string: "00000001-6E10-41C1-B16F-4430B506CDE7")
    let led2CharacteristicUUID = CBUUID(string: "00000002-6E10-41C1-B16F-4430B506CDE7")
    let led3CharacteristicUUID = CBUUID(string: "00000003-6E10-41C1-B16F-4430B506CDE7")
    let led4CharacteristicUUID = CBUUID(string: "00000004-6E10-41C1-B16F-4430B506CDE7")
    let led5CharacteristicUUID = CBUUID(string: "00000005-6E10-41C1-B16F-4430B506CDE7")
    let led6CharacteristicUUID = CBUUID(string: "00000006-6E10-41C1-B16F-4430B506CDE7")
    let led7CharacteristicUUID = CBUUID(string: "00000007-6E10-41C1-B16F-4430B506CDE7")
    let led8CharacteristicUUID = CBUUID(string: "00000008-6E10-41C1-B16F-4430B506CDE7")
    
    var bladderVolumeService : CBService? = nil
    let centralManager : CBCentralManager
    var peripheral : CBPeripheral? = nil
    var delegate : BVSBluetoothManagerDelegate? = nil
    var characteristics : Array<CBCharacteristic>? = nil
    var status : BluetoothStatus = .inactive
    var timer : Timer? = nil
    
    var sensorReadings : [[UInt32]?] = [[UInt32]?]()
    
    override init() {
        
        centralManager = CBCentralManager(delegate:nil, queue: nil)
        status = .poweringOn
        super.init()
        
        centralManager.delegate = self
    }
    
    private func scanForBladderDevice() {
        centralManager.scanForPeripherals(withServices: [bladderVolumeServiceUUID], options:nil)
        print("Scanning for device...")
    }
    
    func readFromBladderDevice() {
        //peripheral?.readValue(for: (characteristics?.first!)!)
        
        sensorReadings = [nil, nil, nil, nil, nil, nil, nil, nil]
        
        peripheral?.setNotifyValue(true, for: characteristics![0])
        peripheral?.setNotifyValue(true, for: characteristics![1])
        peripheral?.setNotifyValue(true, for: characteristics![2])
        peripheral?.setNotifyValue(true, for: characteristics![3])
        peripheral?.setNotifyValue(true, for: characteristics![4])
        peripheral?.setNotifyValue(true, for: characteristics![5])
        peripheral?.setNotifyValue(true, for: characteristics![6])
        peripheral?.setNotifyValue(true, for: characteristics![7])

    }
    
//    func setUpTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkConnection), userInfo: nil, repeats: true)
//        timer?.tolerance = TimeInterval(0.2)
//    }
//
//    func invalidateTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
    
    @objc func checkConnection() {
        if status == .connected {
            if let p = self .peripheral {
                if p.state != .connected {
                    status = .disconnected
                    //invalidateTimer()
                    self.delegate?.deviceDisconnected()
                }
            }
        }
    }
    
    //MARK:CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth powered on..")
            status = .scanningForDevice
            scanForBladderDevice()
        }
        else {
            status = .inactive
            print ("Bluetooth not powered on")
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        centralManager.stopScan()
        print("Device discovered.")
        delegate?.deviceDiscovered()
        
        centralManager.connect(self.peripheral!, options:nil)
        status = .attemptingToConnect
        print("Attempting to connect.")
    }
    
    public func centralManager(_ central: CBCentralManager,
                               didDisconnectPeripheral peripheral: CBPeripheral,
                               error: Error?) {
        self.status = .disconnected
        self.delegate?.deviceDisconnected()
    }
    
    func centralManager(_ central: CBCentralManager,
                                 didConnect peripheral: CBPeripheral) {
        print("Manager connected...")

        peripheral.delegate = self
        peripheral.discoverServices([bladderVolumeServiceUUID])
        status = .attemptingToConnect
        print("Attempting to discover service...")
    }
    
    //MARK:CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        if peripheral.services!.count > 0 {
            print("Service discovered...")
            self.bladderVolumeService = peripheral.services![0]
            peripheral.discoverCharacteristics(nil, for:self.bladderVolumeService!)
            print("Attempting to discover characteristics...")
            status = .attemptingToConnect
        }
        else {
            delegate?.errorConnecting(error: error)
            print("error discovering services")
            status = .disconnected
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        
        var success = true
        if service.characteristics!.count > 0 {
            
            var characteristic1: CBCharacteristic? = nil
            var characteristic2: CBCharacteristic? = nil
            var characteristic3: CBCharacteristic? = nil
            var characteristic4: CBCharacteristic? = nil
            var characteristic5: CBCharacteristic? = nil
            var characteristic6: CBCharacteristic? = nil
            var characteristic7: CBCharacteristic? = nil
            var characteristic8: CBCharacteristic? = nil
            
            for characteristic in service.characteristics! {
                if characteristic.uuid == led1CharacteristicUUID {
                    characteristic1 = characteristic
                }
                else if characteristic.uuid == led2CharacteristicUUID {
                    characteristic2 = characteristic
                }
                else if characteristic.uuid == led3CharacteristicUUID {
                    characteristic3 = characteristic
                }
                else if characteristic.uuid == led4CharacteristicUUID {
                    characteristic4 = characteristic
                }
                else if characteristic.uuid == led5CharacteristicUUID {
                    characteristic5 = characteristic
                }
                else if characteristic.uuid == led6CharacteristicUUID {
                    characteristic6 = characteristic
                }
                else if characteristic.uuid == led7CharacteristicUUID {
                    characteristic7 = characteristic
                }
                else if characteristic.uuid == led8CharacteristicUUID {
                    characteristic8 = characteristic
                }
            }
            if characteristic1 != nil && characteristic2 != nil && characteristic3 != nil && characteristic4 != nil && characteristic5 != nil && characteristic6 != nil && characteristic7 != nil && characteristic8 != nil {
                self.characteristics = [characteristic1!, characteristic2!, characteristic3!, characteristic4!, characteristic5!, characteristic6!, characteristic7!, characteristic8!]
                self.status = .connected
                //setUpTimer()
                delegate?.deviceConnected()
                print("Characteristic discovered")
            }
            else {
                success = false
            }
        }
        else {
            success = false
        }
        
        if !success {
            //senderrortodelegate
            print("error discovering characteristics")
            delegate?.errorConnecting(error: error)
            self.status = .disconnected
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        if error == nil {
            if let data = characteristic.value {
                if data.count == 24 {
                    if let index = characteristics?.index(of: characteristic) {
                        sensorReadings[index] = [UInt32]()
                        for k in 0...7 {
                            let e = data.subdata(in: 3*k..<(3*k+3))
                            let value = e.withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
                                return ptr.pointee
                            }
                            print(value)
                            sensorReadings[index]?.append(value)
                        }
                        if sensorReadings[index]?.count == 8 {
                            //check if have all 8 arrays for a complete measurement
                            var allThere = true;
                            for a in sensorReadings {
                                if a == nil {
                                    allThere = false
                                    break
                                }
                            }
                            if allThere {
                                for i in 0...7 {
                                    peripheral.setNotifyValue(false, for: characteristics![i])
                                }
                                var arr = [[Int32]]()
                                for _ in 0...7 {
                                    arr.append([Int32]())
                                }
                                for i in 0...7 {
                                    if let sensorRs = sensorReadings[i] {
                                        for j in 0...7 {
                                            arr[i].append(Int32(sensorRs[j]))
                                        }
                                    }
                                }
                                delegate?.deviceReadData(data: arr)
                                sensorReadings = [nil, nil, nil, nil, nil, nil, nil, nil]
                            }
                        }
                        else {
                            sensorReadings[index] = nil
                        }
                    }
                }
            }
        }
        else {
            delegate?.errorReading(error: error)
        }
    }
}
