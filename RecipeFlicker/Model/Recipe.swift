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
  @objc dynamic private(set) var firebaseId = ""
  @objc dynamic private(set) var originalRecipeUrl = ""
  @objc dynamic private(set) var title = ""
  @objc dynamic private(set) var image = ""
  @objc dynamic public var isFavorite = false
  public var whichCollectionToBelong = List<String>()
  
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
  
  convenience init(firebaseId: String, originalRecipeUrl: String, title: String, image: String, isFavorite: Bool, whichCollectionToBelong: List<String>) {
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
      "isFavorite": String(self.isFavorite)
    ]
    favoriteRecipeRef.setValue(dict)
    
    let whichCollectionToBelongRef = favoriteRecipeRef.child("whichCollectionToBelong")
    whichCollectionToBelongRef.setValue(self.whichCollectionToBelong.toArray(ofType: String.self))
  }
  
  func convertToJSON() -> Dictionary<String, Any> {
    var recipeDict: [String:Any] = [
      "firebaseId": self.firebaseId,
      "realmId": self.realmId,
      "originalRecipeUrl": self.originalRecipeUrl,
      "title": self.title,
      "image": self.image,
      "isFavorite": String(self.isFavorite)
    ]
    recipeDict["whichCollectionToBelong"] = self.whichCollectionToBelong.toArray(ofType: String.self)
    
    return recipeDict
  }
  
  func updateWhichCollectionToBelong(userId: String) {
    let ref = Database.database().reference()
    ref.child("favorites/\(userId)/\(self.firebaseId)/whichCollectionToBelong")
      .setValue(self.whichCollectionToBelong.toArray(ofType: String.self))
  }
  
  func updateRecipeInCollection(collectionId: String) {
    let recipeCollectionsRefPath = "recipeCollections/" + collectionId
    Database.database().reference(withPath: recipeCollectionsRefPath)
      .child(self.firebaseId).setValue(self.convertToJSON())
  }
}
