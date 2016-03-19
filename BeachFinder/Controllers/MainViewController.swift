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
        setUpMap()
        bind()
    }
    
    override func viewDidAppear(animated: Bool) {
        viewModel.locateMe()
    }
    
    // MARK - Internal
    
    private func setUpMap() {
        mainMapView.myLocationEnabled = true
        viewModel.currentLocation.asObservable()
        .subscribeNext { [unowned self] (lat, lon) -> Void in
            self.mainMapView.camera = GMSCameraPosition.cameraWithLatitude(lat,
                longitude: lon, zoom: 8
            )
        }.addDisposableTo(disposeBag)
        
        viewModel.locations.asObservable()
            .subscribeNext { [unowned self] (locations) -> Void in
                self.mainMapView.clear()
                for location in locations {
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2DMake(location.coords.lat, location.coords.lon)
                    marker.title = location.location
                    marker.map = self.mainMapView
                }
        }.addDisposableTo(disposeBag)
    }
    
    private func bind() {
        bindViewModel()
        bindSliderToTextView()
        bindCityAddressToLabel()
    }
    
    private func bindViewModel() {
        
        Observable.combineLatest(viewModel.distance.asObservable(),
            viewModel.currentLocation.asObservable()) { (distance, location) -> (Int, Coordinates)in
                return (distance, location)
            }.throttle(0.5, scheduler: MainScheduler.instance)
            .subscribeNext { [unowned self] (distance, location) -> Void in
                self.viewModel.scan()
            }.addDisposableTo(disposeBag)
        
        viewModel.locations.asObservable()
            .map { (locations) -> Bool in
                return  !locations.isEmpty
            }.bindTo(viewBeachesButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
    }
    
    private func bindSliderToTextView() {
        distanceSlider.rx_value.asObservable()
            .startWith(distanceSlider.value)
            .doOnNext({[unowned self] (distance) -> Void in
                let meters = DistanceConverter.milesToMeters(distance)
                self.viewModel.distance.value = Int(meters)
                })
            .map({ (distance) -> String in
                return String(format: "%.1f mile radius", distance)
            })
            .bindTo(distanceLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    private func bindCityAddressToLabel() {
        viewModel.currentCity.asObservable()
            .bindTo(currentCityLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func viewLocations(sender: AnyObject) {
        let viewModels = viewModel.locations.value.map({ [unowned self] (beach) -> BeachLocationItemViewModel in
            return BeachLocationItemViewModel(self.service, self.locationService, beach)
        })
        let co = BeachLocationsViewController(beaches: viewModels)
        
        navigationController?.pushViewController(co, animated: true)
    }
}
