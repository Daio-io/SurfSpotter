//
//  MainViewController.swift
//  BeachFinder
//
//  Created by Dai Williams on 11/01/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var mapView : GMSMapView
    
    init() {
        let camera = GMSCameraPosition.cameraWithLatitude(53.470884,
            longitude: -2.294144, zoom: 6)
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.mapView.myLocationEnabled = true
        
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.mapView
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValues:CLLocationCoordinate2D = (manager.location?.coordinate)!
        print("location: \(locValues.longitude) and \(locValues.latitude)")
        
        self.locationManager.stopUpdatingLocation()
        
        self.getSurfData("https://beach-locator.herokuapp.com/location?lat=\(locValues.latitude)&long=\(locValues.longitude)&dist=100000")
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    // TODO: create service/repo to make proper network requests
    
    func getSurfData(requestUrl: String) {
        
        print(requestUrl)
        let url: NSURL = NSURL(string: requestUrl)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        var response: NSURLResponse?
        do {
            let urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(urlData, options: .MutableContainers) as? NSDictionary {
                if let arr = jsonResult["response"] as? Array<NSDictionary> where arr.count > 0 {
                    for (index, element) in arr.enumerate() {
                        let results = element as NSDictionary
                        let location = results["location"] as! String
                        let country = results["country"] as! String
                        let coords = results["coords"] as! Dictionary<String, CLLocationDegrees>
                        
                        let lat = coords["lat"]!
                        let long = coords["long"]!
                        
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake(lat, long)
                        marker.title = location
                        marker.snippet = country
                        marker.map = self.mapView
                        print(index, ":", element)
                    }
 
                }
                
            } else {
                print("failed")
            }
        } catch _ {
             print("failed")
        }
    }
    

}
