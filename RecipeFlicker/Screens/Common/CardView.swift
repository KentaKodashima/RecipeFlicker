//
//  CardView.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-23.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
  @IBOutlet weak var cardImage: UIImageView!
  @IBOutlet weak var recipeTitle: UILabel!
  
  /// For using custom view in code
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  /// For using custom view in IB
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  // Load xib and add it to the view
  fileprivate func commonInit() {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "CardView", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    let bindings = ["view": view]
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: bindings))
  }
  
}
