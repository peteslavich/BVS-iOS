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
import UIKit

@objc(Measurement)
public class Measurement: NSManagedObject, Encodable {

    enum CodingKeys: String, CodingKey {
        case measurementOn = "MeasurementOn"
        case volume = "CalculatedVolume"
        case uuid = "ClientGuid"
        case patientRating = "PatientRating"
        case patientFeedback = "PatientFeedback"
        case patientID = "PatientID"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(measurementOn! as Date, forKey: .measurementOn)
        try container.encode(volume! as Decimal, forKey: .volume)
        try container.encode(uuid, forKey: .uuid)
        //try container.encode(patientRating as! Int?, forKey: .patientRating)
        //try container.encode(patientFeedback, forKey: .patientFeedback)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if let user = appDelegate.loggedInUser {
            try container.encode(user.patientID, forKey: .patientID)
        }
    }
}
