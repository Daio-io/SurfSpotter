//
//  BeachSurfReport.swift
//  BeachFinder
//
//  Created by Dai Williams on 15/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation
import SwiftyJSON

internal struct BeachSurfReport {
    let timeStamp : Double
    let date : String
    let time : String
    let wind : Int
    let minSwell : Int
    let maxSwell : Int
    let solidStar : Int
    let fadedStar : Int
    
    init(json: JSON) {
        self.timeStamp = json["timestamp"].doubleValue
        self.date = json["date"].stringValue
        self.time = json["time"].stringValue
        self.wind = json["wind"].intValue
        self.minSwell = json["minSwell"].intValue
        self.maxSwell = json["maxSwell"].intValue
        self.solidStar = json["solidStar"].intValue
        self.fadedStar = json["fadedStar"].intValue
    }
    
}