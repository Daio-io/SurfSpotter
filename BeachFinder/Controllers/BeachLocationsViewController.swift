//
//  BeachLocationsViewController.swift
//  BeachFinder
//
//  Created by Dai Williams on 10/02/2016.
//  Copyright © 2016 daio. All rights reserved.
//

import UIKit

class BeachLocationsViewController: UITableViewController {
        
    // Constants for should be equal to or greater than
    // the cell forgroundview height
    private let kCloseCellHeight: CGFloat = 97
    private let kOpenCellHeight: CGFloat = 420
    internal var beaches : [BeachLocationItemViewModel]
    
    private var cellViewBinder: LocationCellBinder
    
    private let beachCellIdentifier = "BeachLocationCell"
    
    private var cellHeights = [CGFloat]()
    
    init(beaches: [BeachLocationItemViewModel] = [],
         cellViewBinder: LocationCellBinder = BeachViewModelBinder(),
         title: String = "Spots") {
        self.beaches = beaches
        self.cellViewBinder = cellViewBinder
        super.init(nibName: "BeachLocationsViewController", bundle: nil)
        self.title = title
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        self.beaches = []
        self.cellViewBinder = BeachViewModelBinder()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: beachCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: beachCellIdentifier)
        
        for _ in 0...beaches.count {
            cellHeights.append(kCloseCellHeight)
        }
        // Navigation controller needed in this view so show it again
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Register for foreground event to refresh data
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(refreshData), name:
            UIApplicationWillEnterForegroundNotification, object: nil)
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        StatsLogger.logViewEvent("Spots")
    }
    
    // MARK - Internal
    
    func refreshData() {
        for beach in beaches {
            beach.refresh()
        }
    }
    
    // MARK - UITableViewDelegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beaches.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! BeachLocationCell
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: {
                cell.showMap()
            })
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: {
                cell.removeMap()
            })
            duration = 1.1
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(beachCellIdentifier, forIndexPath: indexPath) as! BeachLocationCell
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? BeachLocationCell where cellHeights[indexPath.row] > kCloseCellHeight {
            cell.removeMap()
        }
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let beachCell = cell as? BeachLocationCell {
            let currentBeach = beaches[indexPath.row]
            beachCell.bind(currentBeach, viewBinder: cellViewBinder)
            
            if cellHeights[indexPath.row] == kCloseCellHeight {
                beachCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                beachCell.selectedAnimation(true, animated: false, completion: nil)
                beachCell.showMap()
            }
        }
    }

}
