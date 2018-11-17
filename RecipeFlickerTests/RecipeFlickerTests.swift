//
//  RecipeFlickerTests.swift
//  RecipeFlickerTests
//
//  Created by Kenta Kodashima on 2018-10-15.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import XCTest
@testable import RecipeFlicker

class RecipeFlickerTests: XCTestCase {
  
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testCountdownString() {
    let now = Date()
    let calendar = Calendar.current
    let components = DateComponents(calendar: calendar, hour: 7)  // <- 07:00 = 7am
    let nextDay = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
  }
  
}
