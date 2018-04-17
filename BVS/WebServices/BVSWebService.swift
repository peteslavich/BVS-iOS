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
        var url = URL(string: baseAddress)!
        url.appendPathComponent("Measurement")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let uploadData = try? encoder.encode(measurement) else {
            return
        }
        
        let s = String(data:uploadData, encoding: String.Encoding.utf8) as String?
        print ("json data: " + s!)

        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            if let mimeType = response.mimeType,
                //mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()
 
        }
    
}
