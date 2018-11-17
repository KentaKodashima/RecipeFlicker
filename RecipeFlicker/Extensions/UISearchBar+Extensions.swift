//
//  UISearchBar+Extensions.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-17.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
  public func setSearchBar() {
    // Search bar style
    self.isTranslucent = false
    let searchTextField = self.value(forKey: "_searchField") as? UITextField
    let searchImageView = self.value(forKey: "_background") as? UIImageView
    searchImageView?.removeFromSuperview()
    self.backgroundColor = AppColors.theme.value
    // Remove the borders
    self.layer.borderColor = AppColors.theme.value.cgColor
    self.layer.borderWidth = 1
    
    // Change icon color of UISearchBar
    let glassIcon = searchTextField?.leftView as? UIImageView
    glassIcon?.image = glassIcon?.image?.withRenderingMode(.alwaysTemplate)
    glassIcon?.tintColor = AppColors.accent.value
  }
}
