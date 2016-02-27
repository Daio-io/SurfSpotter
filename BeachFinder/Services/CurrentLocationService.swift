//
//  CurrentLocationService.swift
//  BeachFinder
//
//  Created by Dai Williams on 26/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class CurrentLocationService: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    private var currentLocation = Variable(Coordinates(0, 0))
    
    override init() {
        super.init()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    func currentLocationObservable() -> Observable<Coordinates> {        
        return currentLocation.asObservable()
    }
    
    func locate() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValues:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        locationManager.stopUpdatingLocation()
        
        currentLocation.value = Coordinates(locValues.latitude, locValues.longitude)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location error: \(error)")
    }
    
}