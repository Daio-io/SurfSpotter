//
//  CurrentLocationResult.swift
//  BeachFinder
//
//  Created by Dai on 25/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

internal enum CurrentLocationResult {
    case Success(coords: Coordinates)
    case Failed(message: String)
}