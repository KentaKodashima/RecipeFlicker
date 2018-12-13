//
//  UIActivityIndicatorView+Extensions.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-12-13.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
  
  public func setActivityIndicator(indicatorContainerView: UIView, containerParentView: UIView) {
    indicatorContainerView.frame.size.width = 80
    indicatorContainerView.frame.size.height = 80
    //= UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    indicatorContainerView.center = containerParentView.center
    indicatorContainerView.backgroundColor = UIColor.black
    indicatorContainerView.alpha = 0.8
    indicatorContainerView.layer.cornerRadius = 10
    
    self.hidesWhenStopped = true
    self.style = UIActivityIndicatorView.Style.whiteLarge
    self.translatesAutoresizingMaskIntoConstraints = false
    
    indicatorContainerView.addSubview(self)
    containerParentView.addSubview(indicatorContainerView)
    
    // Constraints
    self.centerXAnchor.constraint(equalTo: indicatorContainerView.centerXAnchor).isActive = true
    self.centerYAnchor.constraint(equalTo: indicatorContainerView.centerYAnchor).isActive = true
  }
  
  public func showActivityIndicator(show: Bool, indicatorContainerView: UIView) {
    if show {
      self.startAnimating()
    } else {
      self.stopAnimating()
      indicatorContainerView.removeFromSuperview()
    }
  }
}
