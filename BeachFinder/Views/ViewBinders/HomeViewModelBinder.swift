//
//  HomeViewModelBinder.swift
//  BeachFinder
//
//  Created by Dai on 20/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

class HomeViewModelBinder: MainViewBinder {
    
    func bindToBeachScan(viewModel: HomeViewModel) -> Disposable {
        return Observable.combineLatest(viewModel.distance.asObservable(),
            viewModel.currentLocation.asObservable()) { (distance, location) -> (Int, Coordinates)in
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
    
    func bindLocationToMap(viewModel: HomeViewModel, mapView: GMSMapView) -> Disposable {
        return viewModel.currentLocation.asObservable()
            .subscribeNext {(lat, lon) -> Void in
                mapView.camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 8)
        }
        
    }
    
    func bindLocationsFoundToMap(viewModel: HomeViewModel, mapView: GMSMapView) -> Disposable {
        return viewModel.locations.asObservable()
            .subscribeNext { (locations) -> Void in
                mapView.clear()
                for location in locations {
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2DMake(location.coords.lat, location.coords.lon)
                    marker.title = location.location
                    marker.map = mapView
                }
        }
    }
}
