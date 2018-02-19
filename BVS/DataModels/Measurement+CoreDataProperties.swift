//
//  Measurement+CoreDataProperties.swift
//  BVS
//
//  Created by Peter Slavich on 2/19/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//
//

import Foundation
import CoreData


extension Measurement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Measurement> {
        return NSFetchRequest<Measurement>(entityName: "Measurement")
    }

    @NSManaged public var measurementOn: NSDate?
    @NSManaged public var volume: NSDecimalNumber?
    @NSManaged public var uuid: UUID?
    @NSManaged public var patientRating: Int16
    @NSManaged public var patientFeedback: String?
    @NSManaged public var subMeasurements: NSSet?

}

// MARK: Generated accessors for subMeasurements
extension Measurement {

    @objc(addSubMeasurementsObject:)
    @NSManaged public func addToSubMeasurements(_ value: SubMeasurement)

    @objc(removeSubMeasurementsObject:)
    @NSManaged public func removeFromSubMeasurements(_ value: SubMeasurement)

    @objc(addSubMeasurements:)
    @NSManaged public func addToSubMeasurements(_ values: NSSet)

    @objc(removeSubMeasurements:)
    @NSManaged public func removeFromSubMeasurements(_ values: NSSet)

}
