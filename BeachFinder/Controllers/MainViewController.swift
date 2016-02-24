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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapViewPlaceholder: GMSMapView!
    @IBOutlet weak var distanceSlider: UISlider!
    
    let locationManager = CLLocationManager()
    let locator = BeachLocatorService()
    let service = SurfQueryService()
    var currentLocation: Coordinates?
    
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
        
        let coords = (lat, long)
        
        self.mapViewPlaceholder.clear()
        
        let _ = locator.getNearestBeachesForLocation(coords, distance: dist)
            .subscribe(
                onNext: {[unowned self] (beaches) -> Void in
                
                    let viewModels = beaches.map({ (beach) -> BeachLocationItemViewModel in
                        return BeachLocationItemViewModel(self.service, beach)
                    })
                    let co = BeachLocationsViewController(beaches: viewModels)
                    
                    self.presentViewController(co, animated: true, completion: nil)
                    
                },
                onError:  {(error) -> Void in
                    print(error)
            })
        
    }
    
    private func dropMarker(beach: BeachLocation, currentLoc: CLLocation) {
        let marker = GMSMarker()
        let beachLocation = CLLocation(latitude: beach.coords.lat, longitude: beach.coords.lon)
        let distance = currentLoc.distanceFromLocation(beachLocation)
        marker.position = CLLocationCoordinate2DMake(beach.coords.lat, beach.coords.lon)
        
        marker.title = beach.location
        marker.snippet = String(Int(distance)) + " Meters away"
        marker.map = self.mapViewPlaceholder
    }
    
    @IBAction func distanceChanged(sender: AnyObject) {
        if let location = currentLocation {
            let dist = Int(self.distanceSlider.value)
            distanceLabel.text = String(self.distanceSlider.value) + "m"
            getLocationData(location.lat, long: location.lon, dist: dist)
            
        }
        
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValues:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        self.locationManager.stopUpdatingLocation()
        
        let camera = GMSCameraPosition.cameraWithLatitude(locValues.latitude,
            longitude: locValues.longitude, zoom: 8)
        self.mapViewPlaceholder.camera = camera
        
        currentLocation = Coordinates(locValues.latitude, locValues.longitude)
        let distance = Int(self.distanceSlider.value)
        self.getLocationData(locValues.latitude, long: locValues.longitude, dist: distance)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location error: \(error)")
    }
    
}
