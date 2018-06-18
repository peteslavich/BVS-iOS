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
    var selectedIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateData()
        self.navigationItem.title = "Measurement History"
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
//        if measurement.serverID > 0 {
//            cell?.textLabel?.text?.append(String(format: " (ServerID: %d)", measurement.serverID))
//        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        cell?.detailTextLabel?.text = dateFormatterGet.string(from: measurement.measurementOn! as Date)
        cell?.accessoryType = .detailButton
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "ShowMeasurementDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "ShowMeasurementFeedback", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMeasurementDetail" {
            let measurementDetail = segue.destination as! MeasurementDetailViewController
            measurementDetail.measurement = self.measurements[self.selectedIndex]
        }
        else if segue.identifier == "ShowMeasurementFeedback" {
            let nav = segue.destination as! UINavigationController
            let measurementFeedback = nav.topViewController as! MeasurementFeedbackViewController
            measurementFeedback.measurement = self.measurements[self.selectedIndex]
        }
    }
    
    @IBAction func chartPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showChart", sender: nil)
    }
    
    func updateData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let measurementFetch = NSFetchRequest<Measurement>(entityName: "Measurement")
        let sort = NSSortDescriptor(key: #keyPath(Measurement.measurementOn), ascending: false)
        measurementFetch.sortDescriptors = [sort]
        
        do {
            self.measurements = try context.fetch(measurementFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Measurement]
        }
        catch {
            fatalError("Failed to fetch measurements: \(error)")
        }

    }
}
