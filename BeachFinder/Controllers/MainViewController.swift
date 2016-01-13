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

class MainViewController: UIViewController, CLLocationManagerDelegate, BeachLocatorServiceDelegate {
    let locationManager = CLLocationManager()
    let locator = BeachLocatorService()
    var mapView : GMSMapView
    
    init() {
        let camera = GMSCameraPosition.cameraWithLatitude(53.470884,
            longitude: -2.294144, zoom: 6)
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.mapView.myLocationEnabled = true
        super.init(nibName:nil, bundle:nil)
        
        self.locator.delegate = self
        
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
        
        self.getSurfData(locValues.latitude, long: locValues.longitude, dist: 500000)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    // TODO: create service/repo to make proper network requests
    
    func getSurfData(lat: Double, long: Double, dist: Int) {
        
        self.locator.getNearestBeachesForLocation(lat, longitide: long, distance: dist)
    }
    
    // MARK: BeachLocatorServiceDelegate
    
    func didFindLocation(location: BeachLocation) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(location.lat, location.lon)
        marker.title = location.location
        marker.snippet = location.country
        marker.map = self.mapView
    }

}
