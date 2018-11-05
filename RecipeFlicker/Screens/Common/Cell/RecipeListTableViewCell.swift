//
//  RecipeListTableViewCell.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-04.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var recipeImage: UIImageView!
  @IBOutlet weak var recipeTitle: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
