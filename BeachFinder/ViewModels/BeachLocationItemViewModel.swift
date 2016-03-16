//
//  BeachLocationItemViewModel.swift
//  BeachFinder
//
//  Created by Dai Williams on 16/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import RxSwift

class BeachLocationItemViewModel : NSObject {
    
    private let surfService: SurfReportService?
    private let locationService: CurrentLocationService?
    private let disposeBag = DisposeBag()
    
    private let locationId: Int
    
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
    
    init(_ service: SurfReportService, _ locationService: CurrentLocationService, _ beachLocation: BeachLocation) {
        self.surfService = service
        self.locationService = locationService
        self.locationId = beachLocation.spotId
        self.location.value = beachLocation.location
        self.coords.value = beachLocation.coords
        super.init()
        
        self.refresh()
        
        coords.asObservable()
            .subscribeNext {[unowned self] (lat, lon) -> Void in
                if let distance = self.locationService?.distanceToLocation(Coordinates(lat, lon)) {
                  self.distanceToBeach.value = distance
                }
        }.addDisposableTo(disposeBag)
    }
    
    func refresh(start: Int = NSDate.currentHour()) {
        
       surfService?.getNextSurf(locationId, startTime: start)
            .subscribe(onNext: { [unowned self] (surfReport) -> Void in
                self.maxSwell.value = surfReport.maxSwell
                self.minSwell.value = surfReport.minSwell
                self.date.value = surfReport.date
                self.time.value = surfReport.time
                self.solidStar.value = surfReport.solidStar
                self.fadedStar.value = surfReport.fadedStar
                self.wind.value = surfReport.wind
                }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
    
}