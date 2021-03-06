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
        case subMeasurements = "SubMeasurements"
        case serverID = "ID"
        case isRatingThumbsUp = "IsPatientRatingThumbsUp"
        case isRatingThumbsDown = "IsPatientRatingThumbsDown"
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if (self.serverID > 0) {
            try container.encode(serverID as Int64, forKey: .serverID)
        }
        
        let e = DateFormatter()
        e.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let mOn = e.string(from: measurementOn! as Date)
        
        try container.encode(mOn, forKey: .measurementOn)
        try container.encode(volume as Int32, forKey: .volume)
        try container.encode(uuid, forKey: .uuid)
        
        try container.encode(patientRating as! Int?, forKey: .patientRating)
        try container.encode(patientFeedback, forKey: .patientFeedback)
        try container.encode(isRatingThumbsUp, forKey: .isRatingThumbsUp)
        try container.encode(isRatingThumbsDown, forKey: .isRatingThumbsDown)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let user = appDelegate.webService!.loggedInUser {
            try container.encode(user.patientID, forKey: .patientID)
        }
        
        if (self.serverID == 0) {
            var sub = container.nestedUnkeyedContainer(forKey: .subMeasurements)
            for s in Array(subMeasurements!) as! Array<SubMeasurement> {
                try sub.encode(s)
            }
        }

    }
}
