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
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var distanceSlider: UISlider!
    @IBOutlet private weak var foundLocationsLabel: UILabel!
    @IBOutlet private weak var viewLocationsButton: UIButton!
    
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
    
    private func bind() {
        bindViewModel()
        bindSliderToTextView()
        bindLocationsLabel()
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
    
    private func bindLocationsLabel() {
        viewModel.locations.asObservable()
            .map({ (locations) -> String in
                return "\(locations.count) Beaches Found"
            })
            .bindTo(foundLocationsLabel.rx_text)
            .addDisposableTo(disposeBag)
        
        
        viewModel.locations.asObservable()
            .map { (locations) -> Bool in
                return !locations.isEmpty
            }.bindTo(viewLocationsButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
    }
    
    private func bindSliderToTextView() {
        distanceSlider.rx_value.asObservable()
            .startWith(distanceSlider.value)
            .doOnNext({[unowned self] (distance) -> Void in
                self.viewModel.distance.value = Int(distance)
                })
            .map({ (distance) -> String in
                return String("Scan Range: \(distance)m")
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
