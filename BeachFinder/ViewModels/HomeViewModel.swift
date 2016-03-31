//
//  HomeViewModel.swift
//  BeachFinder
//
//  Created by Dai Williams on 24/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import RxSwift

struct HomeViewModel {
    
    private let beachFinderService: BeachLocationService?
    private let locationService: CurrentLocationService?
    
    private let disposeBag = DisposeBag()
    
    let locations = Variable(Array<BeachLocation>())
    let currentLocation = Variable(CurrentLocationResult.Failed(message: "Loading"))
    let currentCity = Variable("")
    let distance = Variable(0)
    
    init(_ beachFinderService: BeachLocationService, _ locationService: CurrentLocationService) {
        self.beachFinderService = beachFinderService
        self.locationService = locationService
        
        setUpLocationObservables()
    }
    
    func locateMe() {
        locationService?.locate()
    }
    
    func scan() {
        if case .Success(let coords) = currentLocation.value {
            beachFinderService?.getNearestBeachesForLocation(coords, distance: distance.value)
                .subscribe(onNext: { (locations) -> Void in
                    self.locations.value = locations
                    }, onError: { (error) -> Void in
                        self.locations.value = []
                    }, onCompleted: nil, onDisposed: nil)
                .addDisposableTo(disposeBag)
        }
        
    }
    
    // Mark - Internal
    
    private func setUpLocationObservables() {
        
        locationService?.currentLocationObservable()
            .subscribeNext({ (result) in switch result {
            case .Success(let coords):
                self.currentLocation.value = CurrentLocationResult.Success(coords: coords)
            case .Failed(let message):
                self.currentLocation.value = CurrentLocationResult.Failed(message: message)
                self.currentCity.value = message
                }
            }).addDisposableTo(disposeBag)
        
        locationService?.currentLocationObservable()
        
        locationService?.currentCityLocation()
            .subscribeNext { (city) -> Void in
                self.currentCity.value = city
            }.addDisposableTo(disposeBag)
    }
}
