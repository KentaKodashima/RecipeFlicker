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

  let kolodaView = KolodaView()
  private var recipes = [Recipe]()
  private var recipeAPI = RecipeAPI()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    kolodaView.dataSource = self
    setKolodaView()
    // cache image
    recipeAPI.getRandomRecipes { recipeArray, error in
      for recipe in recipeArray! {
        self.recipes.append(recipe)
      }
      self.kolodaView.reloadData()
    }
  }
  
  fileprivate func setKolodaView() {
    let kolodaViewWidth = self.view.bounds.width * 0.9
    let kolodaViewHeight = self.view.bounds.height * 0.4
    kolodaView.frame = CGRect(x: 0, y: 0, width: kolodaViewWidth, height: kolodaViewHeight)
    kolodaView.center = self.view.center
    kolodaView.layer.cornerRadius = 20
    kolodaView.layer.shadowColor = UIColor.gray.cgColor
    kolodaView.layer.shadowOffset = CGSize.zero
    kolodaView.layer.shadowOpacity = 1.0
    kolodaView.layer.shadowRadius = 7.0
    kolodaView.layer.masksToBounds =  false
    self.view.addSubview(kolodaView)
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
    
    if let imageData = try? Data(contentsOf: imageUrl) {
      card.cardImage.image = UIImage(data: imageData)
    }
    card.recipeTitle.text = recipe.title
    
    return card
  }
  
  
}
