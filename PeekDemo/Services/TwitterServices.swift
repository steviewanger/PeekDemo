//
//  TwitterServices.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/26/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import Foundation

@objc protocol TwitterServicesDelegate {
    optional func getTweetsSuccess(search: TSearch)
    optional func getTweetsFail(error: NSError)
}

class TwitterServices {
    //MARK: - Properties
    private let cKey = "LUAruoWtjAkeyGQT2jSdbPBAn"
    private let cSecret = "lDkIyf83ioQgQuzFvalkv2zTzcTF194tvOLhH3gAUJ5nhwMRUo"
    
    private let bearerToken = "AAAAAAAAAAAAAAAAAAAAAJxmuwAAAAAADXac5yOhMMSLmGKagcMMLbvi8V8%3DLW8TKuT660D4oDIiXjP8nA01pTg6FlaYwtTZnWUxrvmSOihnG1"
    private let SEARCH_URL = "https://api.twitter.com/1.1/search/tweets.json"
    
    var delegate: TwitterServicesDelegate?
    
    //MARK: - Functions
    
    //Get tweets using search params
    func getTweets(params: String) {
        let url = "\(SEARCH_URL)\(params)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        print(url)
        print("")
        getRequest(NSURL(string: url!)!, params: nil)
    }
    
    private func getRequest(URL: NSURL, params: [String: String]?) {
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        if params != nil {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params!, options: [])
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard data != nil && error == nil else {
                print(error)
                self.delegate?.getTweetsFail!(error!)
                return
            }
            
            guard let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 else {
                print("Error: Status code")
                self.delegate?.getTweetsFail!(error!)
                return
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]            
                if self.delegate != nil {
                    self.delegate?.getTweetsSuccess!(TSearch(json: json))
                }
                
            } catch let parseError {
                print("Error with Json: \(parseError)")
                self.delegate?.getTweetsFail!(error!)
            }
        }
        task.resume()
    }
}