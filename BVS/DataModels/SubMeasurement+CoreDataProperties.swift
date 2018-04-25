//
//  SubMeasurement+CoreDataProperties.swift
//  BVS
//
//  Created by Peter Slavich on 4/24/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//
//

import Foundation
import CoreData


extension SubMeasurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubMeasurement> {
        return NSFetchRequest<SubMeasurement>(entityName: "SubMeasurement")
    }

    @NSManaged public var measurementOn: NSDate?
    @NSManaged public var sensor1LED1: Int32
    @NSManaged public var sensor1LED2: Int32
    @NSManaged public var sensor1LED3: Int32
    @NSManaged public var sensor1LED4: Int32
    @NSManaged public var sensor1LED5: Int32
    @NSManaged public var sensor1LED6: Int32
    @NSManaged public var sensor1LED7: Int32
    @NSManaged public var sensor1LED8: Int32
    @NSManaged public var sensor2LED1: Int32
    @NSManaged public var sensor2LED2: Int32
    @NSManaged public var sensor2LED3: Int32
    @NSManaged public var sensor2LED4: Int32
    @NSManaged public var sensor2LED5: Int32
    @NSManaged public var sensor2LED6: Int32
    @NSManaged public var sensor2LED7: Int32
    @NSManaged public var sensor2LED8: Int32
    @NSManaged public var sensor3LED1: Int32
    @NSManaged public var sensor3LED2: Int32
    @NSManaged public var sensor3LED3: Int32
    @NSManaged public var sensor3LED4: Int32
    @NSManaged public var sensor3LED5: Int32
    @NSManaged public var sensor3LED6: Int32
    @NSManaged public var sensor3LED7: Int32
    @NSManaged public var sensor3LED8: Int32
    @NSManaged public var sensor4LED1: Int32
    @NSManaged public var sensor4LED2: Int32
    @NSManaged public var sensor4LED3: Int32
    @NSManaged public var sensor4LED4: Int32
    @NSManaged public var sensor4LED5: Int32
    @NSManaged public var sensor4LED6: Int32
    @NSManaged public var sensor4LED7: Int32
    @NSManaged public var sensor4LED8: Int32
    @NSManaged public var sensor5LED1: Int32
    @NSManaged public var sensor5LED2: Int32
    @NSManaged public var sensor5LED3: Int32
    @NSManaged public var sensor5LED4: Int32
    @NSManaged public var sensor5LED5: Int32
    @NSManaged public var sensor5LED6: Int32
    @NSManaged public var sensor5LED7: Int32
    @NSManaged public var sensor5LED8: Int32
    @NSManaged public var sensor6LED1: Int32
    @NSManaged public var sensor6LED2: Int32
    @NSManaged public var sensor6LED3: Int32
    @NSManaged public var sensor6LED4: Int32
    @NSManaged public var sensor6LED5: Int32
    @NSManaged public var sensor6LED6: Int32
    @NSManaged public var sensor6LED7: Int32
    @NSManaged public var sensor6LED8: Int32
    @NSManaged public var sensor7LED1: Int32
    @NSManaged public var sensor7LED2: Int32
    @NSManaged public var sensor7LED3: Int32
    @NSManaged public var sensor7LED4: Int32
    @NSManaged public var sensor7LED5: Int32
    @NSManaged public var sensor7LED6: Int32
    @NSManaged public var sensor7LED7: Int32
    @NSManaged public var sensor7LED8: Int32
    @NSManaged public var sensor8LED1: Int32
    @NSManaged public var sensor8LED2: Int32
    @NSManaged public var sensor8LED3: Int32
    @NSManaged public var sensor8LED4: Int32
    @NSManaged public var sensor8LED5: Int32
    @NSManaged public var sensor8LED6: Int32
    @NSManaged public var sensor8LED7: Int32
    @NSManaged public var sensor8LED8: Int32
    @NSManaged public var uuid: UUID?
    @NSManaged public var volume: NSDecimalNumber?
    @NSManaged public var measurement: Measurement?

}
