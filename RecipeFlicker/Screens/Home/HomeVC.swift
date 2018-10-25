//
//  ViewController.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-15.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Koloda

class HomeVC: UIViewController {

  @IBOutlet weak var kolodaView: KolodaView!
  private var recipes = [Recipe]()
  private var recipeAPI = RecipeAPI()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    kolodaView.dataSource = self
    recipeAPI.getRandomRecipes { recipeArray, error in
      for recipe in recipeArray! {
        self.recipes.append(recipe)
        self.kolodaView.reloadData()
      }
    }
  }
}

extension HomeVC: KolodaViewDataSource {
  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return recipes.count
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    let card = CardView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    let recipe = recipes[index]
    let imageUrl = URL(string: recipe.image)!
    let session = URLSession(configuration: .default)
    let downloadTask = session.dataTask(with: imageUrl) { (data, response, error) in
      if let e = error {
        print("Something went wrong.")
      } else {
        if let res = response as? HTTPURLResponse, let imageData = data {
          card.cardImage.image = UIImage(data: imageData)
        }
      }
    }
    downloadTask.resume()
    card.recipeTitle.text = recipe.title
    
    return card
  }
  
  
}
