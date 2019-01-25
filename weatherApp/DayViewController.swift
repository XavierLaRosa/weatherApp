//
//  DayViewController.swift
//  weatherApp
//
//  Created by Xavier La Rosa on 1/7/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import UIKit
import CoreLocation

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//Variables
    var lowTemp:String = ""
    var highTemp:String = ""
    var sum:String = ""
    var date:String = ""
    var arrayDetails = [String]()
    var icon:String = ""
    var cellSelectedToView:Int = 0
    
    @IBOutlet weak var lowText: UILabel!
    @IBOutlet weak var highText: UILabel!
    @IBOutlet weak var navigationCity: UINavigationItem!
    @IBOutlet weak var iconImage: UIImageView!

//number of days to show
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDetails.count
    }
//number of subsections per day
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
//Show list of day properties:
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        let detailString = arrayDetails[indexPath.section]
        cell.textLabel?.text = detailString
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
//Show alert if description tapped:
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let alertController = UIAlertController(title: "", message:
                arrayDetails[indexPath.section], preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
    }
//Hide UI: if non current day
    func hideCurrentTemp(){
        avgText.isHidden = true
        avgStringLabel.isHidden = true
    }
    
    func updateUI(){
        avgText.text = "\(avgTemp)°F"
        lowText.text = "low: \(lowTemp)°F"
        highText.text = "high: \(highTemp)°F"
        navigationCity.title = date
        iconImage.image = UIImage(named: icon)

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hue: 0.9639, saturation: 0, brightness: 0.05, alpha: 1.0)/* #383838 */
        navigationController?.navigationBar.isHidden = false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var avgStringLabel: UILabel!
    @IBOutlet weak var avgText: UILabel!
    //GOALS
    /*
        - make forecast array
        - grab lat
        - grab long
        - grab location
        - bool of "was current location tapped?"
        - bool of "was not today selected"
     */
    var forecastData = [currentWeather]()
    var latitude:String = "" //grab from week
    var longitude:String = "" //grab from week
    var locationName:String = "" //grab from week
    var wasCurrLocTapped:Bool = false //grab from week
    var wasNonTodayInfoSelected:Bool = false //grab from week
    //standard load and set primary UI
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateUI()
        print("*****View Did Load Activates")
        print(wasNonTodayInfoSelected)
        if wasNonTodayInfoSelected == true{
            hideCurrentTemp()
        }else{
            print("*****About to call weather function")
            print(forecastData)
            print(latitude)
            print(longitude)
            print(locationName)
            print(wasCurrLocTapped)
            print(wasNonTodayInfoSelected)
            getCurrentTemperature(location: locationName, currentLocationGiven: wasCurrLocTapped)
        }
    }
    var avgTemp:String = ""
    
    func getCurrentTemperature (location:String, currentLocationGiven:Bool){
        print("*****Doing weather function")
        let longAndLat = "\(latitude),\(longitude)"
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            print("*****Inside geocode")
            print(self.forecastData)
            print(self.latitude)
            print(self.longitude)
            print(self.locationName)
            print(self.wasCurrLocTapped)
            print(self.wasNonTodayInfoSelected)
            print(location)
            print(currentLocationGiven)
            if error == nil {
                print("*****Passed first if statement")
                if let location = placemarks?.first?.location {
                    print("*****Passed second if statement")
                    currentWeather.forecast(wasCurrTapped: currentLocationGiven, longAndLat: longAndLat, withLocation: location.coordinate, completion: { (results:[currentWeather]?) in
                        
                        if let weatherData = results{
                            print("*****Passed final if statement")
                            self.forecastData = weatherData
                            print(self.forecastData)
                            print("-----------\(self.forecastData[0])")
                        }
                    })
                }
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
