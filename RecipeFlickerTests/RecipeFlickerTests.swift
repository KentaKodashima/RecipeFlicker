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
    let calendar = Calendar(identifier: .gregorian)
    var components = DateComponents(hour: 00, minute: 00, second: 00)
    let formatter = DateComponentsFormatter()
    let result = formatter.string(from: components)
    XCTAssertEqual(result!, "0", "components are properly converted.")
  }
  
}
