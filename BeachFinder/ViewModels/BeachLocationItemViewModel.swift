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
    private var subscription: Disposable?
    
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
    
    init(_ service: SurfReportService, _ beachLocation: BeachLocation) {
        self.surfService = service
        self.locationId = beachLocation.spotId
        self.location.value = beachLocation.location
        self.coords.value = beachLocation.coords
        super.init()
        
        self.refresh()
    }
    
    deinit {
        subscription?.dispose()
    }
    
    func refresh(start: Int = NSDate().currentHour(), _ fin: Int = NSDate().currentHour() + 3) {
        
        subscription = surfService?.getSurfData(locationId, startTime: start, finishTime: fin)
            .subscribe(onNext: { [unowned self] (surfReport) -> Void in
                self.maxSwell.value = surfReport.maxSwell
                self.minSwell.value = surfReport.minSwell
                self.date.value = surfReport.date
                self.time.value = surfReport.time
                self.solidStar.value = surfReport.solidStar
                self.fadedStar.value = surfReport.fadedStar
                self.wind.value = surfReport.wind
                }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
}