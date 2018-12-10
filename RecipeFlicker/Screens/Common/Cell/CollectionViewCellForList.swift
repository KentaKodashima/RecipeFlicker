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
  
  private var selectedImage = UIImage(named: "checkmark")
  private var deselectedImage = UIImage(named: "defaultCheck")
  
  lazy var parentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [checkBoxImage, childStackView])
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  lazy var childStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [recipeImage, titleLabel])
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    label.numberOfLines = 3
    label.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
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
  
  public let checkBoxImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .center
    imageView.image = UIImage(named: "defaultCheck")
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(parentStackView)
    setupStackViewConstraints()
    setupCheckBoxConstraints()
    setupImageConstraints()
    checkBoxImage.isHidden = true
    contentView.setBorder()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupStackViewConstraints() {
    parentStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor,
                                       constant: 8).isActive = true
    parentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                        constant: -16).isActive = true
    parentStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
  
  func setupImageConstraints() {
    recipeImage.translatesAutoresizingMaskIntoConstraints = false
    // width
    recipeImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
    // heigth
    recipeImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
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
  
  func toggleEditMode(isEditing: Bool) {
    if isEditing {
      UIView.animate(withDuration: 0.3) {
        self.checkBoxImage.isHidden = false
      }
    } else {
      if !checkBoxImage.isHidden {
        UIView.animate(withDuration: 0.3) {
          self.checkBoxImage.isHidden = true
        }
      }
    }
  }
  
  private func setupCheckBoxConstraints() {
    checkBoxImage.translatesAutoresizingMaskIntoConstraints = false
    // width
    checkBoxImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
    // height
    checkBoxImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
  }
  
  override var isSelected: Bool {
    didSet {
      checkBoxImage.image = isSelected ? selectedImage: deselectedImage
    }
  }
}



extension UIView {
  func setBorder() {
    let margin = 20
    let border = CALayer()
    border.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    border.borderWidth = 0.5
    border.frame = CGRect(x: CGFloat(margin), y: self.frame.size.height - border.borderWidth, width: self.frame.size.width - CGFloat(integerLiteral: margin), height: border.borderWidth)
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
    
  }
}
