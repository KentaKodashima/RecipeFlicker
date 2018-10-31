//
//  CollectionViewCellForCollection.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-30.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class CollectionViewCellForGrid: UICollectionViewCell {
  
  static var reuseIdentifier: String {
    get {
      return "CellForCollection"
    }
  }
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    label.font = UIFont.boldSystemFont(ofSize: 25)
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
    recipeImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    recipeImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    recipeImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
    recipeImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
  }
  
  func setupContents(withTitle title: String, andImage image: String) {
    titleLabel.text = title
    recipeImage.image = UIImage(named: image)
  }
  
}
