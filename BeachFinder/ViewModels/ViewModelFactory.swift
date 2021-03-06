//
//  ViewModelFactory.swift
//  BeachFinder
//
//  Created by Dai on 20/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

class ViewModelFactory {
    
    private static let currentLocationService = CurrentLocationService(distanceFinder: DistanceFinder())
    private static let surfReportService = SurfQueryService(apiKey: Config.SurfQueryApiKey, baseUrl: Config.SurfQueryBaseUrl)
    private static let beachLocationService = BeachLocatorService(baseUrl: Config.BeachLocatorBaseUrl)
    
    static func homeViewModel() -> HomeViewModel {
        return HomeViewModel(beachLocationService, currentLocationService)
    }
    
    static func beachLocationItemViewModel(beachLocation: BeachLocation) -> BeachLocationItemViewModel {
        return BeachLocationItemViewModel(surfReportService, currentLocationService, beachLocation, MyBeachesService.sharedInstance)
    }
    
}