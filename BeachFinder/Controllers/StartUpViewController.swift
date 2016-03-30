//
//  StartUpViewController.swift
//  BeachFinder
//
//  Created by Dai on 14/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit
import RxSwift

class StartUpViewController: UIViewController {
    
    @IBOutlet weak var startingText: BeachFinderLabel!
    
    private let disposeBag = DisposeBag()
    private let locatorEndpoint = "https://beach-locator.herokuapp.com/status"
    private let surfQueryEndpoint = "https://surf-query.herokuapp.com/status"
    private let NotFirstRunKey = "NotFirstRun"
    
    private lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    
    init() {
        super.init(nibName: "StartUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        startingText.changeToFont = "Roboto-Medium"
    }
    
    override func viewDidAppear(animated: Bool) {
        delay(0.5) { [unowned self] () -> () in
            self.loadServices()
        }
    }
    
    func loadServices() {
        Observable.combineLatest(StatusPinger.ping(surfQueryEndpoint), StatusPinger.ping(locatorEndpoint)) { [unowned self] (surf, location) -> Void in
            if surf == 200 && location == 200 {
                self.displayMainViewController()
            }
            }.doOnError({ [unowned self] (_) in
                self.startingText.text = "Something is up. Check your network"
            }) .retry().subscribe().addDisposableTo(disposeBag)
    }

    func displayMainViewController() {
        
        if userDefaults.boolForKey(NotFirstRunKey) {
            let viewModel = ViewModelFactory.homeViewModel()
            let mainController = MainViewController(viewModel: viewModel, viewBinder: HomeViewModelBinder())
            navigationController?.setViewControllers([mainController], animated: true)
        } else {
            userDefaults.setObject(true, forKey: NotFirstRunKey)
            navigationController?.setViewControllers([OnBoardingViewController()], animated: true)
        }

    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
