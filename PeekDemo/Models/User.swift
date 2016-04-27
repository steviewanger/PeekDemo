//
//  User.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/26/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import Foundation
import UIKit

class User {
    var id: Int
    var name: String
    var profileImage: String? = nil
    
    init(json: [String: AnyObject]) {
        id = json["id"] as! Int
        name = json["name"] as! String
        
        if let obj = json["profile_image_url"] as? String {
            profileImage = obj
        }
    }
}