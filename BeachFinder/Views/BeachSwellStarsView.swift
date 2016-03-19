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
        
        guard solidStars > 0 && solidStars <= 5 else {
            return
        }
        
        arrangeSolidStars(solidStars)
        arrangeFadedStars(fadedStars, solidStars: solidStars)
        
    }
    
    private func arrangeSolidStars(solidStars: Int) {
        for i in 0 ..< solidStars {
            if let star = subviews[i] as? UIImageView {
                star.highlighted = true
                // star default alpha is 0.5 so show a solid 1
                star.alpha = 1
            }
            
        }
    }
    
    private func arrangeFadedStars(fadedStars: Int, solidStars: Int) {
        for i in 0 ..< fadedStars {
            if let star = subviews[solidStars + i] as? UIImageView {
                star.highlighted = true
            }
        }
    }
    
}
