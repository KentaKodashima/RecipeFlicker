//
//  Date+Extensions.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-12.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation

extension Date {
  func timeUntilNext7am() -> DateComponents {
    let calendar = Calendar.current
    let components = DateComponents(calendar: calendar, hour: 7)  // <- 07:00 = 7am
    let nextDay = calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime)!
    let difference = calendar.dateComponents([.hour, .minute, .second], from: self, to: nextDay)
    
    return difference
  }
  
  func get7am() -> Date {
    let calendar = Calendar.current
    let components = DateComponents(calendar: calendar, hour: 7)  // <- 07:00 = 7am
    let date = calendar.date(from: components)
    
    return date!
  }
  
//  func getNextDay() -> Date {
//    let calendar = Calendar.current
//    let components = DateComponents(calendar: calendar, hour: 7)  // <- 07:00 = 7am
//    let nextDay = calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime)!
//
//    return nextDay
//  }
}
