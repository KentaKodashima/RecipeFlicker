//
//  CollectionVC.swift
//  RecipeFlicker
//
//  Created by minami on 2018-11-11.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class CollectionVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var ref: DatabaseReference!
  @IBOutlet weak var editButton: UIBarButtonItem!
  
  var collectionID: String?
  
  private var collectionRecipes = [Recipe]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self

    registerTableViewCells()
    
    ref = Database.database().reference()
    getCollectionRecipes(collectionID: collectionID)
  }
  
  func registerTableViewCells() {
    let recipeListTableViewCell = UINib(nibName: "RecipeListTableViewCell", bundle: nil)
    tableView.register(recipeListTableViewCell, forCellReuseIdentifier: "RecipeListTableViewCell")
  }
  
  func getCollectionRecipes(collectionID: String?) {
    ref.child("recipeCollections").child(collectionID!).observe(.value) { (snapshot) in
      self.collectionRecipes.removeAll()
      for child in snapshot.children {
        if let recipe = (child as! DataSnapshot).value as? [String: String] {
          let id = recipe["firebaseId"]
          let url = recipe["originalRecipeUrl"]
          let title = recipe["title"]
          let image = recipe["image"]
          let isFavotiteLiteral = recipe["isFavorite"]
          let whichCollectionToBelong = recipe["whichCollectionToBelong"]
          let recipe = Recipe(firebaseId: id!, originalRecipeUrl: url!, title: title!, image: image!, isFavorite: (isFavotiteLiteral == "true"), whichCollectionToBelong: whichCollectionToBelong)
          self.collectionRecipes.append(recipe)
        }
        
      }
      if self.collectionRecipes.count <= 0 {
        self.tableView.setNoDataLabelForTableView()
      }
      self.tableView.reloadData()
    }
  }
  
  
  @IBAction func onEditButtonClicked(_ sender: UIBarButtonItem) {
  }
  
}

extension CollectionVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("count \(collectionRecipes.count)")
    return collectionRecipes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeListTableViewCell") as! RecipeListTableViewCell
    let recipe = collectionRecipes[indexPath.row]
    print(cell)
    let imageUrl = URL(string: recipe.image)
    cell.recipeImage.kf.setImage(with: imageUrl)
    cell.recipeImage.layer.cornerRadius = cell.recipeImage.frame.size.width * 0.1
    cell.recipeImage.clipsToBounds = true
    cell.recipeTitle.text = recipe.title
    cell.tintColor = #colorLiteral(red: 0.9473584294, green: 0.5688932538, blue: 0, alpha: 1)
    return cell
  }
  
}
