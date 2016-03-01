//
//  NSDate+Time.swift
//  BeachFinder
//
//  Created by Dai on 01/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import Foundation

extension NSDate {
    
    func currentHour() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        return hour
    }
    
}
