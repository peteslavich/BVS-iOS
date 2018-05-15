//
//  LoginViewController.swift
//  BVS
//
//  Created by Peter Slavich on 2/22/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func cancelPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell")
        if cell == nil {
            cell = UITableViewCell(style:.subtitle, reuseIdentifier:"LoginCell")
        }
        
//        cell?.textLabel?.text = String(format: "%.1f", measurement.volume!.doubleValue)
//        if measurement.serverID > 0 {
//            cell?.textLabel?.text?.append(String(format: " (ServerID: %d)", measurement.serverID))
//        }
//
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
//
//        cell?.detailTextLabel?.text = dateFormatterGet.string(from: measurement.measurementOn! as Date)
//
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "User Email"
        }
        return "Password"
    }
}
