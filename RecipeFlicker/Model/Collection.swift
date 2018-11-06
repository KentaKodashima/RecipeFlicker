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
  private var collectionName: String
  private var recipes: [Recipe]
  
  init(collectionName: String, recipes: [Recipe]) {
    self.collectionName = collectionName
    self.recipes = recipes
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
      "name": self.collectionName,
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
