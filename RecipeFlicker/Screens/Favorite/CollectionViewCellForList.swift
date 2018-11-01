//
//  CollectionViewCellForAll.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-30.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class CollectionViewCellForList: UICollectionViewCell {
  
  static var reuseIdentifier: String {
    get {
      return "CellForAll"
    }
  }
  
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    label.textAlignment = .center
    return label
  }()
  
  private let recipeImage: UIImageView = {
    let imageView = UIImageView()
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
    setupLabelConstraints()
    contentView.setBorder()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLabelConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor,
                                       constant: 16).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: recipeImage.trailingAnchor,
                                      constant: 8).isActive = true
  }
  
  func setupImageConstraints() {
    recipeImage.translatesAutoresizingMaskIntoConstraints = false
    // left edge
    recipeImage.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor,
                                         constant: 16).isActive = true
    // width
    recipeImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
    
    // heigth
    recipeImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
    
    // center vertical
    recipeImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  func setupContents(withTitle title: String, andImage image: String) {
    titleLabel.text = title
    guard let thumbnail = UIImage(named: image) else {
      recipeImage.image = UIImage(named: "NoImage")
      return
    }
    recipeImage.image = thumbnail
  }
}

extension UIView {
  func setBorder() {
    let margin = 25
    let border = CALayer()
    border.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    border.borderWidth = 0.5
    border.frame = CGRect(x: CGFloat(margin), y: self.frame.size.height - border.borderWidth, width: self.frame.size.width - CGFloat(integerLiteral: margin), height: border.borderWidth)
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
    
  }
}
