//
//  AppDelegate.swift
//  BVS
//
//  Created by Peter Slavich on 2/15/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var webService : BVSWebService? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        webService = BVSWebService()
        
//        let dateString = "06/20/2018"
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let dateFromString = dateFormatter.date(from: dateString)!
//
//        createDemoData(startDate: dateFromString, numberOfDays: 4)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BVS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createDemoData(startDate : Date, numberOfDays : Int) {
        let calendar = Calendar.current
        
        let startDateComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: startDate)
        var date = calendar.date(from: startDateComponents)!
        
        for _ in 1...numberOfDays {
            var tuple = [(Date,Int32)]()
            var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)

            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current;
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
            
            components.hour = 0
            components.minute = 41
            var newDate = calendar.date(from: components)!
            tuple.append((newDate,108))
            
            components.hour = 0
            components.minute = 53
            newDate = calendar.date(from: components)!
            tuple.append((newDate,132))

            components.hour = 1
            components.minute = 0
            newDate = calendar.date(from: components)!
            tuple.append((newDate,155))

            components.hour = 3
            components.minute = 41
            newDate = calendar.date(from: components)!
            tuple.append((newDate,122))

            components.hour = 3
            components.minute = 53
            newDate = calendar.date(from: components)!
            tuple.append((newDate,138))

            components.hour = 3
            components.minute = 59
            newDate = calendar.date(from: components)!
            tuple.append((newDate,151))

            components.hour = 9
            components.minute = 00
            newDate = calendar.date(from: components)!
            tuple.append((newDate,110))

            components.hour = 9
            components.minute = 10
            newDate = calendar.date(from: components)!
            tuple.append((newDate,122))

            components.hour = 9
            components.minute = 20
            newDate = calendar.date(from: components)!
            tuple.append((newDate,136))

            components.hour = 10
            components.minute = 30
            newDate = calendar.date(from: components)!
            tuple.append((newDate,88))

            components.hour = 10
            components.minute = 40
            newDate = calendar.date(from: components)!
            tuple.append((newDate,108))

            components.hour = 10
            components.minute = 50
            newDate = calendar.date(from: components)!
            tuple.append((newDate,120))

            components.hour = 11
            components.minute = 00
            newDate = calendar.date(from: components)!
            tuple.append((newDate,128))

            components.hour = 15
            components.minute = 41
            newDate = calendar.date(from: components)!
            tuple.append((newDate,111))

            components.hour = 15
            components.minute = 53
            newDate = calendar.date(from: components)!
            tuple.append((newDate,133))

            components.hour = 15
            components.minute = 59
            newDate = calendar.date(from: components)!
            tuple.append((newDate,162))

            components.hour = 18
            components.minute = 41
            newDate = calendar.date(from: components)!
            tuple.append((newDate,121))

            components.hour = 18
            components.minute = 53
            newDate = calendar.date(from: components)!
            tuple.append((newDate,144))

            components.hour = 18
            components.minute = 59
            newDate = calendar.date(from: components)!
            tuple.append((newDate,180))

            components.hour = 23
            components.minute = 41
            newDate = calendar.date(from: components)!
            tuple.append((newDate,111))

            components.hour = 23
            components.minute = 53
            newDate = calendar.date(from: components)!
            tuple.append((newDate,126))

            components.hour = 23
            components.minute = 59
            newDate = calendar.date(from: components)!
            tuple.append((newDate,144))

            let context = persistentContainer.viewContext

            for y in tuple {
                print("\(formatter.string(from: y.0)): \(y.1)")
                
                let measurement = NSEntityDescription.insertNewObject(forEntityName: "Measurement", into: context) as! Measurement
                measurement.measurementOn = y.0 as NSDate
                measurement.volume = y.1
                measurement.uuid = UUID()
                measurement.patientFeedback = "Demo data created by iOS app."

                let subMeasurement = NSEntityDescription.insertNewObject(forEntityName: "SubMeasurement", into: context) as! SubMeasurement
                for j in 1...8 {
                    for k in 1...8 {
                        subMeasurement[j,k] = Int32(arc4random_uniform(1048576))
                    }
                }
                subMeasurement.volume = measurement.volume
                subMeasurement.uuid = UUID()
                
                subMeasurement.measurementOn = measurement.measurementOn!
                subMeasurement.measurement = measurement
                measurement.addToSubMeasurements(subMeasurement)
                
                do {
                    try context.save()
                    //webServiceManager.addObjectIDToQueue(objectID: measurement.objectID)
                }
                catch {
                    
                }
                
            }
            date = date.addingTimeInterval(24*60*60)
            
        }
        
        

    }

}

