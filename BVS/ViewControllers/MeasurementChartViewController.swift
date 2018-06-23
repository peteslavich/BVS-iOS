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
    var months: [String]!
    let count = 100
    
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
        self.setDataCount(100, range: 30)

        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(MeasurementChartViewController.dateSelect(sender:)))
        labelStartDate.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer()
        tap2.addTarget(self, action: #selector(MeasurementChartViewController.dateSelect(sender:)))
        labelEndDate.addGestureRecognizer(tap2)
    }
    
    func setUpChart() {
//        self.title = "Line Chart 2"
//        self.options = [.toggleValues,
//                        .toggleFilled,
//                        .toggleCircles,
//                        .toggleCubic,
//                        .toggleHorizontalCubic,
//                        .toggleStepped,
//                        .toggleHighlight,
//                        .animateX,
//                        .animateY,
//                        .animateXY,
//                        .saveToGallery,
//                        .togglePinchZoom,
//                        .toggleAutoScaleMinMax,
//                        .toggleData]
        
        //chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        
        chartView.backgroundColor = .white
        
        chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .topInside
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 3600
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
        
//        sliderX.value = 100
//        slidersValueChanged(nil)
        
        chartView.animate(xAxisDuration: 2.5)
    }

    func setDataCount(_ count: Int, range: UInt32) {
        let now = Date()
        
        let today = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: now))
        let threeDaysBack = today?.addingTimeInterval(-3600*24)
        let twentyMinutes: TimeInterval = 1200
        let timeValues = stride(from:Double((threeDaysBack?.timeIntervalSince1970)!), to:Double((today?.timeIntervalSince1970)!), by: twentyMinutes)
        
//        let from = now - 72.0 * hourSeconds
//        let to = now
//
//        let values = stride(from: from, to: to, by: 1200).map { (x) -> ChartDataEntry in
//            let y = arc4random_uniform(range) + 50
//            return ChartDataEntry(x: x, y: Double(y))
//        }
        var values = [ChartDataEntry]()
        var x = 0
        for t in timeValues {
            let v = 50 + 75*x
            values.append(ChartDataEntry(x: t, y: Double(v)))
            x = (x + 1) % 3
        }
        
        

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        let measurementFetch = NSFetchRequest<Measurement>(entityName: "Measurement")
//        let sort = NSSortDescriptor(key: #keyPath(Measurement.measurementOn), ascending: false)
//        measurementFetch.sortDescriptors = [sort]
        
//        var measurements = [Measurement]()
//        do {
//            measurements = try context.fetch(measurementFetch as! NSFetchRequest<NSFetchRequestResult>) as! [Measurement]
//        }
//        catch {
//            fatalError("Failed to fetch measurements: \(error)")
//        }
        
//        let values = measurements.map { (x) -> ChartDataEntry in
//            let y = x.volume
//            return ChartDataEntry(x: (x.measurementOn?.timeIntervalSince1970)!, y: Double(y))
//        }

        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.lineWidth = 1.5
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
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
    
    
    //selected date func
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
        
    }
}

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
