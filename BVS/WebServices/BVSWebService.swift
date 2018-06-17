//
//  BVSWebService.swift
//  BVS
//
//  Created by Peter Slavich on 3/23/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum WebServiceStatus {
    case signedOut
    case idle
    case processing
    case disconnected
    case suspended
}

protocol LoginDelegate {
    func loginSuccessful()
    func loginFailed(message:String)
}

struct KeychainConfiguration {
    static let servicePassword = "BVSLogin"
    static let servicePatientID = "BVSPatientID"
    static let accessGroup: String? = nil
}

class BVSWebService {
    let baseAddress = "http://bvspds.azurewebsites.net/api"
    let session = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask? = URLSessionDataTask()
    let context : NSManagedObjectContext
    
    var queue : [NSManagedObjectID]  = [NSManagedObjectID]()  //queue of model object_ids to post
    var currentObject : Measurement? = nil
    var state : WebServiceStatus = .signedOut
    var reachability: Reachability?

    var loggedInUser: User? = nil
    
    var isUserLoggedIn : Bool {
        return loggedInUser != nil
    }

    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationSuspended),
            name: .UIApplicationDidEnterBackground,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationResumed),
            name: .UIApplicationDidBecomeActive,
            object: nil)
        

        self.reachability = Reachability(hostname: "google.com")

        reachability?.whenReachable = { reachability in
            self.networkListener(reachability)
        }
        reachability?.whenUnreachable = { reachability in
            self.networkListener(reachability)
        }

        var didFindCredentials = false
        
        //look for credentials
        do {
            let passwordKeychainItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.servicePassword)
            let patientIDKeychainItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.servicePatientID
            )
            if passwordKeychainItems.count > 0 && patientIDKeychainItems.count > 0 {
                if let passwordKeyChainItem = passwordKeychainItems.first,
                   let patientIDKeyChainItem = patientIDKeychainItems.first {
                    let user = passwordKeyChainItem.account
                    do {
                        let password = try passwordKeyChainItem.readPassword()
                        let patientIDz = Int(try patientIDKeyChainItem.readPassword())
                        if let patientID = patientIDz {
                            loggedInUser = User(emailAddress: user, password: password, patientID: patientID)
                            didFindCredentials = true
                        }
                    }
                    catch {
                        do {
                            try passwordKeyChainItem.deleteItem()
                        }
                        catch {
                            fatalError("Undeletable keychainitem")
                        }
                    }
                }
            }
        }
        catch {
            
        }
        if didFindCredentials {
            state = .disconnected
            do {
                try self.reachability?.startNotifier()
            }
            catch {
                fatalError("reachability is kaput")
            }
        }
        
        initializeQueue();
    }

    func initializeQueue() {
        //fetch all model_ids needed to post
        let measurementFetch = NSFetchRequest<Measurement>(entityName: "Measurement")
        measurementFetch.predicate = NSPredicate(format: "(serverID == nil) OR (serverID == 0) OR (updatedOn != nil)")
        let sort = NSSortDescriptor(key: #keyPath(Measurement.measurementOn), ascending: true)
        measurementFetch.sortDescriptors = [sort]
        
        do {
            let measurements = try context.fetch(measurementFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Measurement]
            for measurement in measurements {
                queue.append(measurement.objectID)
            }
        }
        catch {
            fatalError("Failed to fetch measurements: \(error)")
        }
    }
    
    func addObjectIDToQueue(objectID : NSManagedObjectID) {
        queue.append(objectID)
        if state != .signedOut && state != .disconnected && state != .suspended {
            if state == .idle
            {
                state = .processing
                processNextObject()
            }
        }
    }
    
    func postCompleted() {
        currentObject = nil
        if state != .signedOut && state != .disconnected && state != .suspended{
            if queue.count > 0 {
                processNextObject()
            }
            else {
                state = .idle
            }
        }
    }
    
    func postCompletedWithError() {
        currentObject = nil
        if state != .signedOut && state != .disconnected && state != .suspended{
            if queue.count > 0 {
                processNextObject()
            }
        }
    }
    
    func processNextObject() {
        if state != .signedOut && state != .disconnected && state != .suspended{
            if queue.count > 0 {
                state = .processing
                let objectID = queue.first
                queue.removeFirst(1)
                currentObject = context.object(with: objectID!) as? Measurement
                postCurrentObject()
            }
            else {
                state = .idle
            }
        }
    }
    
    func resumeProcessing() {
        if currentObject == nil {
            if queue.count > 0 {
                state = .processing
                processNextObject()
            }
            else {
                state = .idle
            }
        }
        else {
            //where in the process of posting were we?
            //in all likelihoood wont reach this state
            //object has been sent to be posted
            //we disconnected from network
            //then reconnected and i didnt get an error from the web service call
            
            
            state = .processing
        }
        
    }
    
    func networkListener(_ r: Reachability) {
        let connected = r.connection != .none
        if connected {
            if state == .disconnected {
                resumeProcessing()
            }
        }
        else {
            if state != .signedOut && state != .disconnected && state != .suspended {
                state = .disconnected
            }
        }
    }

    func login(username: String, password: String, loginDelegate: LoginDelegate) {
        var url = URL(string: baseAddress)!
        url.appendPathComponent("Patient/Login")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let authString = username + ":" + password
        let authData = authString.data(using: .utf8)
        let authValue = String(format: "Basic %@", (authData?.base64EncodedString())!)
        request.setValue(authValue, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with:request) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                loginDelegate.loginFailed(message: "URLSession error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if (200...299).contains(response.statusCode) {
                    var success = false
                    if let d = data,
                       let dataString = String(data: d, encoding: .utf8) {
                        print ("got data: \(dataString)")
                        
                        let json = try? JSONSerialization.jsonObject(with: d, options: [])
                        if let dictionary = json as? [String: Any] {
                            if let id = dictionary["patientID"] as? Int {
                                self.loggedInUser = User(emailAddress: username, password: password, patientID: id)
                                
                                self.state = .disconnected
                                success = true
                                DispatchQueue.main.async() {
                                    loginDelegate.loginSuccessful()
                                }
                                //store encrypted credentials
                                do {
                                    // This is a new account, create a new keychain item with the account name.
                                    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.servicePassword,
                                                                            account: username,
                                                                            accessGroup: KeychainConfiguration.accessGroup)
                                    
                                    // Save the password for the new item.
                                    try passwordItem.savePassword(password)
                                    
                                    let patientIDItem = KeychainPasswordItem(service: KeychainConfiguration.servicePatientID,
                                                                             account: username,
                                                                             accessGroup: KeychainConfiguration.accessGroup)
                                    
                                    // Save the password for the new item.
                                    try patientIDItem.savePassword(String(id))
                                }
                                catch {
                                    fatalError("Error updating keychain - \(error)")
                                }
                                
                                do {
                                    try self.reachability?.startNotifier()
                                }
                                catch {
                                    fatalError("reachability no go")
                                }
                            }
                        }
                    }
                    if !success {
                        DispatchQueue.main.async() {
                            loginDelegate.loginFailed(message: "Invalid response from server.")}
                    }
                }
                else if response.statusCode == 401 {
                    DispatchQueue.main.async() {

                        loginDelegate.loginFailed(message: "Invalid username/password")}
                }
                else {
                    DispatchQueue.main.async() {
                        loginDelegate.loginFailed(message: "Server Error: \(response.statusCode)")}
                }
            }
            else {
                DispatchQueue.main.async() {
                    loginDelegate.loginFailed(message: "Unknown Server Error")}
            }
        }
            
        task.resume()
    }
    
    func logout() {
        loggedInUser = nil
        state = .signedOut
        reachability?.stopNotifier()
        
        //remove cached credentials
        do {
            let passwordKeychainItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.servicePassword)
            let patientIDKeychainItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.servicePatientID)
            
            if passwordKeychainItems.count > 0 {
                for passwordKeyChainItem in passwordKeychainItems {
                    do {
                        try passwordKeyChainItem.deleteItem()
                    }
                    catch {
                        fatalError("Undeletable keychainitem")
                    }
                }
            }
            if patientIDKeychainItems.count > 0 {
                for patientIDKeychainItem in patientIDKeychainItems {
                    do {
                        try patientIDKeychainItem.deleteItem()
                    }
                    catch {
                        fatalError("Undeletable keychainitem")
                    }
                }
            }
        }
        catch {
            
        }
    }
    
    func postCurrentObject() {
        if let measurement = currentObject,
           let user = loggedInUser {
            var url = URL(string: baseAddress)!
            url.appendPathComponent("Measurement")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let authString = "\(user.emailAddress):\(user.password)"
            let authData = authString.data(using: .utf8)
            let authValue = String(format: "Basic %@", (authData?.base64EncodedString())!)
            request.setValue(authValue, forHTTPHeaderField: "Authorization")
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let uploadData = try? encoder.encode(measurement) else {
                return
            }
            
            let s = String(data:uploadData, encoding: String.Encoding.utf8) as String?
            print ("json data: " + s!)

            let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
                if let error = error {
                    print ("error: \(error)")
                    self.postCompletedWithError()
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        self.postCompletedWithError()
                        return
                }
                if let d = data,
                    let dataString = String(data: d, encoding: .utf8){
                    print ("got data: \(dataString)")
                    let json = try? JSONSerialization.jsonObject(with: d, options: [])
                    if let dictionary = json as? [String: Any] {
                        var shouldSave = false
                        if measurement.serverID > 0 {
                            measurement.updatedOn = nil
                            shouldSave = true
                        }
                        else {
                            if let id = dictionary["id"] as? Int {
                                measurement.serverID = Int64(id)
                                measurement.updatedOn = nil
                                shouldSave = true
                            }
                        }
                        if shouldSave {
                            do {
                                try self.context.save()
                                self.postCompleted()
                            }
                            catch {
                                fatalError("Failure to save context: \(error)")
                            }
                        }
                    }
                }
            }
            task.resume()
        }
        else {
            resumeProcessing()
        }
    }
    
    @objc func applicationSuspended() {
        if state != .signedOut {
            state = .suspended
            reachability?.stopNotifier()
        }
    }
    
    @objc func applicationResumed() {
        if state == .suspended {
            do {
                state = .disconnected
                try reachability?.startNotifier()
            }
            catch {
                fatalError("reachability no go")
            }
            resumeProcessing()
        }
    }


    
}
