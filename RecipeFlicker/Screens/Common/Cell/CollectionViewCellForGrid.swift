//
//  CollectionViewCellForGrid.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-30.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class CollectionViewCellForGrid: UICollectionViewCell {
  
  static var reuseIdentifier: String {
    get {
      return "CellForGrid"
    }
  }
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    label.font = UIFont(name: "ChalkboardSE-Regular", size: 21)
    return label
  }()
  
  private var recipeImage: UIImageView = {
    var imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(recipeImage)
    setupImageConstraints()
    addSubview(titleLabel)
    
    setupTextConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupTextConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  private func setupImageConstraints() {
    recipeImage.translatesAutoresizingMaskIntoConstraints = false
    recipeImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
    recipeImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    recipeImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    recipeImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//    recipeImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//    recipeImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    recipeImage.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//    recipeImage.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
    
  }
  
  func setupContents(withTitle title: String, andImage image: String) {
    titleLabel.text = title
    let imageUrl = URL(string: image)
    recipeImage.kf.setImage(with: imageUrl, completionHandler: {
      (image, error, cacheType, imageUrl) in
      if image == nil { self.recipeImage.image = UIImage(named: "NoImage") }
      if error != nil { self.recipeImage.image = UIImage(named: "NoImage") }
//      self.recipeImage.image = self.darken(image: image!)
//      let blackLayer = UIView()
//      blackLayer.backgroundColor = UIColor.black
//      blackLayer.layer.opacity = 0.9
//      self.recipeImage.image = image?.withRenderingMode(.automatic)
//      self.recipeImage.addSubview(blackLayer)
    })
  }
  
  func darken(image: UIImage) -> UIImage {
    // create a black layer
    let blackFrame = CGRect(origin: CGPoint(x: 0, y: 0),
                            size: (image.size))
    let blackView = UIView(frame: blackFrame)
    blackView.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    blackView.alpha = 1
    
    // draw the image
    UIGraphicsBeginImageContext(blackFrame.size)
    let context = UIGraphicsGetCurrentContext()
    image.draw(in: blackFrame)
    
    // put the black layer over the context
    context!.translateBy(x: 0, y: blackFrame.size.height)
    context!.scaleBy(x: 1.0, y: -1.0)
    context!.clip(to: blackFrame, mask: image.cgImage!)
    blackView.layer.render(in: context!)
    
    // Produce a new image from this context
    let imageRef = context!.makeImage()
    let renderedImage = UIImage(cgImage: imageRef!)
    UIGraphicsEndImageContext()
    return renderedImage
  }
  
}
