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
  public var image: String?
  
  init(withId id: String, andName name: String, andImageUrl image: String?) {
    self.firebaseId = id
    self.name = name
    self.image = image
  }
  
  init(withName name: String, andImageUrl image: String?) {
    self.name = name
    self.image = image
  }
}

extension Collection {
  func saveToFirebase(userId: String, recipes: [Recipe]) {
    let userCollectionsRefPath = "userCollections/" + userId
    guard let key = Database.database().reference(withPath: userCollectionsRefPath).childByAutoId().key else { return }
    self.firebaseId = key
    let collectionsRef = Database.database().reference(withPath: userCollectionsRefPath).child(key)
    let collection: [String : String] = [
      "firebaseId": key,
      "name": self.name,
      "image": self.image ?? ""
    ]
    collectionsRef.setValue(collection)
    
    for recipe in recipes {
      recipe.whichCollectionToBelong.append(key)
      for id in recipe.whichCollectionToBelong {
        recipe.updateRecipeInCollection(collectionId: id)
      }
      recipe.updateWhichCollectionToBelong(userId: userId)

    }
  }
  
  func updateRecipeCollection(recipe: Recipe) {
    let recipeCollectionsRefPath = "recipeCollections/" + self.firebaseId!
    Database.database().reference(withPath: recipeCollectionsRefPath)
      .child(recipe.firebaseId).setValue(recipe.convertToJSON())
  }

}
