//
//  ViewController.swift
//  BVS
//
//  Created by Peter Slavich on 2/15/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class BVSViewController: UIViewController, BVSBluetoothManagerDelegate {
    

    //MARK: Properties
    
    @IBOutlet weak var viewContainerLastMeasurement: UIView!
    @IBOutlet weak var viewContainerMeasuring: UIView!
    @IBOutlet weak var viewBottomDisplay: UIView!
    @IBOutlet weak var labelLastMeasurement: UILabel!
    @IBOutlet weak var labelLastMeasurementTime: UILabel!
    @IBOutlet weak var activityIndicatorMeasuring: UIActivityIndicatorView!
    @IBOutlet weak var labelMeasuringStatus: UILabel!
    @IBOutlet weak var labelDeviceStatus: UILabel!
    @IBOutlet weak var buttonReadMeasurement: UIButton!
    @IBOutlet weak var buttonThumbUp: UIButton!
    @IBOutlet weak var buttonThumbsDown: UIButton!
    
    
    var lastMeasurement : Measurement? = nil
    var bluetoothManager : BVSBluetoothManager? = nil
    var webServiceManager : BVSWebService!

    //MARK:Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContainerLastMeasurement.layer.cornerRadius = 5
        self.viewContainerMeasuring.layer.cornerRadius = 5
        
        fetchLastMeasurement()
        updateMeasurementUI()
        setUpBluetooth()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        webServiceManager = appDelegate.webService!
    }
    
    func setUpBluetooth() {
        buttonReadMeasurement.isEnabled = false
        labelDeviceStatus.text = "Disconnected - Scanning for device"
        
        bluetoothManager = BVSBluetoothManager()
        bluetoothManager?.delegate = self
    }
    
    func fetchLastMeasurement() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let measurementFetch = NSFetchRequest<Measurement>(entityName: "Measurement")
        let sort = NSSortDescriptor(key: #keyPath(Measurement.measurementOn), ascending: false)
        measurementFetch.sortDescriptors = [sort]
        measurementFetch.fetchLimit = 1
        do {
            let measurements = try context.fetch(measurementFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Measurement]
            if measurements.count == 1 {
                lastMeasurement = measurements.first
            }
        }
        catch {
            fatalError("Failed to fetch measurements: \(error)")
        }
    }
    
    func updateMeasurementUI() {
        if let measurement = self.lastMeasurement {
            let measurementDate = measurement.measurementOn! as Date
            let dateFormatterGet = DateFormatter()
            if Calendar.current.isDate(measurementDate, inSameDayAs:Date()) {
                dateFormatterGet.dateFormat = "h:mm:ss a"
                self.labelLastMeasurementTime.text = "Today, " + dateFormatterGet.string(from: measurementDate)
            }
            else
            {
                dateFormatterGet.dateFormat = "MM/dd/yyyy, h:mm:ss a"
            }
            self.labelLastMeasurement.text = String(format: "%.1f", measurement.volume!.doubleValue)
            if measurement.isRatingThumbsUp {
                buttonThumbUp.tintColor = UIColor.white;
                buttonThumbsDown.tintColor = UIColor.init(red: 0.196, green: 0.3098, blue: 0.52, alpha: 1.0)
            }
            else {
                buttonThumbUp.tintColor = UIColor.init(red: 0.196, green: 0.3098, blue: 0.52, alpha: 1.0);
                buttonThumbsDown.tintColor = UIColor.white
            }
        }
        else {
            self.labelLastMeasurementTime.text = "No Measurements Yet"
            self.labelLastMeasurement.text = "N/A"
            buttonThumbUp.tintColor = UIColor.init(red: 0.196, green: 0.3098, blue: 0.52, alpha: 1.0);
            buttonThumbsDown.tintColor = UIColor.init(red: 0.196, green: 0.3098, blue: 0.52, alpha: 1.0)
        }
    }



    @IBAction func simulateMeasurementPressed(_ sender: Any) {
        
        self.viewContainerLastMeasurement.isHidden = true
        self.viewContainerMeasuring.isHidden = false
        self.activityIndicatorMeasuring.startAnimating()
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(measurementFinished), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func readFromDevicePressed(_ sender: Any) {
        buttonReadMeasurement.isEnabled = false

        self.viewContainerLastMeasurement.isHidden = true
        self.viewContainerMeasuring.isHidden = false
        self.activityIndicatorMeasuring.startAnimating()
        
        bluetoothManager?.readFromBladderDevice()
    }
    
    @IBAction func thumbsUpPressed(_ sender: Any) {
        if let measurement = self.lastMeasurement {
            if !measurement.isRatingThumbsUp {
                // create a sound ID, in this case its the tweet sound.
                let systemSoundID: SystemSoundID = 1052
                
                // to play sound
                AudioServicesPlaySystemSound (systemSoundID)
                measurement.isRatingThumbsUp = true
                measurement.isRatingThumbsDown = false
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                do {
                    try context.save()
                    webServiceManager.addObjectIDToQueue(objectID: measurement.objectID)
                }
                catch {
                    
                }
                updateMeasurementUI()
            }
        }
    }
    
    @IBAction func thumbsDownPressed(_ sender: Any) {
        if let measurement = self.lastMeasurement {
            if !measurement.isRatingThumbsDown {
                let systemSoundID: SystemSoundID = 1052
                AudioServicesPlaySystemSound (systemSoundID)
                
                measurement.isRatingThumbsUp = false
                measurement.isRatingThumbsDown = true
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                do {
                    try context.save()
                    webServiceManager.addObjectIDToQueue(objectID: measurement.objectID)
                }
                catch {
                    
                }
                updateMeasurementUI()
            }
        }
    }
    
    @IBAction func showHistory(_ sender: Any) {
        performSegue(withIdentifier: "ShowMeasurementHistory", sender: nil)
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        if webServiceManager.isUserLoggedIn {
            let alert = UIAlertController(title:"Log Out?", message: "Are you sure you want to log out? You are currently logged in as \(webServiceManager.loggedInUser!.emailAddress)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {_ in
                self.webServiceManager.logout()
                self.performSegue(withIdentifier: "ShowLogin", sender: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert,animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "ShowLogin", sender: nil)
        }
    }

    @IBAction func enterFeedback(_ sender: Any) {
        if self.lastMeasurement != nil {
            performSegue(withIdentifier: "ShowMeasurementFeedback", sender: nil)
        }
    }
    
    @objc func measurementFinished() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let randomNumber = arc4random_uniform(3001)
        
        let measurement = NSEntityDescription.insertNewObject(forEntityName: "Measurement", into: context) as! Measurement
        measurement.measurementOn = Date() as NSDate
        let dd = 40.0 + Double(randomNumber)/100.0
        let d = String(format:"%.1f", dd)
        let dn = NSDecimalNumber(string:d)
        measurement.volume = dn
        measurement.uuid = UUID()

        for i in 0...2 {
            let subMeasurement = NSEntityDescription.insertNewObject(forEntityName: "SubMeasurement", into: context) as! SubMeasurement
            for j in 1...8 {
                for k in 1...8 {
                    let ddd = dd + Double(10*j + k)
                    subMeasurement[j,k] = Int32(ddd)
                }
            }
            subMeasurement.volume = dn
            subMeasurement.uuid = UUID()
            let timeInterval = TimeInterval(i)
            subMeasurement.measurementOn = ((measurement.measurementOn! as Date) - timeInterval) as NSDate
            subMeasurement.measurement = measurement
            measurement.addToSubMeasurements(subMeasurement)
        }
        do {
            try context.save()
            webServiceManager.addObjectIDToQueue(objectID: measurement.objectID)
        }
        catch {
            
        }
        
        self.lastMeasurement = measurement
        updateMeasurementUI()
        
        self.activityIndicatorMeasuring.stopAnimating()
        self.viewContainerMeasuring.isHidden = true

        self.viewContainerLastMeasurement.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMeasurementFeedback" {
            let nav = segue.destination as! UINavigationController
            let measurementFeedback = nav.topViewController as! MeasurementFeedbackViewController
            measurementFeedback.measurement = self.lastMeasurement
        }
    }
    
    
    //MARK: BluetoothDelegate
    
    func deviceDiscovered() {
        buttonReadMeasurement.isEnabled = false
        labelDeviceStatus.text = "Discovered - Attempting to connect"
    }
    
    func deviceConnected() {
        buttonReadMeasurement.isEnabled = true
        labelDeviceStatus.text = "Connected"
    }
    
    func deviceDisconnected() {
        buttonReadMeasurement.isEnabled = false
        labelDeviceStatus.text = "Disconnected - Scanning for device"
    }
    
    func deviceReadData(data: [[Int32]]) {
        buttonReadMeasurement.isEnabled = true

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let randomNumber = arc4random_uniform(3001)
        
        let measurement = NSEntityDescription.insertNewObject(forEntityName: "Measurement", into: context) as! Measurement
        measurement.measurementOn = Date() as NSDate
        let dd = 40.0 + Double(randomNumber)/100.0
        let de = String(format:"%.1f", dd)
        let dn = NSDecimalNumber(string:de)
        
        measurement.volume = dn
        measurement.uuid = UUID()
        
        for i in 0...2 {
            let subMeasurement = NSEntityDescription.insertNewObject(forEntityName: "SubMeasurement", into: context) as! SubMeasurement
            for j in 1...8 {
                subMeasurement[j] = data[j-1]
            }
            subMeasurement.volume = dn
            subMeasurement.uuid = UUID()
            let timeInterval = TimeInterval(i)
            subMeasurement.measurementOn = ((measurement.measurementOn! as Date) - timeInterval) as NSDate
            subMeasurement.measurement = measurement
            measurement.addToSubMeasurements(subMeasurement)
        }
        do {
            try context.save()
            webServiceManager.addObjectIDToQueue(objectID: measurement.objectID)
        }
        catch {
            
        }
        
        self.lastMeasurement = measurement
        updateMeasurementUI()
        
        self.activityIndicatorMeasuring.stopAnimating()
        self.viewContainerMeasuring.isHidden = true
        
        self.viewContainerLastMeasurement.isHidden = false
    }
    
    func errorConnecting(error:Error?) {
        if let e = error {
            print(e)
        }
        setUpBluetooth()
    }
    
    func errorReading(error: Error?) {
        if let e = error {
            print(e)
        }
        
        updateMeasurementUI()
        
        self.activityIndicatorMeasuring.stopAnimating()
        self.viewContainerMeasuring.isHidden = true
        self.viewContainerLastMeasurement.isHidden = false
        
        setUpBluetooth()
    }
    
}

