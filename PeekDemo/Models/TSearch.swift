//
//  TSearch.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/26/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import Foundation

@objc class TSearch: NSObject {
    var meta: SearchMeta
    var tweets: [Tweets] = Array<Tweets>()
    
    init(json: [String: AnyObject]) {
        meta = SearchMeta(json: json["search_metadata"] as! [String: AnyObject])
        
        if let objs = json["statuses"] as? Array<AnyObject> {
            for obj in objs {
                tweets.append(Tweets(json: obj as! [String : AnyObject]))
            }
        }
    }
}