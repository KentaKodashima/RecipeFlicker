//
//  RecipeFlickerUITests.swift
//  RecipeFlickerUITests
//
//  Created by Kenta Kodashima on 2018-10-15.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import XCTest

class RecipeFlickerUITests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testCardViews() {
    
    let app = XCUIApplication()
    
    let dislikebtnButton = app.buttons["dislikeBtn"]
    dislikebtnButton/*@START_MENU_TOKEN@*/.swipeRight()/*[[".swipeUp()",".swipeRight()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    
    app.statusBars.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 1)/*@START_MENU_TOKEN@*/.swipeLeft()/*[[".swipeDown()",".swipeLeft()"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    dislikebtnButton.tap()
    
    app.staticTexts["Your next recipes are coming in..."].tap()
    app.staticTexts["16:13:15"].tap()
    app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
    
  }
  
}
