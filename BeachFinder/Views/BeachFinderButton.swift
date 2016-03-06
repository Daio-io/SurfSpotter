//
//  BeachFinderButton.swift
//  BeachFinder
//
//  Created by Dai on 06/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class BeachFinderButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let title = titleLabel {
            title.font = UIFont(name: "Roboto-Medium", size: title.font!.pointSize)
        }
    }
    
}