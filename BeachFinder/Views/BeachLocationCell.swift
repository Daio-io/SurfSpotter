//
//  BeachLocationCell.swift
//  BeachFinder
//
//  Created by Dai Williams on 10/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit
import FoldingCell
import GoogleMaps
import RxSwift
import RxCocoa

class BeachLocationCell : FoldingCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var closedTitle: UILabel!
    @IBOutlet private weak var mapPlaceholder: GMSMapView!
    
    override func awakeFromNib() {
        self.mapPlaceholder.myLocationEnabled = true
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
    
    func bind(viewModel: BeachLocationItemViewModel) {
        
        let swellText = Observable.combineLatest(viewModel.minSwell.asObservable(), viewModel.maxSwell.asObservable()) {min, max in
            return String("Swell: \(min)-\(max)ft")
        }
        
        let _ = swellText.bindTo(titleLabel.rx_text)
        let _ = viewModel.location.asObservable().bindTo(closedTitle.rx_text)
        
        let _ = viewModel.coords.asObservable()
            .subscribeNext { [unowned self] (coords) -> Void in
                self.mapPlaceholder.clear()
                let camera = GMSCameraPosition.cameraWithLatitude(coords.lat,
                    longitude: coords.lon, zoom: 10)
                self.mapPlaceholder.camera = camera
                
                let marker = GMSMarker()
                
                marker.position = CLLocationCoordinate2DMake(coords.lat, coords.lon)
                
                marker.title = viewModel.location.value
                marker.map = self.mapPlaceholder
        }
        
    }
    
}
