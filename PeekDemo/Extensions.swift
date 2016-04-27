//
//  Extensions.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/26/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func toBase64() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        
        return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
    }
    
    var length: Int { return self.characters.count }
}

extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else { return }
        
        let refreshController = UIActivityIndicatorView(frame: self.frame)
        self.addSubview(refreshController)
        refreshController.startAnimating()
        
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else {
                    refreshController.stopAnimating()
                    return
                }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                refreshController.stopAnimating()
                self.image = image
            }
        }).resume()
    }
}

extension NSDate {
    class func dateFromTwitterString(dateString: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        return dateFormatter.dateFromString(dateString)
    }
}