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
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var startingText: BeachFinderLabel!
    
    private let locatorEndpoint = "https://beach-locator.herokuapp.com/status"
    private let surfQueryEndpoint = "https://surf-query.herokuapp.com/status"
    
    init() {
        super.init(nibName: "StartUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
            }.retry().subscribe().addDisposableTo(disposeBag)
    }

    func displayMainViewController() {
        let navController = self.navigationController
        let viewModel = ViewModelFactory.homeViewModel()
        let mainController = MainViewController(viewModel: viewModel, viewBinder: HomeViewModelBinder())
        navController?.setViewControllers([mainController], animated: true)
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
