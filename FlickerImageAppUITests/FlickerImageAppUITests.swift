//
//  FlickerImageAppUITests.swift
//  FlickerImageAppUITests
//
//  Created by Rahul Nair on 06/07/18.
//  Copyright © 2018 Rahul. All rights reserved.
//

import XCTest

class FlickerImageAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
        func testExample() {
        
        
        let app = XCUIApplication()
        sleep(10)
        
        let searchField = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element
        searchField.tap()
        searchField.tap()
        //app.searchFields.containing(.button, identifier:"Clear text").element.typeText("dog")
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards.buttons[\"Search\"]",".buttons[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.typeText("\n")
      
        
    }
    
}
