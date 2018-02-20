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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.viewContainerLastMeasurement.layer.cornerRadius = 5
        self.viewContainerMeasuring.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        

        
        
        self.labelLastMeasurement.text = String(format: "%.1f", measurement.volume!.doubleValue)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        self.labelLastMeasurementTime.text = dateFormatterGet.string(from: measurement.measurementOn! as Date)
        
        self.activityIndicatorMeasuring.stopAnimating()
        self.viewContainerMeasuring.isHidden = true

        self.viewContainerLastMeasurement.isHidden = false
    }
}

