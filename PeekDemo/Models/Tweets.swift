//
//  Tweets.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/26/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import Foundation

class Tweets {
    var id: Int
    var text: String
    var created_at: NSDate?
    var user: User
    
    init(json: [String: AnyObject]) {
        id = json["id"] as! Int
        text = json["text"] as! String
        user = User(json: json["user"] as! [String: AnyObject])
        
        if let date = NSDate.dateFromTwitterString(json["created_at"] as! String) {
            created_at = date
        }
    }
}