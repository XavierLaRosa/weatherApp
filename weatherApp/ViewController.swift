//
//  ViewController.swift
//  weatherApp
//
//  Created by Xavier La Rosa on 1/7/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

///////////////////AS OF 1.21.19////////////////////
/*  - change searchbar input font to white
    - add constraints to week icon images
    - add 1x 2x 3x pictures for main page
    - add a launch page
    - make current weather the most recent hourly weather only for first table cell, all other table cells hide the current
 */

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate{

//Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currLocButton: UIButton!
//Searchbar attributes:
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
//Load Page: aesthetics, reset values,
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        latToPassOver = "DefaultLat"
        longToPassOver = "DefaultLong"
        locationToPassOver = "DefaultLocation"
        wasCurrButtonTapped = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    func setupUI(){//do all UI elements in here
        currLocButton.layer.cornerRadius = 10
        currLocButton.clipsToBounds = true
        
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.tintColor = UIColor.white
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
        
        navigationController?.navigationBar.isHidden = true
    }
//Used searchbar: see if user did not put nil
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        let wasTextMade:String?
        wasTextMade = searchBar.text!
        
        if wasTextMade != nil {
            print("USING SEARCHBAR OPTION:\nLat to Pass in String: \(latToPassOver)\nLong to Pass in String: \(longToPassOver)\nLocation to Pass in String: \(locationToPassOver) \nBool to Pass in Bool: \(wasCurrButtonTapped)")
            locationToPassOver = wasTextMade!
            self.performSegue(withIdentifier: "fromHomeToWeek", sender: self)
        }
        
    }
//Segue: Used Searchbar or Used CurrentLocation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PERFORMING SEGUE----")
        if segue.identifier == "fromHomeToWeek"{
            guard let destination = segue.destination as? WeekViewController else {return}

                destination.locationStringPassedOver = locationToPassOver//if searchbar tapped
                if wasCurrButtonTapped == true {//if button tapped
                    destination.latitude = latToPassOver
                    destination.longitude = longToPassOver
                    destination.currentLocationGiven = wasCurrButtonTapped
                }
                print("WHATS SENT OVER:\nLat to Pass in String: \(latToPassOver)\nLong to Pass in String: \(longToPassOver)\nLocation to Pass in String: \(locationToPassOver) \nBool to Pass in Bool: \(wasCurrButtonTapped)")
        
        }
    }
//Current Location Tapped:
    let locationManager = CLLocationManager()
    @IBAction func currLocTapped(_ sender: Any) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

//Global variables: will be passed over to WeekViewController
var latToPassOver:String = "DefaultLat"
var longToPassOver:String = "DefaultLong"
var locationToPassOver:String = "DefaultLocation"
var wasCurrButtonTapped:Bool = false

//Extension: creates lat, long, location, bool
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            lookUpCurrentLocation { geoLoc in
                
                latToPassOver = String(lat)
                longToPassOver = String(long)
                locationToPassOver = String(geoLoc?.locality ?? "unknown Geo location")
                wasCurrButtonTapped = true
                print("USING BUTTON OPTION:\nLat to Pass in String: \(latToPassOver)\nLong to Pass in String: \(longToPassOver)\nLocation to Pass in String: \(locationToPassOver) \nBool to Pass in Bool: \(wasCurrButtonTapped)")
                self.performSegue(withIdentifier: "fromHomeToWeek", sender: self)
                
            }
        } else {
            print("No coordinates")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
}
