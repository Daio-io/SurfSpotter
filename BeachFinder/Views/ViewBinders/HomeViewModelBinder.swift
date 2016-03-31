//
//  HomeViewModelBinder.swift
//  BeachFinder
//
//  Created by Dai on 20/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import RxSwift
import RxCocoa
import GoogleMaps

class HomeViewModelBinder: MainViewBinder {
    
    func bindToBeachScan(viewModel: HomeViewModel) -> Disposable {
        return Observable.combineLatest(viewModel.distance.asObservable(),
        viewModel.currentLocation.asObservable()) { (distance, location) -> (Int, CurrentLocationResult)in
            return (distance, location)
            }.throttle(0.5, scheduler: MainScheduler.instance)
            .subscribeNext {(distance, location) -> Void in
                viewModel.scan()
        }
    }
    
    func bindToScanDistanceChange(viewModel: HomeViewModel, slider: UISlider, observer: AnyObserver<String>) -> Disposable {
        return slider.rx_value.asObservable()
            .startWith(slider.value)
            .doOnNext({ (distance) -> Void in
                let meters = DistanceConverter.milesToMeters(distance)
                viewModel.distance.value = Int(meters)
            })
            .map({ (distance) -> String in
                return String(format: "%.1f mile radius", distance)
            })
            .bindTo(observer)
    }
    
    func bindToCurrentCity(viewModel: HomeViewModel, observer: AnyObserver<String>) -> Disposable {
        return viewModel.currentCity.asObservable()
            .bindTo(observer)
    }
    
    func bindToLocationFound(viewModel: HomeViewModel, observer: AnyObserver<Bool>) -> Disposable {
        return viewModel.locations.asObservable()
            .map { (locations) -> Bool in
                return  !locations.isEmpty
            }.bindTo(observer)
    }
    
    func bindLocationToMap(viewModel: HomeViewModel, mapView: UIView) -> Disposable {
        
        return viewModel.currentLocation.asObservable()
            .subscribeNext {(current) -> Void in
                
                guard case .Success(let coords) = current else {
                    return
                }
                if let mapView = mapView as? GMSMapView {
                    mapView.camera = GMSCameraPosition.cameraWithLatitude(coords.lat, longitude: coords.lon, zoom: 7)
                }
        }
        
    }
    
    func bindLocationsFoundToMap(viewModel: HomeViewModel, mapView: UIView) -> Disposable {
        return viewModel.locations.asObservable()
            .subscribeNext { (locations) -> Void in
                
                if let map = mapView as? BeachFinderMap {
                    map.clear()
                    for location in locations {
                        map.addAnotherPin(location.location, coords: location.coords)
                    }
                    
                }
        }
    }
    
    func bindShowingErrorForLocation(viewModel: HomeViewModel, observer: AnyObserver<Bool>) -> Disposable {
        return viewModel.currentLocation.asObservable()
            .map({ (current) -> Bool in
                if case .Failed(_) = current {
                    return false
                }
                return true
            }).bindTo(observer)
    }
}
