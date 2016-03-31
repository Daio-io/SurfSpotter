//
//  CurrentLocationService.swift
//  BeachFinder
//
//  Created by Dai Williams on 26/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import CoreLocation
import RxSwift
import GoogleMaps
import Alamofire
import SwiftyJSON

class CurrentLocationService: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private let geoCoder = GMSGeocoder()
    private var distanceFinder: DistanceFinder

    private let currentLocationObs = Variable(CurrentLocationResult.Failed(message: "Failed"))
    private let cityLocation = Variable("")

    init(distanceFinder: DistanceFinder) {
        self.distanceFinder = distanceFinder
    }

    func currentLocationObservable() -> Observable<CurrentLocationResult> {
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
        } else {
            currentLocationObs.value = .Failed(message: "Failed")
            cityLocation.value = "Failed"
        }
    }
    
    func distanceToLocation(coords: Coordinates) -> Observable<Double> {
        
        guard case .Success(let current) = currentLocationObs.value else {
            return Variable(0.0).asObservable()
        }
     
        return distanceFinder.distanceToLocation(coords, from: current)
        
    }
    
    private func locateCityLocation(loc: CLLocationCoordinate2D) {
        geoCoder.reverseGeocodeCoordinate(loc) {[unowned self] (response, error) -> Void in
            let results = response?.firstResult()
            if let res = results?.locality {
                self.cityLocation.value = res
            } else if let res = results?.subLocality {
                self.cityLocation.value = res
            } else {
                self.cityLocation.value = "Unknown"
            }
        }
    }
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValues:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        locationManager.stopUpdatingLocation()
        
        currentLocationObs.value = CurrentLocationResult.Success(coords: Coordinates(locValues.latitude, locValues.longitude))
        
        locateCityLocation(locValues)
    }
    
}