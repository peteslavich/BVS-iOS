//
//  Measurement+CoreDataProperties.swift
//  BVS
//
//  Created by Peter Slavich on 2/18/18.
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

}
