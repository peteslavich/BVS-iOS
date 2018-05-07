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
    case idle
    case processing
    case disconnected
    case suspended
}

class BVSWebService {
    let baseAddress = "http://bvspds.azurewebsites.net/api"
    let session = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask? = URLSessionDataTask()
    let privateMOC : NSManagedObjectContext
    let mainMOC : NSManagedObjectContext
    
    var queue : [NSManagedObjectID]  = [NSManagedObjectID]()  //queue of model object_ids to post
    var currentObject : Measurement? = nil
    var state : WebServiceStatus = .disconnected
    var reachability: Reachability?


    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mainMOC = appDelegate.persistentContainer.viewContext
        
        privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = mainMOC
        
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
        
        do {
            try self.reachability?.startNotifier()
        }
        catch {
            fatalError("reachability is kaput")
        }
        

        reachability?.whenReachable = { reachability in
            self.networkListener(reachability)
        }
        reachability?.whenUnreachable = { reachability in
            self.networkListener(reachability)
        }
        
        initializeQueue();
    }

    func initializeQueue() {
        //fetch all model_ids needed to post
        let measurementFetch = NSFetchRequest<Measurement>(entityName: "Measurement")
        measurementFetch.predicate = NSPredicate(format: "(serverID == nil) OR (serverID == 0)")
        let sort = NSSortDescriptor(key: #keyPath(Measurement.measurementOn), ascending: true)
        measurementFetch.sortDescriptors = [sort]
        
        do {
            let measurements = try privateMOC.fetch(measurementFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Measurement]
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
        if state != .disconnected && state != .suspended {
            if state == .idle
            {
                state = .processing
                processNextObject()
            }
        }
    }
    
    func postCompleted() {
        currentObject = nil
        if state != .disconnected && state != .suspended{
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
        if state != .disconnected && state != .suspended{
            if queue.count > 0 {
                processNextObject()
            }
        }
    }
    
    func processNextObject() {
        if state != .disconnected && state != .suspended{
            if queue.count > 0 {
                state = .processing
                let objectID = queue.first
                queue.removeFirst(1)
                currentObject = privateMOC.object(with: objectID!) as? Measurement
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
            if state != .disconnected && state != .suspended {
                state = .disconnected
            }
        }
    }
    
    func postCurrentObject() {
        
        if let measurement = currentObject {
            var url = URL(string: baseAddress)!
            url.appendPathComponent("Measurement")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
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
                        if let id = dictionary["id"] as? Int {
                            measurement.serverID = Int64(id)
                            do {
                                try self.privateMOC.save()
                                self.mainMOC.performAndWait {
                                    do {
                                        try self.mainMOC.save()
                                        self.postCompleted()
                                    }
                                    catch {
                                        fatalError("Failure to save context: \(error)")
                                    }
                                }
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
        state = .suspended
        reachability?.stopNotifier()
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
