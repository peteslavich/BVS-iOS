//
//  MeasurementChartViewController.swift
//  BVS
//
//  Created by Peter Slavich on 6/17/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Charts

class MeasurementChartViewController : UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelEndDate: UILabel!
    
    var datePicker = UIDatePicker()
    var selectedLabel : UILabel? = nil
    
    var startDate = Date()
    var endDate = Date()

    override func viewDidLoad() {
        
        let now = Date()
        
        let today = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: now))!
        startDate = today
        endDate = today
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        labelStartDate?.text = dateFormatter.string(from: startDate)
        labelEndDate?.text = dateFormatter.string(from: endDate)

        setUpChart();
        self.updateChartData()

        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(MeasurementChartViewController.dateSelect(sender:)))
        labelStartDate.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer()
        tap2.addTarget(self, action: #selector(MeasurementChartViewController.dateSelect(sender:)))
        labelEndDate.addGestureRecognizer(tap2)
    }
    
    func setUpChart() {

        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        //chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        
        chartView.backgroundColor = .white
        
        chartView.legend.enabled = false
        chartView.setViewPortOffsets(left: 10, top: 20, right: 20, bottom: 10)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .top
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
//        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularityEnabled = true
        xAxis.granularity = 3600
        //xAxis.axisMaxLabels = 6
        xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .insideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 1000
        leftAxis.yOffset = -9
        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        
        
        chartView.rightAxis.enabled = false
        
        chartView.legend.form = .line
        
        
        chartView.animate(xAxisDuration: 1.0)
    }

    func updateChartData() {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let measurementFetch = NSFetchRequest<Measurement>(entityName: "Measurement")
        
        let endDatePlusOne = endDate.addingTimeInterval(24*3600)
        let startPredicate = NSPredicate(format: "measurementOn >= %@ AND measurementOn < %@", startDate as NSDate, endDatePlusOne as NSDate)
        measurementFetch.predicate = startPredicate
        
        let sort = NSSortDescriptor(key: #keyPath(Measurement.measurementOn), ascending: true)
        measurementFetch.sortDescriptors = [sort]
        

        var measurements = [Measurement]()
        do {
            measurements = try context.fetch(measurementFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Measurement]
        }
        catch {
            fatalError("Failed to fetch measurements: \(error)")
        }

        var max : Int32 = 0
        let values = measurements.map { (x) -> ChartDataEntry in
            let y = x.volume
            if y > max {
                max = y
            }
            return ChartDataEntry(x: (x.measurementOn?.timeIntervalSince1970)!, y: Double(y))
        }

        let xAxis = chartView.xAxis
        xAxis.axisMinimum = startDate.timeIntervalSince1970
        xAxis.axisMaximum = endDatePlusOne.timeIntervalSince1970
        xAxis.granularity = (xAxis.axisMaximum - xAxis.axisMinimum) / 4
        
        let yAxis = chartView.leftAxis
        yAxis.axisMaximum = Double(min(1000, max + 100))
        
        
        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.lineWidth = 1.5
        set1.drawCirclesEnabled = true
        set1.drawValuesEnabled = true
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = true
        set1.circleRadius = 4
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        chartView.data = data
    }
    
    @objc func dateSelect(sender:UITapGestureRecognizer) {
        
        selectedLabel = sender.view! as? UILabel
        
        //init date picker
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 260))
        self.datePicker.datePickerMode = .date
        if selectedLabel == labelStartDate {
            self.datePicker.setDate(startDate, animated: false)
        }
        else {
            self.datePicker.setDate(endDate, animated: false)
        }
        
        //add target
        self.datePicker.addTarget(self, action: #selector(dateSelected(datePicker:)), for: .valueChanged)
        
        //add to actionsheetview
        let alertController = UIAlertController(title: "Date Selection", message:" " , preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.view.addSubview(self.datePicker)
    
        let cancelAction = UIAlertAction(title: "Done", style: .cancel) { (action) in
            //self.dateSelected(datePicker: self.datePicker)
            self.refreshChart()
        }
    
        //add button to action sheet
        alertController.addAction(cancelAction)
    
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        alertController.view.addConstraint(height);
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func dateSelected(datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let currentDate = datePicker.date
        selectedLabel?.text = dateFormatter.string(from: currentDate)
        
        if let label = selectedLabel {
            if label == labelStartDate {
                startDate = currentDate
                if endDate < startDate {
                    endDate = startDate
                    labelEndDate.text = dateFormatter.string(from: endDate)

                }
            }
            else if label == labelEndDate {
                endDate = currentDate
                if startDate > endDate {
                    startDate = endDate
                    labelStartDate.text = dateFormatter.string(from: startDate)
                }
            }
        }
    }
    
    public func refreshChart() {
        updateChartData()
        chartView.animate(xAxisDuration: 1.0)
    }
}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "M/dd HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
