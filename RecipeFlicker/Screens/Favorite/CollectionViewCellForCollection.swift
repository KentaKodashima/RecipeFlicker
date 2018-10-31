//
//  CollectionViewCellForCollection.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-30.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class CollectionViewCellForCollection: UICollectionViewCell {
  private var collectionLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    return label
  }()
  
  private var collectionImage: UIImageView = {
    var imageView = UIImageView()
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
    collectionImage.translatesAutoresizingMaskIntoConstraints = false
    collectionImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
    collectionImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    collectionImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    collectionImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    addSubview(collectionImage)
    collectionLabel.translatesAutoresizingMaskIntoConstraints = false
    collectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    collectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    addSubview(collectionLabel)
  }
  
  func setupContents(withTitle title: String, andImage image: String) {
    collectionLabel.text = title
    collectionImage.image = UIImage(named: image)
  }
  
}
