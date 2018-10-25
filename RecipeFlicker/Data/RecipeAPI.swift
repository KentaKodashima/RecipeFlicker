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
  private let BASE_SEARCH_URL = "https://api.edamam.com/search?"
  private let APP_ID = "&app_id=64e158b2"
  private let APP_KEY = "&app_key=7826daf17b47075ec9f3c74964f2ed8d"
  private let DEFAULT_QUERY_PARAM = "q=food"
  private var REQUEST_STRING: String {
    return BASE_SEARCH_URL + DEFAULT_QUERY_PARAM + APP_ID + APP_KEY
  }
  
  func getRandomRecipes(completionHandler: @escaping ([Recipe]?, Error?) -> ()) {
    var randomRecipes = [Recipe]()
    let randomNum = arc4random_uniform(500) + 15
//    let toParam = "&to=15"
//    let fromParam = "&from=0"
//    let toParam = "&to=\(randomNum)"
//    let fromParam = "&from=\(randomNum - 15)"
    let requestString = REQUEST_STRING// + fromParam + toParam
    
    Alamofire.request(requestString)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success(let value):
          let json = JSON(value)
          for result in json["hits"].arrayValue {
            var recipe = result["recipe"]
            let idFromAPI = recipe["uri"].stringValue
            let originalRecipeUrl = recipe["url"].stringValue
            let title = recipe["label"].stringValue
            let image = recipe["image"].stringValue
            var recipeObj = Recipe(idFromAPI: idFromAPI, originalRecipeUrl: originalRecipeUrl, title: title, image: image, isFavorite: false)
            randomRecipes.append(recipeObj)
          }
          completionHandler(randomRecipes, nil)
        case .failure(let error):
          completionHandler(nil, error)
        }
      }
  }
}
