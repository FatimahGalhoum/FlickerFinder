//
//  FlickerFinderTests.swift
//  FlickerFinderTests
//
//  Created by Fatimah Galhoum on 6/22/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import XCTest
@testable import FlickerFinder

class FlickerFinderTests: XCTestCase {
    var photoPresenter : PhotoPresenter!
    var groupPresenter: GroupsPresenter!

    override func setUp() {
        super.setUp()

        photoPresenter = PhotoPresenter()
        groupPresenter = GroupsPresenter()


    }

    override func tearDown() {
        super.tearDown()
    }

    
    
    func testPhotoSearchDoesReturnPhotos() {
        
        let expct = expectation(description: "Returns photo")
        
        photoPresenter.fetchPhotoData(currentPage: 1, searchText: "cool") { (finished) in
            
            XCTAssertEqual(finished, true)
            expct.fulfill()
            
        }
        waitForExpectations(timeout: 50)
    }

    
    
    func testGroupsSearchDoesReturnGroups() {
        
        let expct = expectation(description: "Returns groups")
        
        groupPresenter.fetchGroupData(currentPage: 1, searchText: "cool") { (finished) in
            
            XCTAssertEqual(finished, true)
            expct.fulfill()
        }
        waitForExpectations(timeout: 50)
    }
    
}
