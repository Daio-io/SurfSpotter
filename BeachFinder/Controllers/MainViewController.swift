//
//  MainViewController.swift
//  BeachFinder
//
//  Created by Dai Williams on 11/01/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import RxSwift

class MainViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapViewPlaceholder: GMSMapView!
    @IBOutlet weak var distanceSlider: UISlider!
    
    let locationManager = CLLocationManager()
    lazy var service = SurfQueryService()
    let disposeBag = DisposeBag()
    
    var viewModel: HomeViewModel
    
    init() {
        viewModel = HomeViewModel(BeachLocatorService())
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapViewPlaceholder.myLocationEnabled = true
        self.bind()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
    }
    
    // MARK - Internal
    func bind() {
        bindViewModel()
        bindSliderToTextView()
    }
    
    func bindViewModel() {
        
        Observable.combineLatest(viewModel.distance.asObservable(),
                viewModel.currentLocation.asObservable()) { (distance, location) -> (Int, Coordinates)in
                    return (distance, location)
            }.throttle(0.5, scheduler: MainScheduler.instance)
            .subscribeNext { [unowned self] (distance, location) -> Void in
                self.viewModel.scan()
        }.addDisposableTo(disposeBag)
        
        viewModel.locations.asObservable()
            .skipWhile({ (locations) -> Bool in
                return locations.isEmpty
            })
            .subscribeNext {[unowned self] (locations) -> Void in
                
                let viewModels = locations.map({ (beach) -> BeachLocationItemViewModel in
                    return BeachLocationItemViewModel(self.service, beach)
                })
                let co = BeachLocationsViewController(beaches: viewModels)
                
                self.presentViewController(co, animated: true, completion: nil)
            
        }.addDisposableTo(disposeBag)

    }
    
    func bindSliderToTextView() {
        distanceSlider.rx_value.asObservable()
            .startWith(distanceSlider.value)
            .doOnNext({[unowned self] (distance) -> Void in
                self.viewModel.distance.value = Int(distance)
                })
            .map({ (distance) -> String in
                return String("\(distance)m")
            })
            .bindTo(distanceLabel.rx_text)
            .addDisposableTo(disposeBag)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValues:CLLocationCoordinate2D = (manager.location?.coordinate)!
        
        locationManager.stopUpdatingLocation()
        
        let camera = GMSCameraPosition.cameraWithLatitude(locValues.latitude,
            longitude: locValues.longitude, zoom: 8)
        self.mapViewPlaceholder.camera = camera
        
        viewModel.currentLocation.value = Coordinates(locValues.latitude, locValues.longitude)
        viewModel.distance.value = Int(distanceSlider.value)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location error: \(error)")
    }
    
}
