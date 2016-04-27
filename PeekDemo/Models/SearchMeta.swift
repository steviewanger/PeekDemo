//
//  SearchMeta.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/26/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import Foundation

class SearchMeta {
    var max_id: Int
    var next_results: String? = nil
    var refresh_url: String? = nil
    var count: Int
    
    init(json: [String: AnyObject]) {
        max_id = json["max_id"] as! Int
        count = json["count"] as! Int
        
        if let obj = json["next_results"] as? String {
            next_results = obj
        }
        
        if let obj = json["refresh_url"] as? String {
            refresh_url = obj
        }
    }
}