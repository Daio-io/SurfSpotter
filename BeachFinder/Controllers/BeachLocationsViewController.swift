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
    let kCloseCellHeight: CGFloat = 97
    let kOpenCellHeight: CGFloat = 420
    var beaches : [BeachLocationItemViewModel]
    
    let beachCellIdentifier = "BeachLocationCell"
    
    var cellHeights = [CGFloat]()
    
    init(beaches: [BeachLocationItemViewModel]) {
        self.beaches = beaches
        super.init(nibName: "BeachLocationsViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: beachCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: beachCellIdentifier)
        
        for _ in 0...beaches.count {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beaches.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! BeachLocationCell
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(beachCellIdentifier, forIndexPath: indexPath) as! BeachLocationCell
        
        let currentBeach = beaches[indexPath.row]
        cell.bind(currentBeach, viewBinder: BeachViewModelBinder())
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell is BeachLocationCell {
            let foldingCell = cell as! BeachLocationCell
            
            if cellHeights[indexPath.row] == kCloseCellHeight {
                foldingCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }

}
