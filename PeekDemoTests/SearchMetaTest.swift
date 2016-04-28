//
//  SearchMetaTest.swift
//  PeekDemo
//
//  Created by Steve Wang on 4/28/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import XCTest
@testable import PeekDemo

class SearchMetaTest: XCTestCase {
    var searchMeta: SearchMeta!

    override func setUp() {
        super.setUp()
        if let path = NSBundle(forClass: self.dynamicType).pathForResource("SearchMetaJSON", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                    searchMeta = SearchMeta(json: jsonResult["search_metadata"] as! [String: AnyObject])
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }

    }
    
    override func tearDown() {
        super.tearDown()
        searchMeta = nil
    }

    func testParsedCorrectly() {
        XCTAssertTrue(searchMeta.count == 15)
        XCTAssertTrue(searchMeta.next_results == "?max_id=723378300546998272&q=%40peek&include_entities=1")
        XCTAssertTrue(searchMeta.refresh_url == "?since_id=721838204173869058&q=from%3Apeek&include_entities=1")
        XCTAssertTrue(searchMeta.max_id == 721838204173869058)
    }

}
