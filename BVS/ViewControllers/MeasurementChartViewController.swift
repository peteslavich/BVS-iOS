//
//  MeasurementChartViewController.swift
//  BVS
//
//  Created by Peter Slavich on 6/17/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation
import UIKit
import Charts

class MeasurementChartViewController : UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    var months: [String]!

    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = BarChartData(dataSets: [chartDataSet])
        barChartView.data = chartData
    }
    
    override func viewDidLoad() {
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(dataPoints:months, values: unitsSold)
    }
}
