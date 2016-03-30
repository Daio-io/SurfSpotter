//
//  FavouriteButton.swift
//  Surf Finder
//
//  Created by Dai on 27/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class FavouriteButton: UIButton {
    
    private var isFavourited: Bool
    
    required init?(coder aDecoder: NSCoder) {
        isFavourited = false
        super.init(coder: aDecoder)
    }
    
    var favourite: Bool {
        get {
            return isFavourited
        }
        set(favourited) {
            if favourited == true {
                self.animateChangeToImage("minus")
            } else {
                self.animateChangeToImage("plus")
            }
            isFavourited = favourited
        }
    }
    
    private func animateChangeToImage(named: String) {
        UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: {
            self.setImage(UIImage(named: named), forState: .Normal)
            }, completion: nil)
        
    }

}
