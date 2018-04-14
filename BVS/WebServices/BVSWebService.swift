//
//  BVSWebService.swift
//  BVS
//
//  Created by Peter Slavich on 3/23/18.
//  Copyright © 2018 Peter Slavich. All rights reserved.
//

import Foundation

class BVSWebService {
    let baseAddress = "http://bvspds.azurewebsites.net/api"
    let session = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask? = URLSessionDataTask()
    
    func postMeasurement(measurement : Measurement) {
        dataTask?.cancel()
        var url = URL(string: baseAddress)!
        url.appendPathComponent("Measurement")
       
        dataTask = session.dataTask(with: url) {
                data, response, error in
                defer {
                    self.dataTask = nil
                }
                if let error = error {
                    //self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                }
                else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    //self.updateSearchResults(data)
                    // 6
                    //DispatchQueue.main.async {
                        //completion(self.tracks, self.errorMessage)
                    //}
                }
            }
            // 7
            dataTask?.resume()
 
 
        }
    
}
