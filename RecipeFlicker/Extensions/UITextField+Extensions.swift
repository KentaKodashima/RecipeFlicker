//
//  UITextField+Extentions.swift
//  Amtrip
//
//  Created by Kenta Kodashima on 2018-10-11.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
  public func createToolbarForKeyboard() {
    // Create close button above the textView keyboard
    // Tool bar
    let closeBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
    closeBar.barStyle = UIBarStyle.default  // Style
    closeBar.sizeToFit()  // Size change depends on screen size
    // Spacer
    let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
    // Close Botton
    let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(closeButtonTapped))
    closeBar.items = [spacer, closeButton]
    self.inputAccessoryView = closeBar
  }
  // Enable textView to close
  @objc func closeButtonTapped() {
    self.endEditing(true)
  }
}
