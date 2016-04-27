//
//  TweetCell.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/26/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import Foundation
import UIKit

class TweetCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var uNameTimeLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    //MARK: - Properties
    static var estimatedRowHeight: CGFloat = 92
    static var rowHeight = UITableViewAutomaticDimension
    
    var tweet: Tweets! {
        didSet {
            if tweet.user.profileImage != nil {
                avatarImage.downloadedFrom(link: tweet.user.profileImage!, contentMode: .ScaleToFill)
            }
            else {
                
            }
            
            messageLabel.text = tweet.text
            
            //Look up ways to better memory manage NSDateFormatter
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d h:mm a"
            formatter.timeZone = NSTimeZone.systemTimeZone()
            
            let timeString = "\(formatter.stringFromDate(tweet.created_at!))"
            let nameTime = "\(tweet.user.name), \(timeString)"
            
            let attrString = NSMutableAttributedString(string: nameTime)
            attrString.addAttribute(NSForegroundColorAttributeName,
                value: UIColor.grayColor(),
                range:  NSRange(location: tweet.user.name.length + 2, length: timeString.length))
            uNameTimeLabel.attributedText = attrString
        }
    }
}