//
//  BeachLocationItemViewModel.swift
//  BeachFinder
//
//  Created by Dai Williams on 16/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import RxSwift

struct BeachLocationItemViewModel {
    
    private let surfService: SurfReportService?
    private let locationService: CurrentLocationService?
    private let myBeachesService: MyBeachesService?
    private let disposeBag = DisposeBag()
    
    private let beachLocation: BeachLocation
    
    let location = Variable("")
    let maxSwell = Variable(0)
    let minSwell = Variable(0)
    let date = Variable("")
    let time = Variable("")
    let wind = Variable(0)
    let solidStar = Variable(0)
    let fadedStar = Variable(0)
    let coords = Variable(Coordinates(0, 0))
    let distanceToBeach = Variable(Double())
    let isFavourited = Variable(false)
    
    init(_ service: SurfReportService,
           _ locationService: CurrentLocationService,
             _ beachLocation: BeachLocation,
               _ myBeachesService: MyBeachesService) {
        
        self.surfService = service
        self.locationService = locationService
        self.myBeachesService = myBeachesService
        self.beachLocation = beachLocation
        self.location.value = beachLocation.location
        self.coords.value = beachLocation.coords
        self.isFavourited.value = myBeachesService.isFavourited(beachLocation.spotId)
        
        self.locationService?.distanceToLocation(beachLocation.coords)
            .asObservable()
            .subscribeNext({ (distance) -> Void in
                self.distanceToBeach.value = distance
            }).addDisposableTo(disposeBag)
        
    }
    
    func refresh(start: Int = NSDate.currentHour()) {
        surfService?.getNextSurf(beachLocation.spotId, startTime: start)
            .subscribe(onNext: { (surfReport) -> Void in
                self.maxSwell.value = surfReport.maxSwell
                self.minSwell.value = surfReport.minSwell
                self.date.value = surfReport.date
                self.time.value = surfReport.time
                self.solidStar.value = surfReport.solidStar
                self.fadedStar.value = surfReport.fadedStar
                self.wind.value = surfReport.wind
                }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
    
    func favourite() {
        if isFavourited.value == true {
            myBeachesService?.removeBeach(beachLocation.spotId)
            isFavourited.value = false
        } else {
            isFavourited.value = true
            myBeachesService?.saveBeach(beachLocation)
        }
    }
    
}