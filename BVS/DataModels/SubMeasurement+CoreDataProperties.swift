//
//  SubMeasurement+CoreDataProperties.swift
//  BVS
//
//  Created by Peter Slavich on 2/19/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//
//

import Foundation
import CoreData


extension SubMeasurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubMeasurement> {
        return NSFetchRequest<SubMeasurement>(entityName: "SubMeasurement")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var volume: NSDecimalNumber?
    @NSManaged public var measurementOn: NSDate?
    @NSManaged public var sensor1LED1: NSDecimalNumber?
    @NSManaged public var sensor1LED2: NSDecimalNumber?
    @NSManaged public var sensor1LED3: NSDecimalNumber?
    @NSManaged public var sensor1LED4: NSDecimalNumber?
    @NSManaged public var sensor1LED5: NSDecimalNumber?
    @NSManaged public var sensor1LED6: NSDecimalNumber?
    @NSManaged public var sensor1LED7: NSDecimalNumber?
    @NSManaged public var sensor1LED8: NSDecimalNumber?
    @NSManaged public var sensor2LED1: NSDecimalNumber?
    @NSManaged public var sensor2LED2: NSDecimalNumber?
    @NSManaged public var sensor2LED3: NSDecimalNumber?
    @NSManaged public var sensor2LED4: NSDecimalNumber?
    @NSManaged public var sensor2LED5: NSDecimalNumber?
    @NSManaged public var sensor2LED6: NSDecimalNumber?
    @NSManaged public var sensor2LED7: NSDecimalNumber?
    @NSManaged public var sensor2LED8: NSDecimalNumber?
    @NSManaged public var sensor3LED1: NSDecimalNumber?
    @NSManaged public var sensor3LED2: NSDecimalNumber?
    @NSManaged public var sensor3LED3: NSDecimalNumber?
    @NSManaged public var sensor3LED4: NSDecimalNumber?
    @NSManaged public var sensor3LED5: NSDecimalNumber?
    @NSManaged public var sensor3LED6: NSDecimalNumber?
    @NSManaged public var sensor3LED7: NSDecimalNumber?
    @NSManaged public var sensor3LED8: NSDecimalNumber?
    @NSManaged public var sensor4LED1: NSDecimalNumber?
    @NSManaged public var sensor4LED2: NSDecimalNumber?
    @NSManaged public var sensor4LED3: NSDecimalNumber?
    @NSManaged public var sensor4LED4: NSDecimalNumber?
    @NSManaged public var sensor4LED5: NSDecimalNumber?
    @NSManaged public var sensor4LED6: NSDecimalNumber?
    @NSManaged public var sensor5LED1: NSDecimalNumber?
    @NSManaged public var sensor4LED7: NSDecimalNumber?
    @NSManaged public var sensor4LED8: NSDecimalNumber?
    @NSManaged public var sensor5LED2: NSDecimalNumber?
    @NSManaged public var sensor5LED3: NSDecimalNumber?
    @NSManaged public var sensor5LED4: NSDecimalNumber?
    @NSManaged public var sensor5LED5: NSDecimalNumber?
    @NSManaged public var sensor5LED6: NSDecimalNumber?
    @NSManaged public var sensor5LED7: NSDecimalNumber?
    @NSManaged public var sensor5LED8: NSDecimalNumber?
    @NSManaged public var sensor6LED1: NSDecimalNumber?
    @NSManaged public var sensor6LED2: NSDecimalNumber?
    @NSManaged public var sensor6LED3: NSDecimalNumber?
    @NSManaged public var sensor6LED4: NSDecimalNumber?
    @NSManaged public var sensor6LED5: NSDecimalNumber?
    @NSManaged public var sensor6LED6: NSDecimalNumber?
    @NSManaged public var sensor6LED7: NSDecimalNumber?
    @NSManaged public var sensor6LED8: NSDecimalNumber?
    @NSManaged public var sensor7LED1: NSDecimalNumber?
    @NSManaged public var sensor7LED2: NSDecimalNumber?
    @NSManaged public var sensor7LED3: NSDecimalNumber?
    @NSManaged public var sensor7LED4: NSDecimalNumber?
    @NSManaged public var sensor7LED5: NSDecimalNumber?
    @NSManaged public var sensor7LED6: NSDecimalNumber?
    @NSManaged public var sensor7LED7: NSDecimalNumber?
    @NSManaged public var sensor7LED8: NSDecimalNumber?
    @NSManaged public var sensor8LED1: NSDecimalNumber?
    @NSManaged public var sensor8LED2: NSDecimalNumber?
    @NSManaged public var sensor8LED3: NSDecimalNumber?
    @NSManaged public var sensor8LED4: NSDecimalNumber?
    @NSManaged public var sensor8LED5: NSDecimalNumber?
    @NSManaged public var sensor8LED6: NSDecimalNumber?
    @NSManaged public var sensor8LED7: NSDecimalNumber?
    @NSManaged public var sensor8LED8: NSDecimalNumber?
    @NSManaged public var measurement: Measurement?

}
