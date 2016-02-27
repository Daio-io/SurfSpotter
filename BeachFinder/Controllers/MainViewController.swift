//
//  MainViewController.swift
//  BeachFinder
//
//  Created by Dai Williams on 11/01/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var foundLocationsLabel: UILabel!
    @IBOutlet weak var viewLocationsButton: UIButton!
    
    lazy var service = SurfQueryService()
    let disposeBag = DisposeBag()
    
    var viewModel: HomeViewModel
    
    init() {
        viewModel = HomeViewModel(BeachLocatorService(), CurrentLocationService())
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.locateMe()
    }
    
    // MARK - Internal
    
    func bind() {
        bindViewModel()
        bindSliderToTextView()
        bindLocationsLabel()
    }
    
    func bindViewModel() {
        
        Observable.combineLatest(viewModel.distance.asObservable(),
            viewModel.currentLocation.asObservable()) { (distance, location) -> (Int, Coordinates)in
                return (distance, location)
            }.throttle(0.5, scheduler: MainScheduler.instance)
            .subscribeNext { [unowned self] (distance, location) -> Void in
                self.viewModel.scan()
            }.addDisposableTo(disposeBag)
        
    }
    
    func bindLocationsLabel() {
        viewModel.locations.asObservable()
            .map({ (locations) -> String in
                return "\(locations.count) Beaches found"
            })
            .bindTo(foundLocationsLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        
        viewModel.locations.asObservable()
            .map { (locations) -> Bool in
                return !locations.isEmpty
            }.bindTo(viewLocationsButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
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
    
    
    
    @IBAction func viewLocations(sender: AnyObject) {
        let viewModels = viewModel.locations.value.map({ (beach) -> BeachLocationItemViewModel in
            return BeachLocationItemViewModel(self.service, beach)
        })
        let co = BeachLocationsViewController(beaches: viewModels)
        
        navigationController?.pushViewController(co, animated: true)
    }
}
