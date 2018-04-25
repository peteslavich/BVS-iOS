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

protocol BVSBluetoothManagerDelegate {
    func deviceDiscovered()
    func deviceConnected()
    func deviceReadData(data:Data)
}


class BVSBluetoothManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    let bladderVolumeServiceUUID = CBUUID(string: "00000000-7E10-41C1-B16F-4430B506CDE7")
    var bladderVolumeService : CBService? = nil
    let centralManager : CBCentralManager
    var peripheral : CBPeripheral? = nil
    var delegate : BVSBluetoothManagerDelegate? = nil
    var characteristics : Array<CBCharacteristic>? = nil
    
    
    override init() {
        centralManager = CBCentralManager(delegate:nil, queue: nil)
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
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth powered on..")
            scanForBladderDevice()
        }
        else {
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
        print("Attempting to connect.")

    }
    
    func centralManager(_ central: CBCentralManager,
                                 didConnect peripheral: CBPeripheral) {
        print("Manager connected...")

        peripheral.delegate = self
        peripheral.discoverServices([bladderVolumeServiceUUID])
        print("Attempting to discover service...")

    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        if peripheral.services!.count > 0 {
            print("Service discovered...")
            self.bladderVolumeService = peripheral.services![0]
            peripheral.discoverCharacteristics(nil, for:self.bladderVolumeService!)
            print("Attempting to discover characteristics...")
        }
        else {
            //senderrortodelegate?
            print("error discovering services")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if service.characteristics!.count > 0 {
            self.characteristics = service.characteristics
            delegate?.deviceConnected()
            print("Characteristic discovered")
        }
        else {
            //senderrortodelegate
            print("error discovering characteristics")
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
    }
}
