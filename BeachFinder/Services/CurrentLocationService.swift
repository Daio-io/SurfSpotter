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
import GoogleMaps

class CurrentLocationService: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let geoCoder = GMSGeocoder()
    
    private var currentLocation = Variable(Coordinates(0, 0))
    private var cityLocation = Variable("")
    
    override init() {
        super.init()
    }
    
    func currentLocationObservable() -> Observable<Coordinates> {
        return currentLocation.asObservable()
    }
    
    func currentCityLocation() -> Observable<String> {
        return cityLocation.asObservable()
    }
    
    func locate() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValues:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        locationManager.stopUpdatingLocation()
        
        currentLocation.value = Coordinates(locValues.latitude, locValues.longitude)
        
        geoCoder.reverseGeocodeCoordinate(locValues) {[unowned self] (response, error) -> Void in
            let results = response?.firstResult()
            if let res = results?.locality {
                self.cityLocation.value = res
            } else if let res = results?.subLocality {
                self.cityLocation.value = res
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location error: \(error.localizedDescription)")
    }
    
}