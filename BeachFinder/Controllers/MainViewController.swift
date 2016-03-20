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
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: HomeViewModel
    private var viewBinder: MainViewBinder
    
    init(viewModel: HomeViewModel, viewBinder: MainViewBinder) {
        self.viewModel = viewModel
        self.viewBinder = viewBinder
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
        
        viewBinder.bindToBeachScan(viewModel)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindToCurrentCity(viewModel, observer: currentCityLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindToLocationFound(viewModel, observer: viewBeachesButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindToScanDistanceChange(viewModel, slider: distanceSlider, observer: distanceLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindLocationToMap(viewModel, mapView: mainMapView)
            .addDisposableTo(disposeBag)
        
        viewBinder.bindLocationsFoundToMap(viewModel, mapView: mainMapView)
            .addDisposableTo(disposeBag)
        
        viewModel.currentLocation.asObservable()
            .subscribeError { (error) -> Void in
                print("Todo - handle error here when location unavialble")
            }.addDisposableTo(disposeBag)
    }

    @IBAction func viewLocations(sender: AnyObject) {
        let viewModels = viewModel.locations.value.map({ (beach) -> BeachLocationItemViewModel in
            return ViewModelFactory.beachLocationItemViewModel(beach)
        })
        let co = BeachLocationsViewController(beaches: viewModels)
        
        navigationController?.pushViewController(co, animated: true)
    }
    
    @IBAction func settingsClicked(sender: AnyObject) {
        navigationController?.pushViewController(AboutViewController(), animated: true)
    }
}
