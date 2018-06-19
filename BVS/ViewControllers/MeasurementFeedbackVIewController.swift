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
import AVFoundation

class MeasurementFeedbackViewController : UIViewController {
    
    var measurement : Measurement? = nil
    var webServiceManager : BVSWebService!
    var isThumbsUpSelected : Bool = false
    var isThumbsDownSelected : Bool = false
    

    @IBOutlet weak var labelMeasurementInfo: UILabel!
    @IBOutlet weak var sliderFeedbackRating: UISlider!
    @IBOutlet weak var labelFeedbackRating: UILabel!
    @IBOutlet weak var textFieldAdditionalFeedback: UITextView!
    @IBOutlet weak var buttonThumbsUp: UIButton!
    @IBOutlet weak var buttonThumbsDown: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        webServiceManager = appDelegate.webService!
        updateUI()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        if let measurement = self.measurement {
            measurement.patientRating = Int(self.sliderFeedbackRating.value) as NSNumber
            measurement.patientFeedback = self.textFieldAdditionalFeedback.text
            measurement.isRatingThumbsUp = isThumbsUpSelected
            measurement.isRatingThumbsDown = isThumbsDownSelected
            measurement.updatedOn = NSDate()
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            do {
                try context.save()
                webServiceManager.addObjectIDToQueue(objectID: (measurement.objectID))
            }
            catch {
                
            }
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        if let nav = presentingViewController as? UINavigationController {
            if let bvs = nav.topViewController as? BVSViewController {
                bvs.updateMeasurementUI()
            }
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        self.labelFeedbackRating.text = String(format:"%d",Int(self.sliderFeedbackRating.value))
    }

    @IBAction func thumbsUpPressed(_ sender: Any) {
        let systemSoundID: SystemSoundID = 1052
        AudioServicesPlaySystemSound (systemSoundID)
        isThumbsUpSelected = true
        isThumbsDownSelected = false
        updateUIThumbs()
    }
    
    @IBAction func thumbsDownPressed(_ sender: Any) {
        let systemSoundID: SystemSoundID = 1052
        AudioServicesPlaySystemSound (systemSoundID)
        isThumbsUpSelected = false
        isThumbsDownSelected = true
        updateUIThumbs()
    }
    
    func updateUI() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM/dd/yyyy hh:mm:ss"
        
        if let measurement = self.measurement {
            self.labelMeasurementInfo.text = String(format: "%@: %d", dateFormatterGet.string(from: measurement.measurementOn! as Date), measurement.volume)
            
            if let rating = measurement.patientRating {
                self.sliderFeedbackRating.value = Float(rating.intValue)
                self.labelFeedbackRating.text = String(format:"%d",rating.intValue)
            }
            if let additionalFeedback = measurement.patientFeedback {
                self.textFieldAdditionalFeedback.text = additionalFeedback
            }
            
            if measurement.isRatingThumbsUp {
                isThumbsUpSelected = true
                isThumbsDownSelected = false
            }
            else if measurement.isRatingThumbsDown {
                isThumbsUpSelected = false
                isThumbsDownSelected = true
            }
            updateUIThumbs()
        }
    }
    
    func updateUIThumbs() {
        if isThumbsUpSelected {
            buttonThumbsUp.alpha = 1.0
            buttonThumbsDown.alpha = 0.15
        }
        else if isThumbsDownSelected {
            buttonThumbsUp.alpha = 0.15
            buttonThumbsDown.alpha = 1.0
        }
    }
    
} 
