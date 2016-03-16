//
//  NSDate+Time.swift
//  BeachFinder
//
//  Created by Dai on 01/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation

extension NSDate {
    
    static func currentHour() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: NSDate())
        return components.hour
    }
    
    static func advanceCurrentTimeBy(hours: Int) -> Int {
        let advanceTime = currentHour() + hours
        return advanceTime >= 24 ? advanceTime - 23 : advanceTime
    }
    
}
