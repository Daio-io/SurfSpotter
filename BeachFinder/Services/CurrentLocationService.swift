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
    
    private var currentLocationObs = Variable(Coordinates(Double(), Double()))
    private var cityLocation = Variable("")
    
    private var currentLocation: Coordinates?
    
    func currentLocationObservable() -> Observable<Coordinates> {
        return currentLocationObs.asObservable()
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
    
    func distanceToLocation(coords: Coordinates) -> Double? {
        if let cL = currentLocation {
            let location = CLLocation(latitude: cL.lat, longitude: cL.lon)
            let toLocation = CLLocation(latitude: coords.lat, longitude: coords.lon)
            return location.distanceFromLocation(toLocation)
        }
        return nil
    }
    
    
    // MARK - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValues:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        locationManager.stopUpdatingLocation()
        
        let coords = Coordinates(locValues.latitude, locValues.longitude)
        currentLocation = coords;
        currentLocationObs.value = Coordinates(locValues.latitude, locValues.longitude)
        
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