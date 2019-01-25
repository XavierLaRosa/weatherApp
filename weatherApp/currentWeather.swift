//
//  currentWeather.swift
//  testWeather
//
//  Created by Xavier La Rosa on 1/22/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import Foundation
import CoreLocation

struct currentWeather {
    //variables you can access for specific day
    let temperature:String
    enum errorType:Error {
        case dataPieceIsMissing(String)
        case invalid(String, Any)
    }
    //catch errors
    init(json:[String:Any]) throws {
        guard let temperature = json["temperature"] as? Double else {throw errorType.dataPieceIsMissing("temperature is missing")}
        self.temperature = String(temperature)
    }
    
    //grabbing specific json data
    static let basePath = "https://api.darksky.net/forecast/4236058e5c8982e67c6c8cf72e75cc6e/"
    static func forecast (wasCurrTapped:Bool, longAndLat:String, withLocation location:CLLocationCoordinate2D, completion: @escaping ([currentWeather]?) -> ()) {
        var url = basePath
        print("------ below is the bool passed into weather struct")
        print(wasCurrTapped)
        if wasCurrTapped == false{
            url = basePath + "\(location.latitude),\(location.longitude)"
        }else{
            url = basePath + "\(longAndLat)"
        }
        print("THIS IS THE URL\(url)")
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var forecastArray:[currentWeather] = []
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["hourly"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? currentWeather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        task.resume()
    }
}
