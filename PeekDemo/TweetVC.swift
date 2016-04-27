//
//  TweetVC.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/25/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import UIKit
import Social

class TweetVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TwitterServicesDelegate {
    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    var search: TSearch?
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var pagingIndicator: UIActivityIndicatorView!
    let tService = TwitterServices()
    var paginating: Bool = false
    
    //MARK: - Init
    override func viewDidLoad() {
        self.getTweets()
        self.loadTableView()
        self.addRefreshViewController()
    }
    
    func addRefreshViewController() {
        refreshControl.addTarget(self, action: #selector(TweetVC.refreshPulled), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func loadTableView() {
        // Nibs
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        
        // Allow for dynamic height table cells
        self.tableView.estimatedRowHeight = TweetCell.estimatedRowHeight
        self.tableView.rowHeight = TweetCell.rowHeight
        
        // Add activity indicator to bottom of table view
        pagingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        pagingIndicator.startAnimating()
        pagingIndicator.frame = CGRectMake(0, 0, 320, 44)
        self.tableView.tableFooterView = pagingIndicator
    }
    
    func getTweets() {
        tService.delegate = self
        tService.getTweets("?q=@peek")
    }
    
    func getNextTweets() {
        if search?.meta.next_results != nil {
            tService.getTweets((search?.meta.next_results)!)
        }
        else {
            let params = "?q=@peek&max_id=\((search?.tweets.last?.id)! - 1)"
            print(params)
            tService.getTweets(params)
        }
    }
    
    //MARK: - TwitterServices
    func getTweetsSuccess(search: TSearch) {
        if paginating {
            self.search?.meta = search.meta
            self.search?.tweets.appendContentsOf(search.tweets)
        }
        else {
            self.search = search
            self.refreshControl.endRefreshing()
        }
        
        // If no more tweets to download, remove the activity indicator view
        if search.tweets.count == 0 {
            self.tableView.tableFooterView = nil
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.paginating = false
            self.tableView.reloadData()
        })
    }
    
    func getTweetsFail(error: NSError) {
        self.refreshControl.endRefreshing()
    }
    
    //MARK: - Refresh Control 
    func refreshPulled() {
        getTweets()
    }
    
    //MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search != nil ? (search?.tweets.count)! : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = (search?.tweets[indexPath.row])!
        cell.selectionStyle = .None
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red:192 / 255, green:222 / 255, blue:237 / 255, alpha:1.000)
        }
        else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // If almost at the end of the tableview, then load more tweets
        if (search?.tweets.count)! - indexPath.row == 4 && !paginating {
            paginating = true
            getNextTweets()
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let retweetAction = UITableViewRowAction(style: .Normal, title: "Retweet", handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                tweetSheet.setInitialText("RT: \((self.search?.tweets[indexPath.row].text)!)")
                
                self.presentViewController(tweetSheet, animated: true, completion: nil)
            }
            else {
                let alertView = UIAlertController(title: "Attention", message: "You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        })
        retweetAction.backgroundColor = UIColor(red: 29 / 255, green: 202 / 255, blue: 255 / 255, alpha: 1)

        let deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete" , handler:{ (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            tableView.editing = true
            self.search?.tweets.removeAtIndex(indexPath.row)
            
            UIView.animateWithDuration(0.5,
                animations: {
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                },
                completion: { (Bool) in
                    tableView.reloadData()
            })

        })
        
        return [deleteAction, retweetAction]
    }
}