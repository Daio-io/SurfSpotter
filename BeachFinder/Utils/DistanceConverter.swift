//
//  DistanceConverter.swift
//  BeachFinder
//
//  Created by Dai on 11/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation

class DistanceConverter {
    
    private static let metersInAMile: Float = 1609.3
    private static let milesInAMeter: Float = 0.000621371192
    
    static func metersToMiles(meters: Float) -> Float {
        return meters / metersInAMile
    }
    
    static func milesToMeters(miles: Float) -> Float {
        return miles / milesInAMeter
    }
}