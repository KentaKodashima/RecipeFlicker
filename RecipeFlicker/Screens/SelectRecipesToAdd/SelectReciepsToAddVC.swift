//
//  SelectReciepsToAddVC.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-03.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import Kingfisher

class SelectReciepsToAddVC: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var recipeTableView: UITableView!
  
  // MARK: - Properties
  public var collectionName: String?
  
  private var userRef: DatabaseReference!
  private var userId: String!
  private let realm = try! Realm()
  private var rlmUser: RLMUser! {
    didSet {
      userId = rlmUser.userId
    }
  }
  private var favoriteRecipes = [Recipe]()
  private var doneButton: UIBarButtonItem!
  
  // MARK: - View controller life-cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Fetch existing user from Realm
    rlmUser = RLMUser.all().first
    
    // Reference in Firebase
    userRef = Database.database().reference()
    
    setRightBarButton()
    registerTableViewCells()
    getFavoriteRecipes()
    
    recipeTableView.allowsMultipleSelectionDuringEditing = true
    recipeTableView.setEditing(true, animated: false)
  }
  
  // MARK: - Actions
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    recipeTableView.setEditing(editing, animated: animated)
  }
  
  fileprivate func setRightBarButton() {
    doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    doneButton.isEnabled = false
    navigationItem.rightBarButtonItem = doneButton
  }
  
  @objc fileprivate func doneButtonTapped() {
    var collectionItems = [Recipe]()
    let userID = Auth.auth().currentUser?.uid
    if let indexPaths = recipeTableView.indexPathsForSelectedRows, let collectionName = self.collectionName {
      for indexPath in indexPaths {
        collectionItems.append(favoriteRecipes[indexPath.row])
      }
      var collection = Collection(collectionName: collectionName, recipes: collectionItems)
      collection.saveToFirebase(userId: userID!)
    }
    navigationController?.popToRootViewController(animated: true)
  }
  
  func registerTableViewCells() {
    let recipeListTableViewCell = UINib(nibName: "RecipeListTableViewCell", bundle: nil)
    recipeTableView.register(recipeListTableViewCell, forCellReuseIdentifier: "RecipeListTableViewCell")
  }
  
  func getFavoriteRecipes() {
    let userID = Auth.auth().currentUser?.uid
    userRef.child("favorites").child(userID!).observe(.value) { (snapshot) in
      self.favoriteRecipes.removeAll()
      for child in snapshot.children {
        if let recipe = (child as! DataSnapshot).value as? [String: String] {
          let id = recipe["firebaseId"]
          let url = recipe["originalRecipeUrl"]
          let title = recipe["title"]
          let image = recipe["image"]
          let isFavotiteLiteral = recipe["isFavorite"]
          let whichCollectionToBelong = recipe["whichCollectionToBelong"]
          let favoriteRecipe = Recipe(firebaseId: id!, originalRecipeUrl: url!, title: title!, image: image!, isFavorite: (isFavotiteLiteral == "true"), whichCollectionToBelong: whichCollectionToBelong)
          self.favoriteRecipes.append(favoriteRecipe)
        }
      }
      if self.favoriteRecipes.count <= 0 {
        self.recipeTableView.setNoDataLabelForTableView()
      }
      self.recipeTableView.reloadData()
    }
  }
}

extension SelectReciepsToAddVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    toggleDoneButton()
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    toggleDoneButton()
  }
  
  fileprivate func toggleDoneButton() {
    if recipeTableView.indexPathsForSelectedRows == nil {
      doneButton.isEnabled = false
    } else {
      doneButton.isEnabled = true
    }
  }
}

extension SelectReciepsToAddVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteRecipes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeListTableViewCell") as! RecipeListTableViewCell
    let recipe = favoriteRecipes[indexPath.row]
    let imageUrl = URL(string: recipe.image)
    cell.recipeImage.kf.setImage(with: imageUrl)
    cell.recipeTitle.text = recipe.title
    cell.accessoryType = .checkmark
    
    return cell
  }
}
