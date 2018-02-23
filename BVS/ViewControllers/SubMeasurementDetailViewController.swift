//
//  SubMeasurementDetailViewController.swift
//  BVS
//
//  Created by Peter Slavich on 2/19/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SubMeasurementDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var subMeasurement : SubMeasurement? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SubMeasurement Detail"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SubMeasurementReadingCell")
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier:"SubMeasurementReadingCell")
        }
        let sensorReading = self.subMeasurement?[indexPath.section + 1, indexPath.row + 1]
        cell?.textLabel?.text = String(format: "Sensor %d LED %d: %.1f", indexPath.section + 1, indexPath.row + 1,sensorReading!.doubleValue)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sensor \(section+1)"
    }

}
