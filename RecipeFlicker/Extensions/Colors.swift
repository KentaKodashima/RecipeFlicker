//
//  Colors.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-23.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

enum AppColors {
  case theme
  case appText
  case accent
  case dislike
  case like
}

extension AppColors {
  var value: UIColor {
    var color = UIColor.clear
    switch self {
    case .theme:
      color = #colorLiteral(red: 1, green: 0.9333333333, blue: 0.6823529412, alpha: 1)
    case .appText:
      color = #colorLiteral(red: 0.2117647059, green: 0.2117647059, blue: 0.2117647059, alpha: 1)
    case .accent:
      color = #colorLiteral(red: 0.9254901961, green: 0.4941176471, blue: 0.01960784314, alpha: 1)
    case .dislike:
      color = #colorLiteral(red: 0.337254902, green: 0.3843137255, blue: 0.7960784314, alpha: 1)
    case .like:
      color = #colorLiteral(red: 0.8980392157, green: 0.5215686275, blue: 0.5215686275, alpha: 1)
    }
    return color
  }
}
