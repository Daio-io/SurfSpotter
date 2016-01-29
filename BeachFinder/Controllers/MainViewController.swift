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
    let locator = BeachLocatorService()
    
    var currentLat: Double?
    var currentLong: Double?
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapViewPlaceholder: GMSMapView!
    @IBOutlet weak var distanceSlider: UISlider!
    
    init() {
        super.init(nibName:nil, bundle:nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewPlaceholder.myLocationEnabled = true
        self.distanceLabel.text = String(self.distanceSlider.value) + "m"
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
    
    // MARK - Internal
    
    func getLocationData(lat: Double, long: Double, dist: Int) {
        
        weak var weakSelf = self

        let coords = (lat, long)
        let camera = GMSCameraPosition.cameraWithLatitude(lat,
            longitude: long, zoom: 8)
        
        self.mapViewPlaceholder.camera = camera
        
        self.mapViewPlaceholder.clear()
        locator.getNearestBeachesForLocation(coords, distance: dist,
            success: { response in response
                for beach in response {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2DMake(beach.coords.lat, beach.coords.lon)
                    marker.title = beach.location
                    marker.snippet = beach.country
                    marker.map = weakSelf?.mapViewPlaceholder
                }
            }, failure: {error in error
                print(error.domain)
        } )
    }
    
    @IBAction func distanceChanged(sender: AnyObject) {
        if let long = currentLong, lat = currentLat {
            let dist = Int(self.distanceSlider.value)
            self.distanceLabel.text = String(self.distanceSlider.value) + "m"
            self.getLocationData(lat, long: long, dist: dist)
        }

    }

    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValues:CLLocationCoordinate2D = (manager.location?.coordinate)!
        print("location: \(locValues.longitude) and \(locValues.latitude)")
        
        self.locationManager.stopUpdatingLocation()
        
        currentLat = locValues.latitude;
        currentLong = locValues.longitude;
        let distance = Int(self.distanceSlider.value)
        self.getLocationData(locValues.latitude, long: locValues.longitude, dist: distance)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location error: \(error)")
    }

}
