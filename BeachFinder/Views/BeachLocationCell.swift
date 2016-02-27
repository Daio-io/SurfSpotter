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
    
    let loadingText = "Loading"
    // Closed cell
    @IBOutlet private weak var closedTitle: UILabel!
    
    // Open cell
    @IBOutlet private weak var openDateText: UILabel!
    @IBOutlet private weak var openTimeText: UILabel!
    @IBOutlet private weak var openSwellText: UILabel!
    @IBOutlet private weak var openWindText: UILabel!
    @IBOutlet private weak var mapPlaceholder: GMSMapView!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        mapPlaceholder.myLocationEnabled = true
        foregroundView.layer.masksToBounds = true
        foregroundView.layer.cornerRadius = 8
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        // durations count equal it itemCount
        let durations = [0.26, 0.2, 0.2]// timing animation for each view
        return durations[itemIndex]
    }
    
    func bind(viewModel: BeachLocationItemViewModel) {
        
        let swellText = Observable.combineLatest(viewModel.minSwell.asObservable(),
            viewModel.maxSwell.asObservable()) { min, max in
            return String("Swell: \(min)-\(max)ft")
        }
        
        swellText.asObservable()
            .startWith(loadingText)
            .bindTo(openSwellText.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.wind.asObservable()
            .map { (wind) -> String in
            return "Wind: \(wind)mph"
        }.bindTo(openWindText.rx_text)
        .addDisposableTo(disposeBag)
        
        viewModel.date.asObservable()
            .startWith(loadingText)
            .bindTo(openDateText.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.time.asObservable()
            .startWith(loadingText)
            .bindTo(openTimeText.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.location.asObservable()
            .startWith(loadingText)
            .bindTo(closedTitle.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.coords.asObservable()
            .subscribeNext { [unowned self] (coords) -> Void in
                self.mapPlaceholder.clear()
                let camera = GMSCameraPosition.cameraWithLatitude(coords.lat,
                    longitude: coords.lon, zoom: 10)
                self.mapPlaceholder.camera = camera
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(coords.lat, coords.lon)
                marker.title = viewModel.location.value
                marker.map = self.mapPlaceholder
        }.addDisposableTo(disposeBag)
        
    }

}
