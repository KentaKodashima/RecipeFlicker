//
//  API.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-16.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct RecipeAPI {
  private let BASE_SEARCH_URL = "https://api.edamam.com/search"
  private let APP_ID = "&app_id=64e158b2"
  private let APP_KEY = "&app_key=7826daf17b47075ec9f3c74964f2ed8d"
  var REQUEST_STRING: String {
    return BASE_SEARCH_URL + APP_ID + APP_KEY
  }
  
  func getRandomRecipes() -> [Recipe] {
    var randomRecipes = [Recipe]()
    let randomNum = arc4random_uniform(200000) + 15
    let toParam = "&to=\(randomNum)"
    let fromParam = "&from=\(randomNum - 15)"
    let requestString = REQUEST_STRING + toParam + fromParam
    
    Alamofire.request(requestString)
      .validate()
      .responseJSON { response in
        guard response.result.isSuccess else { return }
        guard let value = response.result.value else { return }
        let json = JSON(value)
        let idFromAPI = json["uri"].stringValue
        let originalRecipeUrl = json["url"].stringValue
        let title = json["label"].stringValue
        let image = json["image"].stringValue
        
        let recipe = Recipe(idFromAPI: idFromAPI, originalRecipeUrl: originalRecipeUrl, title: title, image: image)
        randomRecipes.append(recipe)
      }
    return randomRecipes
  }
}
