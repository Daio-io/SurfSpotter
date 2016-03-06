//
//  HomeViewModel.swift
//  BeachFinder
//
//  Created by Dai Williams on 24/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    private let beachFinderService: BeachLocationService?
    private let locationService: CurrentLocationService?
    
    private let disposeBag = DisposeBag()
    
    let locations = Variable(Array<BeachLocation>())
    let currentLocation = Variable(Coordinates(0, 0))
    let currentCity = Variable("")
    let distance = Variable(0)
    
    init(_ beachFinderService: BeachLocationService, _ locationService: CurrentLocationService) {
        self.beachFinderService = beachFinderService
        self.locationService = locationService
        
        locationService.currentLocationObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribeNext { [unowned self] (coords) -> Void in
                self.currentLocation.value = coords
            }.addDisposableTo(disposeBag)
        
        locationService.currentCityLocation()
            .subscribeNext { [unowned self](city) -> Void in
                self.currentCity.value = city
        }.addDisposableTo(disposeBag)
    }
    
    func locateMe() {
        locationService?.locate()
    }
    
    func scan() {
        beachFinderService?.getNearestBeachesForLocation(currentLocation.value, distance: distance.value)
            .subscribe(onNext: { [unowned self] (locations) -> Void in
                self.locations.value = locations
                }, onError: { [unowned self] (error) -> Void in
                    self.locations.value = []
                }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
    }
}
