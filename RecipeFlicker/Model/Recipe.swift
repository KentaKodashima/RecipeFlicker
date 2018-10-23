//
//  Recipe.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-22.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation

struct Recipe {
  public var idFromAPI: String
  public var originalRecipeUrl: String
  public var title: String
  public var image: String
  public var isFavorite: Bool
  public var whichCollectionToBelong: String?
  
  init(idFromAPI: String, originalRecipeUrl: String, title: String, image: String, isFavorite: Bool) {
    self.idFromAPI = idFromAPI
    self.originalRecipeUrl = originalRecipeUrl
    self.title = title
    self.image = image
    self.isFavorite = isFavorite
  }
}
