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
    recipes = generateRecipes() + generateRecipes()
  }
  
  private func generateRecipes() -> [ReplicaRecipe] {
    var newRecipes = [ReplicaRecipe]()
    let category = ["Spanish", "Vietnameese", "Italian", "Japanese", "Chinese", "Korean"]
    for i in 0..<6 {
      newRecipes.append(ReplicaRecipe(
        title: "Recipe Title",
        image: "food" + String(i + 1),
        whichCollectionToBelong: category[i] ))
    }
    return newRecipes
  }
}
