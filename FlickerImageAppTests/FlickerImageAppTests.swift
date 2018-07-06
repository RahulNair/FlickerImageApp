//
//  FlickerImageAppTests.swift
//  FlickerImageAppTests
//
//  Created by Rahul Nair on 26/06/18.
//  Copyright © 2018 Rahul. All rights reserved.
//

import XCTest
@testable import FlickerImageApp

class FlickerImageAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test0001_fetchGET_URL() {
        //valid url
        let expectation = XCTestExpectation(description: "Fetch image data valid url")
        let networkObj = NetworkHelper()
        let url = "https://api.flickr.com/services/rest/"
        let paramDict :  [URLQueryItem] =  [URLQueryItem(name: "method", value: "flickr.photos.search"),
                                            URLQueryItem(name: "api_key", value: "3e7cc266ae2b0e0d78e279ce8e361736"),
                                            URLQueryItem(name: "format", value: "json"),
                                            URLQueryItem(name: "nojsoncallback", value: "1"),
                                            URLQueryItem(name: "safe_search", value: "1"),
                                            URLQueryItem(name: "text", value: "kitten"),
                                            URLQueryItem(name: "page", value: "1")]
        
        
        networkObj.fetchGET_URL(urlString: url, queryItems: paramDict) { (results) in
            switch results {
            case .success(let val) :
                XCTAssertNil(val, "Error occured")
                 let jsonString = String(data: val, encoding: String.Encoding.utf8)
                 XCTAssertGreaterThan((jsonString?.count)!, 0, "Records found")
            case .failure(let val) :
                XCTAssertNotNil(val, "Error occured")
            }
            
            expectation.fulfill()

        }
        
        wait(for: [expectation], timeout: 60)


        
    }
    
    
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
