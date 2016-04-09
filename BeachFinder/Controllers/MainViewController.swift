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
    @IBOutlet private weak var mainMapView: BeachFinderMap!
    @IBOutlet private weak var currentCityLabel: BeachFinderLabel!
    @IBOutlet private weak var viewBeachesButton: BeachFinderButton!
    @IBOutlet private weak var errorButton: UIButton!
    @IBOutlet private weak var beachCountLabel: BeachFinderLabel!
    
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
        super.viewWillAppear(animated)
        // Hide the NavBar because its not needed - Custom Nav Bar created using UIView
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel.locateMe()
        StatsLogger.logViewEvent("Home", contentId: nil, customLabels: nil)
    }
    
    // MARK - Internal
    
    private func bindViewsToViewModel() {
        mainMapView.myLocationEnabled = true
        
        viewModel.locations.asObservable()
            .map { (locations) -> String in
            return "\(locations.count) Spots"
        }.bindTo(beachCountLabel.rx_text)
            .addDisposableTo(disposeBag)
        
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
        
        viewBinder.bindShowingErrorForLocation(viewModel, observer: errorButton.rx_hidden)
            .addDisposableTo(disposeBag)
        
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
    
    @IBAction func myBeachesClicked(sender: AnyObject) {
        let myBeachesService = MyBeachesService.sharedInstance
        
        guard let beaches = myBeachesService.getBeaches() else {
            navigationController?.pushViewController(MyBeachesViewController(), animated: true)
            return
        }
        
        let viewModels = beaches.map({ (beach) -> BeachLocationItemViewModel in
            return ViewModelFactory.beachLocationItemViewModel(beach)
        })
        
        navigationController?.pushViewController(MyBeachesViewController(beaches: viewModels), animated: true)
    }
    
    @IBAction func errorButtonClicked(sender: AnyObject) {
        let alertController = UIAlertController(title: "Location Error", message:
            "There seems to be a problem locating you. Check your location services is turned on and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {[unowned self] (_) in
            self.viewModel.locateMe()
        }))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
