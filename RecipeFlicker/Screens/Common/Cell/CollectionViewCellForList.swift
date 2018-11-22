//
//  CollectionViewCellForList.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-30.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class CollectionViewCellForList: UICollectionViewCell {
  
  static var reuseIdentifier: String {
    get {
      return "CellForList"
    }
  }
  
  private var isChecked: Bool = false
  private var selectedImage = UIImage(named: "checkmark")
  private var deselectedImage = UIImage(named: "defaultCheck")
  private var leftConstraintOfImage: NSLayoutConstraint?
  // check box constraint (left, width, vertical)
  private var leftConstraintOfCheckBox: NSLayoutConstraint?
  private var widthConstraintOfCheckBox: NSLayoutConstraint?
  private var verticalConstraintOfCheckBox: NSLayoutConstraint?
  
  
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
  
  private let checkBoxImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .center
    imageView.image = UIImage(named: "defaultCheck")
    return imageView
  }()
  
  private func toggleCheckBox() {
    isChecked = !isChecked
    if (isChecked) {
      checkBoxImage.image = selectedImage
    } else {
      checkBoxImage.image = deselectedImage
    }
  }
  
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
    leftConstraintOfImage = recipeImage.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor,
                                                                 constant: 16)
    leftConstraintOfImage?.isActive = true
    // width
    recipeImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
    
    // heigth
    recipeImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
    
    // center vertical
    recipeImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  func setupContents(withTitle title: String, andImage imagePath: String) {
    titleLabel.text = title
    let imageUrl = URL(string: imagePath)
    recipeImage.kf.setImage(with: imageUrl, completionHandler: {
      (image, error, cacheType, imageUrl) in
      if image == nil { self.recipeImage.image = UIImage(named: "NoImage") }
      if error != nil { self.recipeImage.image = UIImage(named: "NoImage") }
    })
  }
  
  func showEditMode() {
    leftConstraintOfImage?.isActive = false
    addSubview(checkBoxImage)
    setupCheckBoxConstraints()
    leftConstraintOfImage = recipeImage.leadingAnchor.constraint(equalTo: checkBoxImage.trailingAnchor, constant: 8)
    leftConstraintOfImage?.isActive = true
  }
  
  private func setupCheckBoxConstraints() {
    checkBoxImage.translatesAutoresizingMaskIntoConstraints = false
    // width
    widthConstraintOfCheckBox = checkBoxImage.widthAnchor.constraint(equalToConstant: 25)
    widthConstraintOfCheckBox?.isActive = true
    // left
    leftConstraintOfCheckBox = checkBoxImage.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor,
      constant: 8)
    leftConstraintOfCheckBox?.isActive = true
    // vertical
    verticalConstraintOfCheckBox = checkBoxImage.centerYAnchor.constraint(equalTo: centerYAnchor)
    verticalConstraintOfCheckBox?.isActive = true
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
