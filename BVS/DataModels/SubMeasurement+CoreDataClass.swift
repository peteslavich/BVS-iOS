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
public class SubMeasurement: NSManagedObject {

    subscript(sensor: Int, led: Int) -> NSDecimalNumber? {
        get {
            assert(indexIsValid(sensor: sensor, led: led), "Index out of range")
            var returnValue : NSDecimalNumber? = 0
            
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
}
