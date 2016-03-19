//
//  BeachSwellStarsView.swift
//  BeachFinder
//
//  Created by Dai on 18/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class BeachSwellStarsView: UIView {
    
    func addSolidStars(solidStars: Int, fadedStars: Int) {
        
        guard solidStars <= 5 else {
            return
        }
        
        for i in 0 ..< solidStars {
            subviews[i].alpha = 1
        }
        
        for i in 0 ..< fadedStars {
            subviews[solidStars + i].alpha = 0.6
        }
        
    }
    
}
