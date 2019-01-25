import Foundation
import CoreLocation

struct Weather {
    //variables you can access per day
    let summary:String
    let icon:String
    let precipIntensity:Double
    let precipProbability:Double
    let humidity:Double
    let pressure:Double
    let windSpeed:Double
    let windGust:Double
    let ozone:Double
    let temperatureMin:Double
    let temperatureMax:Double
    //catch errors
    enum errorType:Error {
        case dataPieceIsMissing(String)
        case invalid(String, Any)
    }
    
    //grabbing specific json data
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw errorType.dataPieceIsMissing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw errorType.dataPieceIsMissing("icon is missing")}
        guard let precipIntensity = json["precipIntensity"] as? Double else {throw errorType.dataPieceIsMissing("precipIntensity is missing")}
        guard let precipProbability = json["precipProbability"] as? Double else {throw errorType.dataPieceIsMissing("precipProbability is missing")}
        guard let humidity = json["humidity"] as? Double else {throw errorType.dataPieceIsMissing("humidity is missing")}
        guard let pressure = json["pressure"] as? Double else {throw errorType.dataPieceIsMissing("pressure is missing")}
        guard let windSpeed = json["windSpeed"] as? Double else {throw errorType.dataPieceIsMissing("windSpeed is missing")}
        guard let windGust = json["windGust"] as? Double else {throw errorType.dataPieceIsMissing("windGust is missing")}
        guard let ozone = json["ozone"] as? Double else {throw errorType.dataPieceIsMissing("ozone is missing")}
        guard let temperatureMin = json["temperatureMin"] as? Double else {throw errorType.dataPieceIsMissing("temperatureMin is missing")}
        guard let temperatureMax = json["temperatureMax"] as? Double else {throw errorType.dataPieceIsMissing("temperatureMax is missing")}
        self.summary = summary
        self.icon = icon
        self.precipIntensity = precipIntensity
        self.precipProbability = precipProbability
        self.humidity = humidity
        self.pressure = pressure
        self.windSpeed = windSpeed
        self.windGust = windGust
        self.ozone = ozone
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax
    }
    //standard path for darksky api
    static let basePath = "https://api.darksky.net/forecast/4236058e5c8982e67c6c8cf72e75cc6e/"
    
    //makes unique path refer to users input
    static func forecast (wasCurrTapped:Bool, longAndLat:String, withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
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
        var forecastArray:[Weather] = []
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
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
                print("Forecast Array\(forecastArray)")
            }
        }
        task.resume()
    }
}
