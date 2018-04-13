//
//  User.swift
//  BVS
//
//  Created by Peter Slavich on 4/13/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation

public class User {
    let emailAddress : String
    let password: String
    let patientID: Int
    
    init (emailAddress: String, password: String, patientID: Int) {
        self.emailAddress = emailAddress
        self.password = password
        self.patientID = patientID
    }
}
