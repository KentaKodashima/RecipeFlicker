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
  var isEditingMode: Bool = false
  var collectionId: String?
  var userId: String?
  
  private var collectionRecipes = [Recipe]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self

    registerTableViewCells()
    
    ref = Database.database().reference()
    userId = Auth.auth().currentUser?.uid
    getCollectionRecipes(collectionId: collectionId)
  }
  
  func registerTableViewCells() {
    let recipeListTableViewCell = UINib(nibName: "RecipeListTableViewCell", bundle: nil)
    tableView.register(recipeListTableViewCell, forCellReuseIdentifier: "RecipeListTableViewCell")
  }
  
  func getCollectionRecipes(collectionId: String?) {
    ref.child("recipeCollections").child(collectionId!).observe(.value) { (snapshot) in
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
    isEditingMode = !isEditingMode
    tableView.setEditing(isEditingMode, animated: true)
    
  }
  
  func deleteDataFromFirebase(recipeId: String) {
    ref.child("recipeCollections").child(collectionId!).child(recipeId).removeValue()
    if collectionRecipes.count == 0 {
      ref.child("userCollections").child(userId!).child(collectionId!).removeValue()
    }
  }
}

extension CollectionVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionRecipes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeListTableViewCell") as! RecipeListTableViewCell
    let recipe = collectionRecipes[indexPath.row]
    let imageUrl = URL(string: recipe.image)
    cell.recipeImage.kf.setImage(with: imageUrl)
    cell.recipeImage.layer.cornerRadius = cell.recipeImage.frame.size.width * 0.1
    cell.recipeImage.clipsToBounds = true
    cell.recipeTitle.text = recipe.title
    cell.tintColor = #colorLiteral(red: 0.9473584294, green: 0.5688932538, blue: 0, alpha: 1)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let deleteItem = self.collectionRecipes.remove(at: indexPath.row)
    self.tableView.deleteRows(at: [indexPath], with: .automatic)
    deleteDataFromFirebase(recipeId: deleteItem.firebaseId)
  }
  
}
