//
//  SubMeasurementsViewController.swift
//  BVS
//
//  Created by Peter Slavich on 2/19/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MeasurementDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var measurement : Measurement? = nil
    var subMeasurementArray : [SubMeasurement] = [SubMeasurement]()
    var selectedIndex : Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subMeasurementArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubMeasurementCell")
        if cell == nil {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier:"SubMeasurementCell")
        }
        let subMeasurement = subMeasurementArray[indexPath.row]
        cell?.textLabel?.text = String(format: "%.1f", subMeasurement.volume!.doubleValue)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        cell?.detailTextLabel?.text = dateFormatterGet.string(from: subMeasurement.measurementOn! as Date)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "ShowSubMeasurementDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let subMeasurementDetail = segue.destination as! SubMeasurementDetailViewController
        subMeasurementDetail.subMeasurement = self.subMeasurementArray[self.selectedIndex]
    }
    
    func updateData() {
        subMeasurementArray = measurement?.subMeasurements!.allObjects as! [SubMeasurement]
    }
}
