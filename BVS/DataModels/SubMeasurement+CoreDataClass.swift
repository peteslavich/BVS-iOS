//
//  SubMeasurement+CoreDataClass.swift
//  BVS
//
//  Created by Peter Slavich on 2/19/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SubMeasurement)
public class SubMeasurement: NSManagedObject, Encodable {

    subscript(sensor: Int, led: Int) -> Int32 {
        get {
            assert(indexIsValid(sensor: sensor, led: led), "Index out of range")
            var returnValue : Int32 = 0
            
            switch(sensor) {
            case 1:
                switch(led) {
                case 1:
                    returnValue = self.sensor1LED1
                case 2:
                    returnValue = self.sensor1LED2
                case 3:
                    returnValue = self.sensor1LED3
                case 4:
                    returnValue = self.sensor1LED4
                case 5:
                    returnValue = self.sensor1LED5
                case 6:
                    returnValue = self.sensor1LED6
                case 7:
                    returnValue = self.sensor1LED7
                case 8:
                    returnValue = self.sensor1LED8
                default:
                    returnValue = 0
                }
            case 2:
                switch(led) {
                case 1:
                    returnValue = self.sensor2LED1
                case 2:
                    returnValue = self.sensor2LED2
                case 3:
                    returnValue = self.sensor2LED3
                case 4:
                    returnValue = self.sensor2LED4
                case 5:
                    returnValue = self.sensor2LED5
                case 6:
                    returnValue = self.sensor2LED6
                case 7:
                    returnValue = self.sensor2LED7
                case 8:
                    returnValue = self.sensor2LED8
                default:
                    returnValue = 0
                }
            case 3:
                switch(led) {
                case 1:
                    returnValue = self.sensor3LED1
                case 2:
                    returnValue = self.sensor3LED2
                case 3:
                    returnValue = self.sensor3LED3
                case 4:
                    returnValue = self.sensor3LED4
                case 5:
                    returnValue = self.sensor3LED5
                case 6:
                    returnValue = self.sensor3LED6
                case 7:
                    returnValue = self.sensor3LED7
                case 8:
                    returnValue = self.sensor3LED8
                default:
                    returnValue = 0
                }
            case 4:
                switch(led) {
                case 1:
                    returnValue = self.sensor4LED1
                case 2:
                    returnValue = self.sensor4LED2
                case 3:
                    returnValue = self.sensor4LED3
                case 4:
                    returnValue = self.sensor4LED4
                case 5:
                    returnValue = self.sensor4LED5
                case 6:
                    returnValue = self.sensor4LED6
                case 7:
                    returnValue = self.sensor4LED7
                case 8:
                    returnValue = self.sensor4LED8
                default:
                    returnValue = 0
                }
            case 5:
                switch(led) {
                case 1:
                    returnValue = self.sensor5LED1
                case 2:
                    returnValue = self.sensor5LED2
                case 3:
                    returnValue = self.sensor5LED3
                case 4:
                    returnValue = self.sensor5LED4
                case 5:
                    returnValue = self.sensor5LED5
                case 6:
                    returnValue = self.sensor5LED6
                case 7:
                    returnValue = self.sensor5LED7
                case 8:
                    returnValue = self.sensor5LED8
                default:
                    returnValue = 0
                }
            case 6:
                switch(led) {
                case 1:
                    returnValue = self.sensor6LED1
                case 2:
                    returnValue = self.sensor6LED2
                case 3:
                    returnValue = self.sensor6LED3
                case 4:
                    returnValue = self.sensor6LED4
                case 5:
                    returnValue = self.sensor6LED5
                case 6:
                    returnValue = self.sensor6LED6
                case 7:
                    returnValue = self.sensor6LED7
                case 8:
                    returnValue = self.sensor6LED8
                default:
                    returnValue = 0
                }
            case 7:
                switch(led) {
                case 1:
                    returnValue = self.sensor7LED1
                case 2:
                    returnValue = self.sensor7LED2
                case 3:
                    returnValue = self.sensor7LED3
                case 4:
                    returnValue = self.sensor7LED4
                case 5:
                    returnValue = self.sensor7LED5
                case 6:
                    returnValue = self.sensor7LED6
                case 7:
                    returnValue = self.sensor7LED7
                case 8:
                    returnValue = self.sensor7LED8
                default:
                    returnValue = 0
                }
            case 8:
                switch(led) {
                case 1:
                    returnValue = self.sensor8LED1
                case 2:
                    returnValue = self.sensor8LED2
                case 3:
                    returnValue = self.sensor8LED3
                case 4:
                    returnValue = self.sensor8LED4
                case 5:
                    returnValue = self.sensor8LED5
                case 6:
                    returnValue = self.sensor8LED6
                case 7:
                    returnValue = self.sensor8LED7
                case 8:
                    returnValue = self.sensor8LED8
                default:
                    returnValue = 0
                }
            default:
                returnValue = 0
            }
            return returnValue
        }
        set (newValue) {
            assert(indexIsValid(sensor: sensor, led: led), "Index out of range")
            
            switch(sensor) {
            case 1:
                switch(led) {
                case 1:
                    self.sensor1LED1 = newValue
                case 2:
                    self.sensor1LED2 = newValue
                case 3:
                    self.sensor1LED3 = newValue
                case 4:
                    self.sensor1LED4 = newValue
                case 5:
                    self.sensor1LED5 = newValue
                case 6:
                    self.sensor1LED6 = newValue
                case 7:
                    self.sensor1LED7 = newValue
                case 8:
                    self.sensor1LED8 = newValue
                default:
                    break
                }
            case 2:
                switch(led) {
                case 1:
                    self.sensor2LED1 = newValue
                case 2:
                    self.sensor2LED2 = newValue
                case 3:
                    self.sensor2LED3 = newValue
                case 4:
                    self.sensor2LED4 = newValue
                case 5:
                    self.sensor2LED5 = newValue
                case 6:
                    self.sensor2LED6 = newValue
                case 7:
                    self.sensor2LED7 = newValue
                case 8:
                    self.sensor2LED8 = newValue
                default:
                    break
                }
            case 3:
                switch(led) {
                case 1:
                    self.sensor3LED1 = newValue
                case 2:
                    self.sensor3LED2 = newValue
                case 3:
                    self.sensor3LED3 = newValue
                case 4:
                    self.sensor3LED4 = newValue
                case 5:
                    self.sensor3LED5 = newValue
                case 6:
                    self.sensor3LED6 = newValue
                case 7:
                    self.sensor3LED7 = newValue
                case 8:
                    self.sensor3LED8 = newValue
                default:
                    break
                }
            case 4:
                switch(led) {
                case 1:
                    self.sensor4LED1 = newValue
                case 2:
                    self.sensor4LED2 = newValue
                case 3:
                    self.sensor4LED3 = newValue
                case 4:
                    self.sensor4LED4 = newValue
                case 5:
                    self.sensor4LED5 = newValue
                case 6:
                    self.sensor4LED6 = newValue
                case 7:
                    self.sensor4LED7 = newValue
                case 8:
                    self.sensor4LED8 = newValue
                default:
                    break
                }
            case 5:
                switch(led) {
                case 1:
                    self.sensor5LED1 = newValue
                case 2:
                    self.sensor5LED2 = newValue
                case 3:
                    self.sensor5LED3 = newValue
                case 4:
                    self.sensor5LED4 = newValue
                case 5:
                    self.sensor5LED5 = newValue
                case 6:
                    self.sensor5LED6 = newValue
                case 7:
                    self.sensor5LED7 = newValue
                case 8:
                    self.sensor5LED8 = newValue
                default:
                    break
                }
            case 6:
                switch(led) {
                case 1:
                    self.sensor6LED1 = newValue
                case 2:
                    self.sensor6LED2 = newValue
                case 3:
                    self.sensor6LED3 = newValue
                case 4:
                    self.sensor6LED4 = newValue
                case 5:
                    self.sensor6LED5 = newValue
                case 6:
                    self.sensor6LED6 = newValue
                case 7:
                    self.sensor6LED7 = newValue
                case 8:
                    self.sensor6LED8 = newValue
                default:
                    break
                }
            case 7:
                switch(led) {
                case 1:
                    self.sensor7LED1 = newValue
                case 2:
                    self.sensor7LED2 = newValue
                case 3:
                    self.sensor7LED3 = newValue
                case 4:
                    self.sensor7LED4 = newValue
                case 5:
                    self.sensor7LED5 = newValue
                case 6:
                    self.sensor7LED6 = newValue
                case 7:
                    self.sensor7LED7 = newValue
                case 8:
                    self.sensor7LED8 = newValue
                default:
                    break
                }
            case 8:
                switch(led) {
                case 1:
                    self.sensor8LED1 = newValue
                case 2:
                    self.sensor8LED2 = newValue
                case 3:
                    self.sensor8LED3 = newValue
                case 4:
                    self.sensor8LED4 = newValue
                case 5:
                    self.sensor8LED5 = newValue
                case 6:
                    self.sensor8LED6 = newValue
                case 7:
                    self.sensor8LED7 = newValue
                case 8:
                    self.sensor8LED8 = newValue
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    func indexIsValid(sensor: Int, led: Int) -> Bool {
        return sensor >= 1 && sensor <= 8 && led >= 1 && led <= 8
    }
    
    enum CodingKeys: String, CodingKey {
        case measurementOn = "MeasurementOn"
        case volume = "CalculatedVolume"
        case uuid = "ClientGuid"
        
        case sensor1LED1 = "Sensor1LED1"
        case sensor1LED2 = "Sensor1LED2"
        case sensor1LED3 = "Sensor1LED3"
        case sensor1LED4 = "Sensor1LED4"
        case sensor1LED5 = "Sensor1LED5"
        case sensor1LED6 = "Sensor1LED6"
        case sensor1LED7 = "Sensor1LED7"
        case sensor1LED8 = "Sensor1LED8"
        
        case sensor2LED1 = "Sensor2LED1"
        case sensor2LED2 = "Sensor2LED2"
        case sensor2LED3 = "Sensor2LED3"
        case sensor2LED4 = "Sensor2LED4"
        case sensor2LED5 = "Sensor2LED5"
        case sensor2LED6 = "Sensor2LED6"
        case sensor2LED7 = "Sensor2LED7"
        case sensor2LED8 = "Sensor2LED8"
        
        case sensor3LED1 = "Sensor3LED1"
        case sensor3LED2 = "Sensor3LED2"
        case sensor3LED3 = "Sensor3LED3"
        case sensor3LED4 = "Sensor3LED4"
        case sensor3LED5 = "Sensor3LED5"
        case sensor3LED6 = "Sensor3LED6"
        case sensor3LED7 = "Sensor3LED7"
        case sensor3LED8 = "Sensor3LED8"
        
        case sensor4LED1 = "Sensor4LED1"
        case sensor4LED2 = "Sensor4LED2"
        case sensor4LED3 = "Sensor4LED3"
        case sensor4LED4 = "Sensor4LED4"
        case sensor4LED5 = "Sensor4LED5"
        case sensor4LED6 = "Sensor4LED6"
        case sensor4LED7 = "Sensor4LED7"
        case sensor4LED8 = "Sensor4LED8"
        
        case sensor5LED1 = "Sensor5LED1"
        case sensor5LED2 = "Sensor5LED2"
        case sensor5LED3 = "Sensor5LED3"
        case sensor5LED4 = "Sensor5LED4"
        case sensor5LED5 = "Sensor5LED5"
        case sensor5LED6 = "Sensor5LED6"
        case sensor5LED7 = "Sensor5LED7"
        case sensor5LED8 = "Sensor5LED8"
        
        case sensor6LED1 = "Sensor6LED1"
        case sensor6LED2 = "Sensor6LED2"
        case sensor6LED3 = "Sensor6LED3"
        case sensor6LED4 = "Sensor6LED4"
        case sensor6LED5 = "Sensor6LED5"
        case sensor6LED6 = "Sensor6LED6"
        case sensor6LED7 = "Sensor6LED7"
        case sensor6LED8 = "Sensor6LED8"
        
        case sensor7LED1 = "Sensor7LED1"
        case sensor7LED2 = "Sensor7LED2"
        case sensor7LED3 = "Sensor7LED3"
        case sensor7LED4 = "Sensor7LED4"
        case sensor7LED5 = "Sensor7LED5"
        case sensor7LED6 = "Sensor7LED6"
        case sensor7LED7 = "Sensor7LED7"
        case sensor7LED8 = "Sensor7LED8"
        
        case sensor8LED1 = "Sensor8LED1"
        case sensor8LED2 = "Sensor8LED2"
        case sensor8LED3 = "Sensor8LED3"
        case sensor8LED4 = "Sensor8LED4"
        case sensor8LED5 = "Sensor8LED5"
        case sensor8LED6 = "Sensor8LED6"
        case sensor8LED7 = "Sensor8LED7"
        case sensor8LED8 = "Sensor8LED8"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(measurementOn! as Date, forKey: .measurementOn)
        try container.encode(volume! as Decimal, forKey: .volume)
        try container.encode(uuid, forKey: .uuid)

        try container.encode(sensor1LED1 as Int32, forKey: .sensor1LED1)
        try container.encode(sensor1LED2 as Int32, forKey: .sensor1LED2)
        try container.encode(sensor1LED3 as Int32, forKey: .sensor1LED3)
        try container.encode(sensor1LED4 as Int32, forKey: .sensor1LED4)
        try container.encode(sensor1LED5 as Int32, forKey: .sensor1LED5)
        try container.encode(sensor1LED6 as Int32, forKey: .sensor1LED6)
        try container.encode(sensor1LED7 as Int32, forKey: .sensor1LED7)
        try container.encode(sensor1LED8 as Int32, forKey: .sensor1LED8)

        try container.encode(sensor2LED1 as Int32, forKey: .sensor2LED1)
        try container.encode(sensor2LED2 as Int32, forKey: .sensor2LED2)
        try container.encode(sensor2LED3 as Int32, forKey: .sensor2LED3)
        try container.encode(sensor2LED4 as Int32, forKey: .sensor2LED4)
        try container.encode(sensor2LED5 as Int32, forKey: .sensor2LED5)
        try container.encode(sensor2LED6 as Int32, forKey: .sensor2LED6)
        try container.encode(sensor2LED7 as Int32, forKey: .sensor2LED7)
        try container.encode(sensor2LED8 as Int32, forKey: .sensor2LED8)
        
        try container.encode(sensor3LED1 as Int32, forKey: .sensor3LED1)
        try container.encode(sensor3LED2 as Int32, forKey: .sensor3LED2)
        try container.encode(sensor3LED3 as Int32, forKey: .sensor3LED3)
        try container.encode(sensor3LED4 as Int32, forKey: .sensor3LED4)
        try container.encode(sensor3LED5 as Int32, forKey: .sensor3LED5)
        try container.encode(sensor3LED6 as Int32, forKey: .sensor3LED6)
        try container.encode(sensor3LED7 as Int32, forKey: .sensor3LED7)
        try container.encode(sensor3LED8 as Int32, forKey: .sensor3LED8)
        
        try container.encode(sensor4LED1 as Int32, forKey: .sensor4LED1)
        try container.encode(sensor4LED2 as Int32, forKey: .sensor4LED2)
        try container.encode(sensor4LED3 as Int32, forKey: .sensor4LED3)
        try container.encode(sensor4LED4 as Int32, forKey: .sensor4LED4)
        try container.encode(sensor4LED5 as Int32, forKey: .sensor4LED5)
        try container.encode(sensor4LED6 as Int32, forKey: .sensor4LED6)
        try container.encode(sensor4LED7 as Int32, forKey: .sensor4LED7)
        try container.encode(sensor4LED8 as Int32, forKey: .sensor4LED8)
        
        try container.encode(sensor5LED1 as Int32, forKey: .sensor5LED1)
        try container.encode(sensor5LED2 as Int32, forKey: .sensor5LED2)
        try container.encode(sensor5LED3 as Int32, forKey: .sensor5LED3)
        try container.encode(sensor5LED4 as Int32, forKey: .sensor5LED4)
        try container.encode(sensor5LED5 as Int32, forKey: .sensor5LED5)
        try container.encode(sensor5LED6 as Int32, forKey: .sensor5LED6)
        try container.encode(sensor5LED7 as Int32, forKey: .sensor5LED7)
        try container.encode(sensor5LED8 as Int32, forKey: .sensor5LED8)
        
        try container.encode(sensor6LED1 as Int32, forKey: .sensor6LED1)
        try container.encode(sensor6LED2 as Int32, forKey: .sensor6LED2)
        try container.encode(sensor6LED3 as Int32, forKey: .sensor6LED3)
        try container.encode(sensor6LED4 as Int32, forKey: .sensor6LED4)
        try container.encode(sensor6LED5 as Int32, forKey: .sensor6LED5)
        try container.encode(sensor6LED6 as Int32, forKey: .sensor6LED6)
        try container.encode(sensor6LED7 as Int32, forKey: .sensor6LED7)
        try container.encode(sensor6LED8 as Int32, forKey: .sensor6LED8)
        
        try container.encode(sensor7LED1 as Int32, forKey: .sensor7LED1)
        try container.encode(sensor7LED2 as Int32, forKey: .sensor7LED2)
        try container.encode(sensor7LED3 as Int32, forKey: .sensor7LED3)
        try container.encode(sensor7LED4 as Int32, forKey: .sensor7LED4)
        try container.encode(sensor7LED5 as Int32, forKey: .sensor7LED5)
        try container.encode(sensor7LED6 as Int32, forKey: .sensor7LED6)
        try container.encode(sensor7LED7 as Int32, forKey: .sensor7LED7)
        try container.encode(sensor7LED8 as Int32, forKey: .sensor7LED8)
        
        try container.encode(sensor8LED1 as Int32, forKey: .sensor8LED1)
        try container.encode(sensor8LED2 as Int32, forKey: .sensor8LED2)
        try container.encode(sensor8LED3 as Int32, forKey: .sensor8LED3)
        try container.encode(sensor8LED4 as Int32, forKey: .sensor8LED4)
        try container.encode(sensor8LED5 as Int32, forKey: .sensor8LED5)
        try container.encode(sensor8LED6 as Int32, forKey: .sensor8LED6)
        try container.encode(sensor8LED7 as Int32, forKey: .sensor8LED7)
        try container.encode(sensor8LED8 as Int32, forKey: .sensor8LED8)
    }
}
