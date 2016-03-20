//
//  MainViewController.swift
//  BeachFinder
//
//  Created by Dai Williams on 11/01/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps

class MainViewController: UIViewController {
    
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var distanceSlider: UISlider!
    @IBOutlet private weak var mainMapView: GMSMapView!
    @IBOutlet private weak var currentCityLabel: BeachFinderLabel!
    @IBOutlet private weak var viewBeachesButton: BeachFinderButton!
    
    private lazy var service = SurfQueryService()
    private let locationService = CurrentLocationService()
    private let disposeBag = DisposeBag()
    
    private var viewModel: HomeViewModel
    
    init() {
        viewModel = HomeViewModel(BeachLocatorService(), locationService)
        super.init(nibName:"MainViewController", bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewsToViewModel()
    }

    override func viewWillAppear(animated: Bool) {
        // Hide the NavBar because its not needed - Custom Nav Bar created using UIView
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.locateMe()
    }
    
    // MARK - Internal
    
    private func bindViewsToViewModel() {
        mainMapView.myLocationEnabled = true
        let binder = HomeViewModelBinder()
        
        binder.bindToBeachScan(viewModel)
            .addDisposableTo(disposeBag)
        
        binder.bindToCurrentCity(viewModel, observer: currentCityLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        binder.bindToLocationFound(viewModel, observer: viewBeachesButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
        binder.bindToScanDistanceChange(viewModel, slider: distanceSlider, observer: distanceLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        binder.bindLocationToMap(viewModel, mapView: mainMapView)
            .addDisposableTo(disposeBag)
        
        binder.bindLocationsFoundToMap(viewModel, mapView: mainMapView)
            .addDisposableTo(disposeBag)
        
        viewModel.currentLocation.asObservable()
            .subscribeError { (error) -> Void in
                print("Todo - handle error here when location unavialble")
            }.addDisposableTo(disposeBag)
    }

    @IBAction func viewLocations(sender: AnyObject) {
        let viewModels = viewModel.locations.value.map({ [unowned self] (beach) -> BeachLocationItemViewModel in
            return BeachLocationItemViewModel(self.service, self.locationService, beach)
        })
        let co = BeachLocationsViewController(beaches: viewModels)
        
        navigationController?.pushViewController(co, animated: true)
    }
    
    @IBAction func settingsClicked(sender: AnyObject) {
        navigationController?.pushViewController(AboutViewController(), animated: true)
    }
}
