//
//  DatedRefreshView.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/26/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import Foundation
import UIKit

class DatedRefreshView {
    var refreshControl: UIRefreshControl
    var activityInd: UIActivityIndicatorView
    var timeLabel: UILabel
    var updatedDate: NSDate
    
    init(refreshDate: NSDate) {
        refreshControl = UIRefreshControl()
        
        let refreshView = UIView(frame: self.refreshControl.frame)
        activityInd = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        updatedDate = refreshDate
        timeLabel = UILabel()
        
        self.setTimeLabel(refreshDate)
        
        
    }
    
    func setTimeLabel(date: NSDate) {
        
    }
}