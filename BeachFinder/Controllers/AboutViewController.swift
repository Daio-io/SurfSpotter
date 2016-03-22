//
//  AboutViewController.swift
//  BeachFinder
//
//  Created by Dai on 19/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet private weak var webView: UIWebView!
    
    init() {
        super.init(nibName:"AboutViewController", bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.scalesPageToFit = true
        loadLicense()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func loadLicense() {
        if let path = NSBundle.mainBundle().pathForResource("license", ofType: "html") {
            let url = NSURL(string: path)
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
    }
    
    @IBAction func dismissClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK - UIWebViewDelegate
    
    // Ensure links in the webview are opened in Safari
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
    
}
