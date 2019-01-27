//
//  RecommendationCollectionViewCell.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2019-01-26.
//  Copyright © 2019 Kenta Kodashima. All rights reserved.
//

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var recipeImage: UIImageView!
  @IBOutlet weak var recipeTitle: UILabel!
  @IBOutlet weak var recipeIngredients: UITextView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
}
