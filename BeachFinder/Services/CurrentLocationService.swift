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
import Alamofire
import SwiftyJSON

enum BeachLocationError: ErrorType {
    case Failed(message: String)
    case Unavailable(message: String)
    case Unknown(message: String)
}

class CurrentLocationService: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private let geoCoder = GMSGeocoder()
    private var apiKey: String
    private var googleDistanceUrl: String

    private let currentLocationObs = Variable(Coordinates(Double(), Double()))
    private let cityLocation = Variable("")

    init(apiKey: String, googleDistanceUrl: String) {
        self.apiKey = apiKey
        self.googleDistanceUrl = googleDistanceUrl
    }

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
        } else {
            informLocationError(.Unavailable(message: "Location services turned off"))
        }
    }
    
    func distanceToLocation(coords: Coordinates) -> Observable<Double> {
        
        let url = buildDistanceUrl(coords)
        let request = Alamofire.request(.GET, url)
        
        return Observable.create { (observer: AnyObserver<Double>) -> Disposable in
            
            request.responseJSON {
                response in switch response.result {
                case .Success(let jsonData):
                    
                    let json = JSON(jsonData)
                    if json["status"] == "OK" {
                        let results = json["rows"].arrayValue.first
                        let elements = results!["elements"].arrayValue.first
                        let distance = elements!["distance"]["value"].doubleValue
                        
                        observer.onNext(distance)
                        
                        observer.onCompleted()
                        
                    } else {
                        observer.onError(NSError(domain: "message", code: 1, userInfo: nil))
                    }
                case .Failure(let error):
                    
                    observer.onError(error)
                }
            }
            
            return AnonymousDisposable {
                request.cancel()
            }
            
        }
    }
    
    private func buildDistanceUrl(coords: Coordinates) -> String {
        return  googleDistanceUrl + "\(currentLocationObs.value.lat),%20\(currentLocationObs.value.lon)&destinations=\(coords.lat),%20\(coords.lon)&key=\(apiKey)"
    }
    
    private func informLocationError(error: BeachLocationError) {
        if let subject = currentLocationObs.asObservable() as? BehaviorSubject<Coordinates> {
            subject.onError(error)
        }
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
        
        currentLocationObs.value = Coordinates(locValues.latitude, locValues.longitude)
        
        locateCityLocation(locValues)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        informLocationError(.Unavailable(message: "Location update failed"))
    }
    
}