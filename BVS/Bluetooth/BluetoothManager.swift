//
//  BluetoothManager.swift
//  BVS
//
//  Created by Peter Slavich on 4/19/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BVSBluetoothManagerDelegate {
    func deviceDiscovered()
    func deviceConnected()
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
    
    func scanForBladderDevice() {
        centralManager.scanForPeripherals(withServices: [bladderVolumeServiceUUID], options:nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }

    func centralManager(_ central: CBCentralManager,
                                 didDiscover peripheral: CBPeripheral,
                                 advertisementData: [String : Any],
                                 rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        centralManager.stopScan()
        delegate?.deviceDiscovered()
        
        centralManager.connect(self.peripheral!, options:nil)
    }
    
    func centralManager(_ central: CBCentralManager,
                                 didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([bladderVolumeServiceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        if peripheral.services!.count > 0 {
            self.bladderVolumeService = peripheral.services![0]
            peripheral.discoverCharacteristics(nil, for:self.bladderVolumeService!)
        }
        else {
            //senderrortodelegate?
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if service.characteristics!.count > 0 {
            self.characteristics = service.characteristics
            delegate?.deviceConnected()
        }
        else {
            //senderrortodelegate
        }
    }
}
