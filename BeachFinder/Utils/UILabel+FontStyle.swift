//
//  UILabel+FontStyle.swift
//  BeachFinder
//
//  Created by Dai Williams on 27/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

extension UILabel {
    
    var changeToFont : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
}