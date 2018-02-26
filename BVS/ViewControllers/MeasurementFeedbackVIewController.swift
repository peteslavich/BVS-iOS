//
//  MeasurementFeedbackVIewController.swift
//  BVS
//
//  Created by Peter Slavich on 2/22/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MeasurementFeedbackViewController : UIViewController {
    
    var measurement : Measurement? = nil

    @IBOutlet weak var labelMeasurementDate: UILabel!
    @IBOutlet weak var labelMeasurementVolume: UILabel!
    @IBOutlet weak var sliderFeedbackRating: UISlider!
    @IBOutlet weak var labelFeedbackRating: UILabel!
    @IBOutlet weak var textFieldAdditionalFeedback: UITextView!
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func savePressed(_ sender: Any) {
        self.measurement?.patientRating = Int(self.sliderFeedbackRating.value) as NSNumber
        self.measurement?.patientFeedback = self.textFieldAdditionalFeedback.text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        }
        catch {
            
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func sliderValueChanged(_ sender: Any) {
        self.labelFeedbackRating.text = String(format:"%d",Int(self.sliderFeedbackRating.value))
    }

    func updateUI() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        self.labelMeasurementDate.text = dateFormatterGet.string(from: self.measurement!.measurementOn! as Date)
        self.labelMeasurementVolume.text = String(format: "%.1f", measurement!.volume!.doubleValue)
        
        if let rating = self.measurement?.patientRating {
            self.sliderFeedbackRating.value = Float(rating.intValue)
            self.labelFeedbackRating.text = String(format:"%d",rating.intValue)
        }
        if let additionalFeedback = self.measurement?.patientFeedback {
            self.textFieldAdditionalFeedback.text = additionalFeedback
        }
    }
} 