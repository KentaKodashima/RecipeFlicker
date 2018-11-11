//
//  UILabel+Extensions.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-09.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  func setCountdownTimerText() {
    let now = Date()
    let calendar = Calendar.current
    let components = DateComponents(calendar: calendar, hour: 7)  // <- 07:00 = 7am
    let nextDay = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
    let difference = calendar.dateComponents([.hour, .minute, .second], from: now, to: nextDay)
    let formatter = DateComponentsFormatter()
    self.text = formatter.string(from: difference)
  }
}
