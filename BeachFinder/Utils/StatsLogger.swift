//
//  StatsLogger.swift
//  Surf Spotter
//
//  Created by Dai on 07/04/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Firebase

internal class StatsLogger {

    class func logViewEvent(viewName: String, customLabels: [String : String] = [:]) {
        var labels = customLabels
        labels["screen"] = viewName
        FIRAnalytics.logEventWithName("view", parameters: customLabels)
    }
    
}
