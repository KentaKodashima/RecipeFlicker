//
//  Recipe.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-22.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import Firebase
import RealmSwift

@objcMembers public class Recipe: Object {
  @objc dynamic public var recipeId = ""
  @objc dynamic public var originalRecipeUrl = ""
  @objc dynamic public var title = ""
  @objc dynamic public var image = ""
  @objc dynamic public var isFavorite = false
  @objc dynamic public var whichCollectionToBelong: String?
  
  convenience init(recipeId: String, originalRecipeUrl: String, title: String, image: String, isFavorite: Bool) {
    self.init()
    self.recipeId = recipeId
    self.originalRecipeUrl = originalRecipeUrl
    self.title = title
    self.image = image
    self.isFavorite = isFavorite
  }
  
  func saveToFirebase(userId: String) {
    self.isFavorite = true
    var refPath = "favorites/" + userId
    guard let key = Database.database().reference(withPath: refPath).childByAutoId().key else { return }
    let favoriteRecipeRef = Database.database().reference(withPath: refPath).child(key)
    let dict = [
      "recipeId": key,
      "originalRecipeUrl": self.originalRecipeUrl,
      "title": self.title,
      "image": self.image,
      "isFavorite": String(self.isFavorite),
      "whichCollectionToBelong": self.whichCollectionToBelong
    ]
    favoriteRecipeRef.setValue(dict)
  }
}
