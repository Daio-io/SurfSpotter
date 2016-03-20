//
//  UIColor+Material.swift
//  BeachFinder
//
//  Created by Dai Williams on 27/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

// Lazy load colors
private var blue600 = UIColor(colorLiteralRed: 0.118, green: 0.533, blue: 0.898, alpha: 1)
private var amber500 = UIColor(colorLiteralRed: 1, green: 0.757, blue: 0.027, alpha: 1)
private var blueGrey50 = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1)
private var faddedOrange = UIColor(red:0.86, green:0.46, blue:0.38, alpha:1.0)
private var teal500 = UIColor(red:0.00, green:0.59, blue:0.53, alpha:1.0)

extension UIColor {
    
    static func Blue600() -> UIColor {
        return blue600
    }
    
    static func Amber500() -> UIColor {
        return amber500
    }
    
    static func BlueGrey50() -> UIColor {
        return blueGrey50
    }
    
    static func FadedOrange() -> UIColor {
        return faddedOrange
    }
    
    static func Teal500() -> UIColor {
        return teal500
    }
}
