//
//  StoreTests.swift
//  ParseStarterProject-Swift
//
//  Created by Niral Shah on 4/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import XCTest

class StoreTests: XCTestCase {
        
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
        app.scrollViews.otherElements.icons["ParseStarterProject-Swift"].tap()
        app.buttons["Login with Facebook"].tap()
        app.buttons["Authorize HealthKit"].tap()
        app.tabBars.buttons["Game"].tap()
        app.navigationBars["Workout Wheel"].buttons["Store"].tap()
        app.navigationBars["Arena"].buttons["Store"].tap()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.cells.containingType(.StaticText, identifier:"Fitness Bands").buttons["Get it!"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"Beats Headphones").buttons["Get it!"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
