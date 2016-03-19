//
//  AboutViewController.swift
//  BeachFinder
//
//  Created by Dai on 19/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet private weak var webView: UIWebView!
    
    init() {
        super.init(nibName:"AboutViewController", bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLicense()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the NavBar because its not needed - Custom Nav Bar created using UIView
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func loadLicense() {
        if let path = NSBundle.mainBundle().pathForResource("license", ofType: "html") {
            let url = NSURL(string: path)
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }
    
    
}
