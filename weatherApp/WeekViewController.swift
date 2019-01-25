//
//  WeekViewController.swift
//  weatherApp
//
//  Created by Xavier La Rosa on 1/18/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit
import CoreLocation

class WeekViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//Variables
    var forecastData = [Weather]() //array of all information 7 days worth
    
    var summary:String = ""
    var icon:String = ""
    var precipIntensity:String = ""
        let precipIntensityHead = "Precipitation Intensity: "
    var precipProbability:String = ""
        let precipProbabilityHead = "Precipitation Probability: "
        let precipProbabilityTail = "°"
    var humidity:String = ""
        let humidityHead = "Humidity Percentage: "
        let humidityTail = "°"
    var pressure:String = ""
        let pressureHead = "Pressure: "
    var windSpeed:String = ""
        let windSpeedHead = "Wind Speed: "
        let windSpeedTail = "mph"
    var windGust:String = ""
        let windGustHead = "Wind Gust: "
    var ozone:String = ""
        let ozoneHead = "Ozone: "
    var temperatureMin:String = ""
    var temperatureMax:String = ""
    
    var locationStringPassedOver:String = "" //we need the location string name passed here
    var datePassedOver:String = ""
    var arrayPassedOver = [String]()
    
    var currentLocationGiven = false //we need the bool true if currLoc button is tapped
    var latitude:String = "" //we need the latitude string if bool true otherwise ""
    var longitude:String = "" //we need the latitude string if bool true otherwise ""
//Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var navigationCity: UINavigationItem!
//Standard load page except call function to update weather
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationCity.title = "Location: \(locationStringPassedOver)"
        updateWeatherForLocation(location: locationStringPassedOver, currentLocationGiven: currentLocationGiven)
        print("What has been load in week view----------------")
        print(currentLocationGiven)
        print(latitude)
        print(longitude)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hue: 0.9639, saturation: 0, brightness: 0.05, alpha: 1.0)/* #383838 */
        navigationController?.navigationBar.isHidden = false

    }
//reloads values of sections using Core Location, below functions help create this
    func updateWeatherForLocation (location:String, currentLocationGiven:Bool){
        let longAndLat = "\(latitude),\(longitude)"
        
            CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
                
                if error == nil {
                    if let location = placemarks?.first?.location {
                            Weather.forecast(wasCurrTapped: currentLocationGiven, longAndLat: longAndLat, withLocation: location.coordinate, completion: { (results:[Weather]?) in
                            
                            if let weatherData = results{
                                self.forecastData = weatherData
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                        })
                    }
                }
                
            }
        
    }
//number of days to show
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastData.count
    }
//number of subsections per day
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//loops to put date in each header of all days
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.string(from: date!)
    }
//loops to fill in all cells with values per day
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        let weatherObject = forecastData[indexPath.section]
        
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperatureMax))°F" //option shift 8
        cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 22.0)
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        cell.textLabel?.font = UIFont(name: "Avenir", size: 14.0)
        
        updateWeatherForLocation(location: locationStringPassedOver, currentLocationGiven: currentLocationGiven )
        
        temperatureMax = String(weatherObject.temperatureMax)
        return cell
    }
//if a certain cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let date = Calendar.current.date(byAdding: .day, value: indexPath.section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        datePassedOver = String(dateFormatter.string(from: date!))
        
        let weatherObjectTapped = forecastData[indexPath.section]
        summary = String(weatherObjectTapped.summary)
        icon = weatherObjectTapped.icon
        precipIntensity = precipIntensityHead+String(weatherObjectTapped.precipIntensity)
        precipProbability = precipProbabilityHead + String(weatherObjectTapped.precipProbability) + precipProbabilityTail
        humidity = humidityHead + String(weatherObjectTapped.humidity) + humidityTail
        pressure = pressureHead + String(weatherObjectTapped.pressure)
        windSpeed = windSpeedHead + String(weatherObjectTapped.windSpeed) + windSpeedTail
        windGust = windGustHead + String(weatherObjectTapped.windGust)
        ozone = ozoneHead + String(weatherObjectTapped.ozone)
        temperatureMax = String(weatherObjectTapped.temperatureMax)
        temperatureMin = String(weatherObjectTapped.temperatureMin)
        arrayPassedOver.removeAll()
        arrayPassedOver = [summary, precipIntensity, precipProbability, humidity, pressure, windSpeed, windGust, ozone]
        print("Array Passed Over to Day View: \(arrayPassedOver)")
        if indexPath.section != 0{
            wasNonTodayInfoSelected = true
        }else{
            wasNonTodayInfoSelected = false
        }
        
        performSegue(withIdentifier: "fromWeekToDay", sender: self)
        
    }
    var wasNonTodayInfoSelected:Bool = false
//used to show more info of each day with segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromWeekToDay"{
            guard let destination = segue.destination as? DayViewController else {return}
            print("Array Passed Over to Day View: \(forecastData)")
            print(temperatureMax)
            destination.lowTemp = self.temperatureMin
            destination.highTemp = self.temperatureMax
            destination.avgTemp = self.temperatureMax
            destination.date = self.datePassedOver
            print(arrayPassedOver)
            destination.arrayDetails = arrayPassedOver
            destination.icon = icon
            
            
            if wasNonTodayInfoSelected == true{
                    destination.wasNonTodayInfoSelected = true
            }else{
                destination.wasNonTodayInfoSelected = false
            }
            
            print(latitude)
            print(longitude)
            print(locationStringPassedOver)
            print(wasCurrButtonTapped)
            print(wasNonTodayInfoSelected)
            
            destination.latitude = latitude
            destination.longitude = longitude
            destination.locationName = locationStringPassedOver
            destination.wasCurrLocTapped = wasCurrButtonTapped
            destination.wasNonTodayInfoSelected = wasNonTodayInfoSelected
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

