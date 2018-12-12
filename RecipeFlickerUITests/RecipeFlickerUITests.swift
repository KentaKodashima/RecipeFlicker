//
//  RecipeFlickerUITests.swift
//  RecipeFlickerUITests
//
//  Created by Kenta Kodashima on 2018-10-15.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import XCTest
@testable import RecipeFlicker

class RecipeFlickerUITests: XCTestCase {
  
  let app = XCUIApplication()
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    let homeVC = HomeVC()
//    homeVC.setCountdownView()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testIfCountdownViewAppears() {
    let dislikebtnButton = app.buttons["dislikeBtn"]
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
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
      dislikebtnButton.tap()
      
      self.app.staticTexts["Your next recipes are coming in..."]
      XCTAssert(self.app/*@START_MENU_TOKEN@*/.staticTexts["00:00:01"]/*[[".staticTexts[\"11:44:42\"]",".staticTexts[\"00:00:01\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
    }
  }
}
