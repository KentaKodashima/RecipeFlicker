//
//  Recipe.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-22.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import Firebase

struct Recipe: Codable {
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
  
  mutating func saveToFirebase() {
    self.isFavorite = true
    let usersRef = Database.database().reference(withPath: "user").child("favorites")
    let dict = [
      "idFromAPI": self.idFromAPI,
      "originalRecipeUrl": self.originalRecipeUrl,
      "title": self.title,
      "image": self.image,
      "isFavorite": String(self.isFavorite),
      "whichCollectionToBelong": self.whichCollectionToBelong
    ]
    let favoriteRecipeRef = usersRef.childByAutoId()
    favoriteRecipeRef.setValue(dict)
  }
}
