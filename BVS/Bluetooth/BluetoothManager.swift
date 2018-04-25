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
            let data = characteristic.value
            if let d = data {
                
                if d.count == 192 {
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let randomNumber = arc4random_uniform(3001)
                    
                    let measurement = NSEntityDescription.insertNewObject(forEntityName: "Measurement", into: context) as! Measurement
                    measurement.measurementOn = Date() as NSDate
                    let dd = 40.0 + Double(randomNumber)/100.0
                    let de = String(format:"%.1f", dd)
                    let dn = NSDecimalNumber(string:de)
                    
                    measurement.volume = dn
                    measurement.uuid = UUID()
                    
                    for i in 0...2 {
                        let subMeasurement = NSEntityDescription.insertNewObject(forEntityName: "SubMeasurement", into: context) as! SubMeasurement
                        for j in 1...8 {
                            for k in 1...8 {
                                let l = 8*(j - 1) + (k - 1)
                                let e = d.subdata(in: 3*l..<(3*l+3))
                                let value = e.withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
                                    return ptr.pointee
                                }
                                print(value)
                                subMeasurement[j,k] = value
                            }
                        }
                        subMeasurement.volume = dn
                        subMeasurement.uuid = UUID()
                        let timeInterval = TimeInterval(i)
                        subMeasurement.measurementOn = ((measurement.measurementOn! as Date) - timeInterval) as NSDate
                        subMeasurement.measurement = measurement
                        measurement.addToSubMeasurements(subMeasurement)
                    }
                    do {
                        try context.save()
                    }
                    catch {
                        
                    }
                }
            }
        }
    }
}
