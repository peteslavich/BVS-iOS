//
//  Measurement+CoreDataClass.swift
//  BVS
//
//  Created by Peter Slavich on 2/18/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Measurement)
public class Measurement: NSManagedObject, Encodable {

    enum CodingKeys: String, CodingKey {
        case measurementOn
        case volume
        case uuid
        case patientRating
        case patientFeedback
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(measurementOn, forKey: .measurementOn)
        try container.encode(volume, forKey: .volume)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(patientRating, forKey: .patientRating)
        try container.encode(patientFeedback, forKey: .patientFeedback)
    }
}
