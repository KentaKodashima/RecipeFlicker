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
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(recipeImage)
//    addSubview(allLabel)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    recipeImage.translatesAutoresizingMaskIntoConstraints = false
    // left edge
    recipeImage.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor,
                                      constant: 16).isActive = true
    // width
    recipeImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
    
    // heigth
    recipeImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    // center vertical
    recipeImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
//    allLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    allLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor,
//                                       constant: 16).isActive = true
//    allLabel.leadingAnchor.constraint(equalTo: allImage.trailingAnchor,
//                                      constant: 8).isActive = true
  }
  
  func setupContents(withTitle title: String, andImage image: String) {
    titleLabel.text = title
    recipeImage.image = UIImage(named: image)
  }
}
