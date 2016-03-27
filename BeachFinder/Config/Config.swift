//
// Created by Dai on 20/03/2016.
// Copyright (c) 2016 daio. All rights reserved.
//

import Foundation

internal class Config {
    
    private static var appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
    
    // API KEYS
    internal static let GoogleMapsApiKey = "_"
    internal static let SurfQueryApiKey = "_"
    internal static let CrashlyticsApiKey = "_"
    
    // URL's
    internal static let GoogleMapsDistanceBaseUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
    internal static let SurfQueryBaseUrl = "https://surf-query.herokuapp.com/next?apikey="
    internal static let BeachLocatorBaseUrl = "https://beach-locator.herokuapp.com/location"
    internal static let RemoteResourcesUrl = "https://cdn.rawgit.com/Daio-io/BeachFinder/master/Resources/"
    
    internal static func AppVersion() -> String {
        if let version = appVersion {
            return version
        }
        return "Unknown"
    }
    
}
