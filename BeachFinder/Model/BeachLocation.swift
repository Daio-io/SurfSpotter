//
// Created by Dai Williams on 27/01/2016.
// Copyright (c) 2016 daio. All rights reserved.
//

public typealias Coordinates = (lat: Double, lon: Double)

public struct BeachLocation {
    let location: String
    let spotId: Int
    let country: String
    let coords: Coordinates
}