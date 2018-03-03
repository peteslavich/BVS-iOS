//
//  ViewController.swift
//  BVS
//
//  Created by Peter Slavich on 2/15/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import UIKit
import CoreData

class BVSViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var viewContainerLastMeasurement: UIView!
    @IBOutlet weak var viewContainerMeasuring: UIView!
    @IBOutlet weak var viewBottomDisplay: UIView!
    @IBOutlet weak var labelLastMeasurement: UILabel!
    @IBOutlet weak var labelLastMeasurementTime: UILabel!
    @IBOutlet weak var activityIndicatorMeasuring: UIActivityIndicatorView!
    @IBOutlet weak var labelMeasuringStatus: UILabel!
    @IBOutlet weak var labelDeviceStatus: UILabel!
    
    var lastMeasurement : Measurement? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContainerLastMeasurement.layer.cornerRadius = 5
        self.viewContainerMeasuring.layer.cornerRadius = 5
        fetchLastMeasurement()
        updateMeasurementUI()
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
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
            
            self.labelLastMeasurementTime.text = dateFormatterGet.string(from: measurement.measurementOn! as Date)
            self.labelLastMeasurement.text = String(format: "%.1f", measurement.volume!.doubleValue)
        }
        else {
            self.labelLastMeasurementTime.text = "No Measurements Yet"
            self.labelLastMeasurement.text = "N/A"
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func debug(_ sender: Any) {
        
        self.viewContainerLastMeasurement.isHidden = true
        self.viewContainerMeasuring.isHidden = false
        self.activityIndicatorMeasuring.startAnimating()
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(measurementFinished), userInfo: nil, repeats: false)
    }
    
    @IBAction func showHistory(_ sender: Any) {
        performSegue(withIdentifier: "ShowMeasurementHistory", sender: nil)
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

        for i in 0...2 {
            let subMeasurement = NSEntityDescription.insertNewObject(forEntityName: "SubMeasurement", into: context) as! SubMeasurement
            for j in 1...8 {
                for k in 1...8 {
                    let ddd = dd + Double(10*j + k)
                    subMeasurement[j,k] = NSDecimalNumber(string:String(format:"%.1f",ddd))
                }
            }
            subMeasurement.volume = dn
            let timeInterval = TimeInterval(i)
            subMeasurement.measurementOn = ((measurement.measurementOn! as Date) - timeInterval) as NSDate
            subMeasurement.measurement = measurement
            measurement.addToSubMeasurements(subMeasurement)
        }
        do {
            try context.save()
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
}

