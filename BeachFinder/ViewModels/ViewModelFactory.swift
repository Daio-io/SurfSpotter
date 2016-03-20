//
//  ViewModelFactory.swift
//  BeachFinder
//
//  Created by Dai on 20/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation

class ViewModelFactory {
    
    private static let currentLocationService = CurrentLocationService()
    private static let surfReportService = SurfQueryService()
    private static let beachLocationService = BeachLocatorService()
    
    static func homeViewModel() -> HomeViewModel {
        return HomeViewModel(beachLocationService, currentLocationService)
    }
    
    static func beachLocationItemViewModel(beachLocation: BeachLocation) -> BeachLocationItemViewModel {
        return BeachLocationItemViewModel(surfReportService, currentLocationService, beachLocation)
    }
    
}