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
    
    // Closed cell
    @IBOutlet private weak var closedTitle: UILabel!
    @IBOutlet private weak var distanceToBeachLabel: BeachFinderLabel!
    @IBOutlet private weak var closedSwellText: BeachFinderLabel!
    
    // Open cell
    @IBOutlet private weak var openDateText: UILabel!
    @IBOutlet private weak var openTimeText: UILabel!
    @IBOutlet private weak var openSwellText: UILabel!
    @IBOutlet private weak var openWindText: UILabel!
    @IBOutlet private weak var mapPlaceholder: GMSMapView!
    @IBOutlet private weak var openSwellStarsView: BeachSwellStarsView!
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        mapPlaceholder.myLocationEnabled = true
        foregroundView.layer.masksToBounds = true
        foregroundView.layer.cornerRadius = 8
        closedTitle.changeToFont = "Roboto-Medium"
        backViewColor = UIColor.Teal500()
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType) -> NSTimeInterval {
        // durations count equal it itemCount
        let durations = [0.26, 0.2, 0.2, 0.2]// timing animation for each view
        return durations[itemIndex]
    }
    
    func bind(viewModel: BeachLocationItemViewModel, viewBinder: LocationCellBinder) {
    
        viewBinder.bindBeachDistance(viewModel, distanceToBeachLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindDate(viewModel, openDateText.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindLocation(viewModel, closedTitle.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindStars(viewModel, openSwellStarsView)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindWind(viewModel, openWindText.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindTime(viewModel, openTimeText.rx_text).addDisposableTo(disposeBag)
        
        bindBeachCoords(viewModel)
        bindSwellText(viewModel)
    }
    
    // MARK - Internal
   
    private func bindSwellText(viewModel: BeachLocationItemViewModel) {
        let swellText = Observable.combineLatest(viewModel.minSwell.asObservable(),
            viewModel.maxSwell.asObservable()) { min, max in
                return String("\(min)-\(max)ft")
        }
        
        swellText.asObservable()
            .bindTo(openSwellText.rx_text)
            .addDisposableTo(disposeBag)
        
        swellText.asObservable()
            .bindTo(closedSwellText.rx_text)
            .addDisposableTo(disposeBag)
        
    }
    
    private func bindBeachCoords(viewModel: BeachLocationItemViewModel) {
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
