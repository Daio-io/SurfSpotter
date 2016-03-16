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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    
    private let locatorEndpoint = "https://beach-locator.herokuapp.com/status"
    private let surfQueryEndpoint = "https://surf-query.herokuapp.com/status"
    
    init() {
        super.init(nibName: "StartUpViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        delay(1) { [unowned self] () -> () in
            self.loadServices()
        }
        
    }
    
    func loadServices() {
        Observable.combineLatest(StatusPinger.ping(surfQueryEndpoint), StatusPinger.ping(locatorEndpoint)) { [unowned self] (surf, location) -> Void in
            if surf == 200 && location == 200 {
                self.displayMainViewController()
                let navController = self.navigationController
                navController?.setViewControllers([MainViewController()], animated: true)
            }
            }.subscribe().addDisposableTo(disposeBag)
    }

    func displayMainViewController() {
        dismissViewControllerAnimated(true, completion: nil)
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
