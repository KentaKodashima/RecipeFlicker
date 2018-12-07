//
//  CollectionVC.swift
//  RecipeFlicker
//
//  Created by minami on 2018-11-11.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import Kingfisher

class CollectionVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var ref: DatabaseReference!
  @IBOutlet weak var editButton: UIBarButtonItem!
  var isEditingMode: Bool = false
  var collectionId: String?
  var userId: String?
  var selectedRecipeId: String?
  
  private var collectionRecipes = [Recipe]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    registerTableViewCells()
    
    ref = Database.database().reference()
    userId = Auth.auth().currentUser?.uid
    getCollectionRecipes(collectionId: collectionId)
    
    //    remove separator lines from empty cells.
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  func registerTableViewCells() {
    let recipeListTableViewCell = UINib(nibName: "RecipeListTableViewCell", bundle: nil)
    tableView.register(recipeListTableViewCell, forCellReuseIdentifier: "RecipeListTableViewCell")
  }
  
  func getCollectionRecipes(collectionId: String?) {
    ref.child("recipeCollections").child(collectionId!).observe(.value) { (snapshot) in
      self.collectionRecipes.removeAll()
      for child in snapshot.children {
        if let recipe = (child as! DataSnapshot).value as? [String:Any] {
          let id = recipe["firebaseId"] as! String
          let url = recipe["originalRecipeUrl"] as! String
          let title = recipe["title"] as! String
          let image = recipe["image"] as! String
          let isFavotiteLiteral = recipe["isFavorite"] as! String
          let whichCollectionToBelongList = List<String>()
          if let whichCollectionToBelong = recipe["whichCollectionToBelong"] {
            for collectionId in whichCollectionToBelong as! NSArray {
              whichCollectionToBelongList.append(collectionId as! String)
            }
          }
          let recipe = Recipe(firebaseId: id, originalRecipeUrl: url, title: title, image: image, isFavorite: (isFavotiteLiteral == "true"), whichCollectionToBelong: whichCollectionToBelongList)
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
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
    let recipe = collectionRecipes[indexPath.row]
    selectedRecipeId = recipe.firebaseId
    self.performSegue(withIdentifier: "goToDetail", sender: self.tableView)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let deleteItem = self.collectionRecipes.remove(at: indexPath.row)
    print(deleteItem)
    print(collectionId)
    print(deleteItem.whichCollectionToBelong.index(of: collectionId!))
    if let index = deleteItem.whichCollectionToBelong.index(of: collectionId!) {
      deleteItem.whichCollectionToBelong.remove(at: index)
      print(deleteItem)
      print(deleteItem.whichCollectionToBelong)
      deleteItem.updateWhichCollectionToBelong(userId: userId!)
      for id in deleteItem.whichCollectionToBelong {
        deleteItem.updateRecipeInCollection(collectionId: id)
      }
    }
    self.tableView.deleteRows(at: [indexPath], with: .automatic)
    deleteDataFromFirebase(recipeId: deleteItem.firebaseId)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToDetail" {
      let destVC = segue.destination as! DetailVC
      destVC.recipeId = selectedRecipeId
    }
    
  }
}
