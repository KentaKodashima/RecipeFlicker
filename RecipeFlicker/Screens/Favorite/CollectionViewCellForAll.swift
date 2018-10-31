//
//  CollectionViewCellForAll.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-30.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class CollectionViewCellForAll: UICollectionViewCell {
  private let allLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    label.textAlignment = .center
    return label
  }()
  
  private let allImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    allImage.translatesAutoresizingMaskIntoConstraints = false
    allImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
    allImage.leadingAnchor.constraint(
      equalTo: contentView.layoutMarginsGuide.leadingAnchor,
      constant: 16)
      .isActive = true
    allImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    addSubview(allImage)
    allLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    allLabel.trailingAnchor.constraint(
      equalTo: contentView.layoutMarginsGuide.trailingAnchor,
      constant: 16)
    allLabel.leadingAnchor.constraint(equalTo: allImage.trailingAnchor, constant: 8).isActive = true
    addSubview(allLabel)
  }
  
  func setupContents(withTitle title: String, andImage image: String) {
    allLabel.text = title
    allImage.image = UIImage(named: image)
  }
}
