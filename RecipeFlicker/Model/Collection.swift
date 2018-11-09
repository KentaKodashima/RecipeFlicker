//
//  Collection.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-04.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import Firebase

class Collection {
  public var firebaseId: String?
  public var name: String
  // Mark: Delete 'recipes' property and hold recipe IDs in a different firebase reference.
  public var recipes = [Recipe]()
  public var image: String?
  // Mark: Remove recipes from the constructor.
  init(collectionName: String, recipes: [Recipe]) {
    self.name = collectionName
    self.recipes = recipes
  }
  
  init(withFirebaseId id: String, andName name: String, andImageUrl image: String?) {
    self.firebaseId = id
    self.name = name
    self.image = image
  }
}

extension Collection {
  func saveToFirebase(userId: String) {
    let refPath = "collections/" + userId
    guard let key = Database.database().reference(withPath: refPath).childByAutoId().key else { return }
    self.firebaseId = key
    let collectionsRef = Database.database().reference(withPath: refPath).child(key)
    let dict: [String : Any] = [
      "firebaseId": key,
      "name": self.name,
      "recipes": ""
    ]
    // TODO: Re-consider dict making process
    // self.recipes.map { $0.firebaseId as! String }: self.recipes.map { $0.convertToJSON() }
    collectionsRef.setValue(dict)
    for recipe in self.recipes {
      let recipeRef = collectionsRef.child("recipes").child(recipe.firebaseId)
      recipeRef.setValue(recipe.convertToJSON())
    }
  }
}
