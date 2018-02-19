//
//  MeasurementHistoryViewController.swift
//  BVS
//
//  Created by Peter Slavich on 2/18/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MeasurementHistoryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var measurements : [Measurement] = [Measurement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementCell")
        if cell == nil {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier:"MeasurementCell")
        }
        let measurement = measurements[indexPath.row]
        cell?.textLabel?.text = String(format: "%.1f", measurement.volume!.doubleValue)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        cell?.detailTextLabel?.text = dateFormatterGet.string(from: measurement.measurementOn! as Date)
        
        
        
        return cell!
    }
    
    func updateData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let measurementFetch = NSFetchRequest(entityName: "Measurement") as NSFetchRequest<Measurement>
        
        do {
            self.measurements = try context.fetch(measurementFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Measurement]
        }
        catch {
            fatalError("Failed to fetch measurements: \(error)")
        }

    }
}
