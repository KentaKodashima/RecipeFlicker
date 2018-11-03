//
//  FavoriteVC.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-16.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Firebase

class FavoriteVC: UIViewController {
  
  enum ViewType: Int {
    case list
    case grid
  }
  
  var ref: DatabaseReference!
  
  @IBOutlet weak var typeSegmentControll: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let gridLayout = GridFlowLayout()
  let listLayout = ListFlowLayout()
  
  let recipeFactory = ReplicaRecipeFactory()
  var favoriteRecipes = [Recipe]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    ref.child("favorites").child(userID!).observe(.value) { (snapshot) in
      self.favoriteRecipes.removeAll()
      for child in snapshot.children {
        if let recipe = (child as! DataSnapshot).value as? [String: String],
          let id = recipe["recipeId"],
          let url = recipe["originalRecipeUrl"],
          let title = recipe["title"],
          let image = recipe["image"],
          let isFavotiteLiteral = recipe["isFavorite"],
          let whichCollectionToBelong = recipe["whichCollectionToBelong"] {
          let favoriteRecipe = Recipe(firebaseId: id, originalRecipeUrl: url, title: title, image: image, isFavorite: (isFavotiteLiteral == "true"), whichCollectionToBelong: whichCollectionToBelong)
          self.favoriteRecipes.append(favoriteRecipe)
        }
      }
      if self.favoriteRecipes.count <= 0 {
        self.collectionView.setNoDataLabelForCollectionView()
      }
      self.collectionView.reloadData()
    }
    
    typeSegmentControll.tintColor = AppColors.accent.value
    collectionView.collectionViewLayout = listLayout
    collectionView.register(CollectionViewCellForList.self,
                            forCellWithReuseIdentifier: CollectionViewCellForList.reuseIdentifier)
    collectionView.register(CollectionViewCellForGrid.self, forCellWithReuseIdentifier: CollectionViewCellForGrid.reuseIdentifier)
  }
  
  @IBAction func onSegmentControlTapped(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case ViewType.list.rawValue:
      changeView(flowLayout: listLayout)
      print("list")
      break
    case ViewType.grid.rawValue:
      changeView(flowLayout: gridLayout)
      print("grid")
      break
    default:
      break
    }
  }
  
  func changeView(flowLayout: UICollectionViewFlowLayout) {
    self.collectionView.collectionViewLayout.invalidateLayout()
    self.collectionView.reloadData()
    self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
  }
}

extension FavoriteVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if favoriteRecipes.count > 0 {
      return favoriteRecipes.count
    } else {
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let recipe = favoriteRecipes[indexPath.row]
    if typeSegmentControll.selectedSegmentIndex == ViewType.list.rawValue {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CollectionViewCellForList.reuseIdentifier,
        for: indexPath)
        as! CollectionViewCellForList
      cell.setupContents(withTitle: recipe.title, andImage: recipe.image)
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CollectionViewCellForGrid.reuseIdentifier,
        for: indexPath)
        as! CollectionViewCellForGrid
      cell.setupContents(withTitle: recipe.title, andImage: recipe.image)
      return cell
    }
    
  }
  
  
}
