//
//  BeachFinderLabel.swift
//  BeachFinder
//
//  Created by Dai Williams on 27/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class BeachFinderLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont(name: "Roboto-Regular", size: self.font.pointSize)
    }

}
