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
  
  enum Property: String {
    case realmId, firebaseId, originalRecipeUrl, title, image, whichCollectionToBelong
  }
  
  @objc dynamic private(set) var realmId = UUID().uuidString
  @objc dynamic public var firebaseId = ""
  @objc dynamic public var originalRecipeUrl = ""
  @objc dynamic public var title = ""
  @objc dynamic public var image = ""
  @objc dynamic public var isFavorite = false
  @objc dynamic public var whichCollectionToBelong: String?
  
  override public static func primaryKey() -> String? {
    return Recipe.Property.realmId.rawValue
  }
  
  convenience init(originalRecipeUrl: String, title: String, image: String, isFavorite: Bool) {
    self.init()
    self.originalRecipeUrl = originalRecipeUrl
    self.title = title
    self.image = image
    self.isFavorite = isFavorite
  }
  
  convenience init(firebaseId: String, originalRecipeUrl: String, title: String, image: String, isFavorite: Bool, whichCollectionToBelong: String?) {
    self.init()
    self.firebaseId = firebaseId
    self.originalRecipeUrl = originalRecipeUrl
    self.title = title
    self.image = image
    self.isFavorite = isFavorite
    self.whichCollectionToBelong = whichCollectionToBelong
  }
}

extension Recipe {
  func saveToFirebase(userId: String) {
    let refPath = "favorites/" + userId
    guard let key = Database.database().reference(withPath: refPath).childByAutoId().key else { return }
    self.isFavorite = true
    self.firebaseId = key
    let favoriteRecipeRef = Database.database().reference(withPath: refPath).child(key)
    let dict = [
      "firebaseId": key,
      "realmId": self.realmId,
      "originalRecipeUrl": self.originalRecipeUrl,
      "title": self.title,
      "image": self.image,
      "isFavorite": String(self.isFavorite),
      "whichCollectionToBelong": self.whichCollectionToBelong
    ]
    favoriteRecipeRef.setValue(dict)
  }
  
  func convertToJSON() -> Dictionary<String, Any> {
    let recipeDict = [
      "firebaseId": self.firebaseId,
      "realmId": self.realmId,
      "originalRecipeUrl": self.originalRecipeUrl,
      "title": self.title,
      "image": self.image,
      "isFavorite": String(self.isFavorite),
      "whichCollectionToBelong": self.whichCollectionToBelong
    ]
    return recipeDict
  }
}
