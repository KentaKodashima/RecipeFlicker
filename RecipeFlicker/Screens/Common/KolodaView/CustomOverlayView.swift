//
//  CustomOverlayView.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-12-02.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "likeOverlay"
private let overlayLeftImageName = "dislikeOverlay"

class CustomOverlayView: OverlayView {
  
  @IBOutlet lazy var overlayImageView: UIImageView! = {
    [unowned self] in
  
    
    self.clipsToBounds = true
    
    var imageView = UIImageView(frame: self.bounds)
    imageView.contentMode = .scaleAspectFill
    imageView.frame = self.bounds
    imageView.clipsToBounds = true
    imageView.layer.masksToBounds = true
    
    self.addSubview(imageView)
    
    return imageView
  }()
  
  override var overlayState: SwipeResultDirection?  {
    didSet {
      switch overlayState {
      case .left? :
        overlayImageView.image = UIImage(named: overlayLeftImageName)
      case .right? :
        overlayImageView.image = UIImage(named: overlayRightImageName)
      default:
        overlayImageView.image = nil
      }
    }
  }
}
