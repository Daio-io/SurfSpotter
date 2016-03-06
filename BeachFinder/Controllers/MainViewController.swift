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
    
    private lazy var service = SurfQueryService()
    private let disposeBag = DisposeBag()
    
    private var viewModel: HomeViewModel
    
    init() {
        viewModel = HomeViewModel(BeachLocatorService(), CurrentLocationService())
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
        bind()
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        viewModel.locateMe()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK - Internal
    
    private func setUpMap() {
        mainMapView.myLocationEnabled = true
        viewModel.currentLocation.asObservable()
        .subscribeNext { [unowned self] (lat, lon) -> Void in
            self.mainMapView.camera = GMSCameraPosition.cameraWithLatitude(lat,
                longitude: lon, zoom: 10)
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
        
    }
    
    private func bindSliderToTextView() {
        distanceSlider.rx_value.asObservable()
            .startWith(distanceSlider.value)
            .doOnNext({[unowned self] (distance) -> Void in
                self.viewModel.distance.value = Int(distance)
                })
            .map({ (distance) -> String in
                return String("\(distance) meters")
            })
            .bindTo(distanceLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    private func bindCityAddressToLabel() {
        viewModel.currentCity.asObservable()
            .map({ (city) -> String in
                return "Current Location: \(city)"
            })
            .bindTo(currentCityLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    
    
    @IBAction func viewLocations(sender: AnyObject) {
        let viewModels = viewModel.locations.value.map({ [unowned self] (beach) -> BeachLocationItemViewModel in
            return BeachLocationItemViewModel(self.service, beach)
        })
        let co = BeachLocationsViewController(beaches: viewModels)
        
        navigationController?.pushViewController(co, animated: true)
    }
}
