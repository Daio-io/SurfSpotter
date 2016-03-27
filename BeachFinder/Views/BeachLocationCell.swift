//
//  BeachLocationCell.swift
//  BeachFinder
//
//  Created by Dai Williams on 10/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit
import FoldingCell
import RxSwift
import RxCocoa
import MapKit

class BeachLocationCell : FoldingCell {
    
    // Closed cell
    @IBOutlet private weak var closedTitle: UILabel!
    @IBOutlet private weak var distanceToBeachLabel: BeachFinderLabel!
    @IBOutlet private weak var favouriteButton: FavouriteButton!
    
    // Open cell
    @IBOutlet private weak var mapPlaceholder: UIView!
    @IBOutlet private weak var openTitle: UILabel!
    @IBOutlet private weak var openTimeText: UILabel!
    @IBOutlet private weak var openSwellText: UILabel!
    @IBOutlet private weak var openWindText: UILabel!
    @IBOutlet private weak var openSwellStarsView: BeachSwellStarsView!
    private var map: BeachFinderMap?
    
    private let disposeBag = DisposeBag()
    
    private var mapSubscription: Disposable?
    private var viewModel: BeachLocationItemViewModel?
    
    override func awakeFromNib() {
        foregroundView.layer.masksToBounds = true
        foregroundView.layer.cornerRadius = 8
        closedTitle.changeToFont = "Roboto-Medium"
        openTitle.changeToFont = "Roboto-Medium"
        backViewColor = UIColor.Teal500()
        
        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType) -> NSTimeInterval {
        // durations count equal it itemCount
        let durations = [0.26, 0.2, 0.2, 0.2]// timing animation for each view
        return durations[itemIndex]
    }
    
    func bind(viewModel: BeachLocationItemViewModel, viewBinder: LocationCellBinder) {
        
        self.viewModel = viewModel
        
        viewBinder.bindBeachDistance(viewModel, distanceToBeachLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindLocation(viewModel, closedTitle.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindLocation(viewModel, openTitle.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindStars(viewModel, openSwellStarsView)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindWind(viewModel, openWindText.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindTime(viewModel, openTimeText.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindSwell(viewModel, openSwellText.rx_text)
            .addDisposableTo(disposeBag)
        
        viewModel.isFavourited.asObservable()
            .doOnNext { [unowned self] (fav) in
            self.favouriteButton.favourite = fav
        }.subscribe().addDisposableTo(disposeBag)
        
    }
    
    func removeMap(){
        map?.removeFromSuperview()
        mapSubscription?.dispose()
    }
    
    func showMap() {
        map = BeachFinderMap(frame: mapPlaceholder.bounds)
        bindBeachCoords(viewModel)
        mapPlaceholder.addSubview(map!)
        UIView.animateWithDuration(0.5) {
            self.map?.alpha = 1
        }
    }
    
    private func bindBeachCoords(viewModel: BeachLocationItemViewModel?) {
        
        guard let viewModel = viewModel else {
            return
        }
        
        mapSubscription = viewModel.coords.asObservable()
            .subscribeNext { [unowned self] (coords) -> Void in
                if let map = self.map {
                    map.addPin(viewModel.location.value, coords: coords)
                }
                
        }
    }
    
    private func openInMaps() {
        
        guard let viewModel = viewModel  else {
            return
        }
        
        let coords = CLLocationCoordinate2D(latitude: viewModel.coords.value.lat, longitude: viewModel.coords.value.lon)
        
        let placemark = MKPlacemark(coordinate: coords, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = viewModel.location.value
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    @IBAction func favClicked(sender: AnyObject) {
        viewModel?.favourite()
    }
    
    @IBAction func navigateClicked(sender: AnyObject) {
        openInMaps()
    }
    
}
