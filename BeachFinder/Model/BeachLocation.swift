//
// Created by Dai Williams on 27/01/2016.
// Copyright (c) 2016 daio. All rights reserved.
//

import SwiftyJSON

public typealias Coordinates = (lat: Double, lon: Double)

public struct BeachLocation {
    let location: String
    let spotId: Int
    let country: String
    let coords: Coordinates
    
    init(json: JSON) {
        self.location = json["location"].stringValue
        self.spotId = json["spotId"].intValue
        self.country = json["country"].stringValue
        
        let lat = json["coords"]["lat"].doubleValue
        let lon = json["coords"]["long"].doubleValue
        self.coords = Coordinates(lat, lon)
    }
}