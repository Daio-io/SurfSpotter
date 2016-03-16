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
    @IBOutlet weak var distanceToBeachLabel: BeachFinderLabel!
    
    // Open cell
    @IBOutlet private weak var openDateText: UILabel!
    @IBOutlet private weak var openTimeText: UILabel!
    @IBOutlet private weak var openSwellText: UILabel!
    @IBOutlet private weak var openWindText: UILabel!
    @IBOutlet private weak var mapPlaceholder: GMSMapView!
    
    let disposeBag = DisposeBag()
    
    var viewModel: BeachLocationItemViewModel?
    
    override func awakeFromNib() {
        mapPlaceholder.myLocationEnabled = true
        foregroundView.layer.masksToBounds = true
        backViewColor = UIColor.Teal500()
        
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType) -> NSTimeInterval {
        // durations count equal it itemCount
        let durations = [0.26, 0.2, 0.2]// timing animation for each view
        return durations[itemIndex]
    }
    
    func bind(viewModel: BeachLocationItemViewModel) {
        
        self.viewModel = viewModel
        let swellText = Observable.combineLatest(viewModel.minSwell.asObservable(),
            viewModel.maxSwell.asObservable()) { min, max in
                return String("\(min)-\(max)ft")
        }
        
        swellText.asObservable()
            .startWith(loadingText)
            .bindTo(openSwellText.rx_text)
            .addDisposableTo(disposeBag)
        
        bindWind()
        bindDate()
        bindTime()
        bindLocation()
        bindBeachCoords()
        bindBeachDistance()
    }
    
    // MARK - Internal
    
    private func bindWind() {
        viewModel?.wind.asObservable()
            .map { (wind) -> String in
                return "\(wind)mph"
            }.bindTo(openWindText.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    private func bindDate() {
        viewModel?.date.asObservable()
            .startWith(loadingText)
            .bindTo(openDateText.rx_text)
            .addDisposableTo(disposeBag)
        
    }
    
    private func bindTime() {
        viewModel?.time.asObservable()
            .startWith(loadingText)
            .bindTo(openTimeText.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    private func bindBeachDistance() {
        viewModel?.distanceToBeach.asObservable()
            .map({ (distance) -> String in
                let miles = DistanceConverter.metersToMiles(Float(distance))
                return String(format: "%.1f miles from beach", miles)
            })
            .bindTo(distanceToBeachLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    private func bindBeachCoords() {
        viewModel?.coords.asObservable()
            .subscribeNext { [unowned self] (coords) -> Void in
                self.mapPlaceholder.clear()
                let camera = GMSCameraPosition.cameraWithLatitude(coords.lat,
                    longitude: coords.lon, zoom: 10)
                self.mapPlaceholder.camera = camera
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(coords.lat, coords.lon)
                marker.title = self.viewModel?.location.value
                marker.map = self.mapPlaceholder
            }.addDisposableTo(disposeBag)
    }
    
    private func bindLocation() {
        viewModel?.location.asObservable()
            .startWith(loadingText)
            .bindTo(closedTitle.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    
    @IBAction func getLaterSurfClicked(sender: AnyObject) {
        viewModel?.refresh(NSDate.advanceCurrentTimeBy(3))
    }
    
    @IBAction func navigateToBeachClicked(sender: AnyObject) {
        
        if let model = viewModel {
            print("lets go \(model.coords.value.lat) \(model.coords.value.lon)")
        }
        
    }
}
