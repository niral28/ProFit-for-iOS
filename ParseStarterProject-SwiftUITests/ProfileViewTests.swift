//
//  ProfileViewTests.swift
//  ParseStarterProject-Swift
//
//  Created by Niral Shah on 4/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import XCTest



class ProfileViewTests: XCTestCase {
        
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
        app.buttons["Login with Facebook"].tap()
        app.buttons["Authorize HealthKit"].tap()
        
        let window = app.childrenMatchingType(.Window).elementBoundByIndex(0)
        let element = window.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        let element2 = element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        let decrementButton = element2.childrenMatchingType(.Stepper).elementBoundByIndex(0).buttons["Decrement"]
        decrementButton.tap()
        decrementButton.tap()
        decrementButton.tap()
        decrementButton.tap()
        decrementButton.tap()
        decrementButton.tap()
        decrementButton.tap()
        decrementButton.tap()
        decrementButton.tap()
        
        let incrementButton = element2.childrenMatchingType(.Stepper).elementBoundByIndex(1).buttons["Increment"]
        incrementButton.pressForDuration(0.6);
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        app.buttons["Add Friends"].tap()
        window.childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        app.buttons["Send"].tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
