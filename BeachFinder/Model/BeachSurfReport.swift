//
//  BeachSurfReport.swift
//  BeachFinder
//
//  Created by Dai Williams on 15/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import SwiftyJSON

internal struct BeachSurfReport {
    let timeStamp : Double
    let date : String
    let time : String
    let wind : Int
    let temp : Int
    let minSwell : Int
    let maxSwell : Int
    let solidStar : Int
    let fadedStar : Int
    
    init(json: JSON) {
        self.timeStamp = json["timestamp"].doubleValue
        self.date = json["date"].stringValue
        self.time = json["time"].stringValue
        self.wind = json["weather"]["wind"].intValue
        self.temp = json["weather"]["temperature"].intValue
        self.minSwell = json["swell"]["minSwell"].intValue
        self.maxSwell = json["swell"]["maxSwell"].intValue
        self.solidStar = json["solidStar"].intValue
        self.fadedStar = json["fadedStar"].intValue
    }
    
}