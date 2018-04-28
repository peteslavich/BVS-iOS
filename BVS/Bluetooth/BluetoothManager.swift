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
    func deviceReadData(data:Data)
    
    func errorConnecting(error:Error?)
    func errorReading(error:Error?)
}


class BVSBluetoothManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    let bladderVolumeServiceUUID = CBUUID(string: "00000000-7E10-41C1-B16F-4430B506CDE7")
    var bladderVolumeService : CBService? = nil
    let centralManager : CBCentralManager
    var peripheral : CBPeripheral? = nil
    var delegate : BVSBluetoothManagerDelegate? = nil
    var characteristics : Array<CBCharacteristic>? = nil
    var status : BluetoothStatus = .inactive
    var timer : Timer? = nil
    
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
        peripheral?.readValue(for: (characteristics?.first!)!)
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
        if service.characteristics!.count > 0 {
            self.characteristics = service.characteristics
            self.status = .connected
            //setUpTimer()
            delegate?.deviceConnected()
            print("Characteristic discovered")
        }
        else {
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
                if data.count == 192 {
                    delegate?.deviceReadData(data: data)
                }
            }
        }
        else {
            delegate?.errorReading(error: error)
            
        }
    }
}
