//
//  StatsLogger.swift
//  Surf Spotter
//
//  Created by Dai on 07/04/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Crashlytics

internal class StatsLogger {

    class func logViewEvent(viewName: String?, contentId: String?, customLabels: [String : AnyObject]?) {
        Answers.logContentViewWithName(viewName, contentType: "ViewController",
                                       contentId: contentId,
                                       customAttributes: customLabels)
    }
    
    class func logClickEvent(name: String, currentDisplay: String = "unknown") {
        Answers.logCustomEventWithName(name, customAttributes: ["display": currentDisplay])
    }
    
}
