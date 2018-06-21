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
    @IBOutlet weak var labelVolume: UILabel!
    @IBOutlet weak var labelMeasurementOn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SubMeasurement Detail"
        
        if let subMeasurement = self.subMeasurement {
            labelVolume.text = "\(subMeasurement.volume)"
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MM/dd/yyyy, h:mm:ss a"
            let measurementDate = subMeasurement.measurementOn! as Date
            labelMeasurementOn.text = dateFormatterGet.string(from: measurementDate)
        }

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
        cell?.textLabel?.text = String(format: "LED %d Sensor %d: %d", indexPath.section + 1, indexPath.row + 1,sensorReading!)

        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "LED \(section+1)"
    }

}
