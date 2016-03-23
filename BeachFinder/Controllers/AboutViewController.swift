//
//  SettingsViewController.swift
//  BeachFinder
//
//  Created by Dai on 22/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    init() {
        super.init(nibName: "AboutViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func licenseClicked(sender: AnyObject) {
        navigationController?.presentViewController(LicenseViewController(), animated: true, completion: nil)
    }

}
