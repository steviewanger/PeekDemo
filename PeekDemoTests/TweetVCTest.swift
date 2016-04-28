//
//  TweetVCTest.swift
//  PeekDemoTests
//
//  Created by Steve Wang on 4/25/16.
//  Copyright © 2016 Steve Wang. All rights reserved.
//

import XCTest
@testable import PeekDemo

class TweetVCTest: XCTestCase {
    var vc: TweetVC!
    
    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.vc = storyboard.instantiateViewControllerWithIdentifier("TweetVC") as! TweetVC
        self.vc.performSelectorOnMainThread(#selector(UIViewController.loadView), withObject: nil, waitUntilDone: true)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.vc = nil
        super.tearDown()
    }
    
    func testThatViewLoads() {
        XCTAssertNotNil(self.vc.view, "View not instantiated properly")
    }
    
    func testParentViewHasTableViewSubview() {
        let subviews: [AnyObject] = self.vc.view.subviews
        XCTAssertTrue(subviews.contains({$0 as! NSObject == self.vc.tableView}) , "View does not have a table subview")
    }
    
    func testThatTableViewLoads() {
        XCTAssertNotNil(self.vc.tableView, "Table not intiated")
    }
    
    func testThatViewConformsToUITableViewDataSource() {
        XCTAssertTrue(self.vc.conformsToProtocol(UITableViewDataSource), "View does not conform to UITableViewDataSource")
    }
    
    func testThatTableViewHasDataSource() {
        XCTAssertNotNil(self.vc.tableView.dataSource, "Table datasource can't be nil")
    }
    
    func testThatViewConformsToUITableViewDelegate() {
        XCTAssertTrue(self.vc.conformsToProtocol(UITableViewDelegate), "View does not conform to UITableViewDelegate")
    }
    
    func testTableViewIsConnectedToDelegate() {
        XCTAssertNotNil(self.vc.tableView.delegate, "Table delegate can't be nil")
    }
}
