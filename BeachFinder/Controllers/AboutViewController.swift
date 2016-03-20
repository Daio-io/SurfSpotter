//
//  AboutViewController.swift
//  BeachFinder
//
//  Created by Dai on 19/03/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

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
        webView.scrollView.delegate = self
        webView.scalesPageToFit = true
        loadLicense()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide the NavBar because its not needed - Custom Nav Bar created using UIView
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        navigationItem.title = "About"
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBar.tintColor = UIColor.FadedOrange()
    }
    
    func loadLicense() {
        if let path = NSBundle.mainBundle().pathForResource("license", ofType: "html") {
            let url = NSURL(string: path)
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
        }
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
    
    // MARK - UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        let transition = webView.scrollView.panGestureRecognizer.translationInView(webView)
        
        // Hiding nav bar when dragging down
        if (transition.y > 0) {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        // Show again when starting to drag up
        else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
}
