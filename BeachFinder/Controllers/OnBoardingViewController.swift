//
//  OnBoardingViewController.swift
//  Surf Spotter
//
//  Created by Dai on 30/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    init() {
        super.init(nibName: "OnBoardingViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func okButtonClicked(sender: AnyObject) {
        let viewModel = ViewModelFactory.homeViewModel()
        let mainController = MainViewController(viewModel: viewModel, viewBinder: HomeViewModelBinder())
        navigationController?.setViewControllers([mainController], animated: true)
    }
}
