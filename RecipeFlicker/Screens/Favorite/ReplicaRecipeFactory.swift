//
//  ReplicaRecipeFactory.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-30.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation

class ReplicaRecipeFactory {
  public var recipes: [ReplicaRecipe]
  
  init() {
    recipes = [ReplicaRecipe]()
//    recipes = generateRecipes() + generateRecipes()
  }
  
  private func generateRecipes() -> [ReplicaRecipe] {
    var newRecipes = [ReplicaRecipe]()
    let category = ["Vietnameese", "Italian", "Japanese", "Chinese", "Korean", "Spanish"]
    for i in 0..<6 {
      if i % 3 == 0 {
        newRecipes.append(ReplicaRecipe(
          title: "Recipe Title",
          image: "nil",
          whichCollectionToBelong: category[i] ))
      }
      newRecipes.append(ReplicaRecipe(
        title: "Recipe Title",
        image: "food" + String(i + 1),
        whichCollectionToBelong: category[i] ))
    }
    return newRecipes
  }
}
