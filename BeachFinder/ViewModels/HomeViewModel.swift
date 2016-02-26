//
//  HomeViewModel.swift
//  BeachFinder
//
//  Created by Dai Williams on 24/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel: NSObject {

    private let locatorService: BeachLocationService
    private var subscription: Disposable?
    
    var locations = Variable(Array<BeachLocation>())
    var currentLocation = Variable(Coordinates(0, 0))
    var distance = Variable(0)
    
    init(_ service: BeachLocationService) {
        self.locatorService = service
    }
    
    deinit {
       subscription?.dispose()
    }
    
    func scan() {
        subscription = locatorService.getNearestBeachesForLocation(currentLocation.value, distance: distance.value)
        .subscribeNext { [unowned self] (locations) -> Void in
            self.locations.value = locations
        }
    }
}
