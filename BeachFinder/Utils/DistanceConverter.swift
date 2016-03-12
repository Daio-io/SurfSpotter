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
    
    static func metersToMiles(meters: Float) -> Float {
        return meters / metersInAMile
    }
    
}