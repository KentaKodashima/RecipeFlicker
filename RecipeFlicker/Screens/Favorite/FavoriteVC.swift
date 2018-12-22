//
//  FavoriteVC.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-16.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class FavoriteVC: UIViewController {
  
  enum ViewType: Int {
    case list
    case grid
  }
  
  var ref: DatabaseReference!
  var userID: String!
  var selectedCollectionId: String!
  var selectedRecipeId: String?
  var ciContext: CIContext!
  
  @IBOutlet weak var typeSegmentControll: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var toolBar: UIToolbar!
  
  let gridLayout = GridFlowLayout()
  let listLayout = ListFlowLayout()
  
  var favoriteRecipes = [Recipe]()
  var filteredFavoriteRecipes = [Recipe]()
  var collections = [Collection]()
//  var collectionImageDictionary = [String:[String]]()
  var filteredCollections = [Collection]()
  var isAddToMode = false
  var addToView: UIView!
  var indexPathsOfSelectedItems: [Int]?
  
  fileprivate func getFavoriteRecipesFromFirebase(_ userID: String?) {
    ref.child("favorites").child(userID!).observe(.value) { (snapshot) in
      self.favoriteRecipes.removeAll()
      // Read data from firebase
      for child in snapshot.children {
        if let recipe = (child as! DataSnapshot).value as? [String: Any]
        {
          
          let id = recipe["firebaseId"] as! String
          let url = recipe["originalRecipeUrl"] as! String
          let title = recipe["title"] as! String
          let image = recipe["image"] as! String
          let isFavotiteLiteral = recipe["isFavorite"]  as! String
          let whichCollectionToBelongList = List<String>()
          if let whichCollectionToBelong = recipe["whichCollectionToBelong"] {
            for collectionId in whichCollectionToBelong as! NSArray {
              whichCollectionToBelongList.append(collectionId as! String)
            }
          }
          let favoriteRecipe = Recipe(firebaseId: id, originalRecipeUrl: url, title: title, image: image, isFavorite: (isFavotiteLiteral == "true"), whichCollectionToBelong: whichCollectionToBelongList)
          self.favoriteRecipes.append(favoriteRecipe)
        }
      }
      self.filteredFavoriteRecipes = self.favoriteRecipes
      // If there is no favorite recipe in the data base, show 'No data label'
      if self.typeSegmentControll.selectedSegmentIndex == ViewType.list.rawValue
        && self.favoriteRecipes.count <= 0 {
        self.collectionView.setNoDataLabelForCollectionView()
      } else {
        self.collectionView.removeNoDataLabel()
      }
      self.collectionView.reloadData()
    }
  }
  
  fileprivate func getCollectionsFromFirebase(_ userID: String?) {
    ref.child("userCollections").child(userID!).observe(.value) { (snapshot) in
      self.collections.removeAll()
      // Read data from firebase
      for child in snapshot.children {
        if let collectionData = (child as! DataSnapshot).value as? [String: String],
        let id = collectionData["firebaseId"],
        let name = collectionData["name"]
        {
          let image = collectionData["image"]
          let collection = Collection(withId: id, andName: name, andImageUrl: image)
          self.collections.append(collection)
        }
      }
      self.filteredCollections = self.collections
      // If there is no collection in the data base, show 'No data label'
      if self.typeSegmentControll.selectedSegmentIndex == ViewType.grid.rawValue
        && self.collections.count <= 0 {
        self.collectionView.setNoDataLabelForCollectionView()
      } else {
        self.collectionView.removeNoDataLabel()
      }
      self.collectionView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up the search bar
    searchBar.setSearchBar()
    searchBar.delegate = self
    
    // CIContext to darken the image.
    self.ciContext = CIContext(options: nil)
    
    // Set up a keyboard
    self.hideKeyBoard()
    
    // Firebase set up
    ref = Database.database().reference()
    userID = Auth.auth().currentUser?.uid
    getFavoriteRecipesFromFirebase(userID)
    getCollectionsFromFirebase(userID)
    
    // Set up SegmentControll
    typeSegmentControll.tintColor = AppColors.accent.value
    
    // Set up the collectionView and the cell.
    collectionView.collectionViewLayout = listLayout
    collectionView.register(CollectionViewCellForList.self,
                            forCellWithReuseIdentifier: CollectionViewCellForList.reuseIdentifier)
    collectionView.register(CollectionViewCellForGrid.self, forCellWithReuseIdentifier: CollectionViewCellForGrid.reuseIdentifier)
    
    // Edit button
    navigationItem.leftBarButtonItem = editButtonItem
    
    // Toolbar
    toolBar.isHidden = true
    
    // AddToView
    addToView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
  }
  
  @IBAction func onSegmentControlTapped(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case ViewType.list.rawValue:
      navigationItem.leftBarButtonItem = editButtonItem
      changeView(flowLayout: listLayout)
      if favoriteRecipes.count <= 0 {
        collectionView.setNoDataLabelForCollectionView()
      }
      break
    case ViewType.grid.rawValue:
      navigationItem.leftBarButtonItem = nil
      changeView(flowLayout: gridLayout)
      isEditing = false
      if collections.count <= 0 {
       collectionView.setNoDataLabelForCollectionView()
      }
      break
    default:
      break
    }
  }
  
  func changeView(flowLayout: UICollectionViewFlowLayout) {
    self.collectionView.removeNoDataLabel()
    self.collectionView.collectionViewLayout.invalidateLayout()
    if isEditing {
      let indexPaths = collectionView.indexPathsForVisibleItems
      for indexPath in indexPaths {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCellForList
        cell.checkBoxImage.isHidden = true
      }
    }
    self.collectionView.reloadData()
    self.collectionView.setCollectionViewLayout(flowLayout, animated: false)

  }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    collectionView.reloadData()
    collectionView.allowsMultipleSelection = true
    if editing {
      self.editButtonItem.title = "Cancel"
    } else {
      self.toolBar.isHidden = true
      isAddToMode = false
      toggleCollectionView()
    }

  }
  @IBAction func addTo(_ sender: UIBarButtonItem) {
    guard let indexPaths = collectionView.indexPathsForSelectedItems else { return }
    indexPathsOfSelectedItems = indexPaths.map { $0.item }.sorted().reversed()
    isAddToMode = true
    self.searchBar.text = ""
    self.searchBar(searchBar, textDidChange: "")
    toggleCollectionView()
  }
  
  func toggleCollectionView() {
    if isAddToMode {
      self.view.addSubview(addToView)
      let addToCollectionView = UICollectionView(frame: addToView.frame, collectionViewLayout: gridLayout)
      addToCollectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
      addToCollectionView.delegate = self
      addToCollectionView.dataSource = self
      addToCollectionView.register(CollectionViewCellForGrid.self, forCellWithReuseIdentifier: CollectionViewCellForGrid.reuseIdentifier)
      addToView.addSubview(addToCollectionView)
    } else {
      self.addToView.removeFromSuperview()
    }

  }
  
  @IBAction func deleteItems(_ sender: UIBarButtonItem) {
    // update model
    if let indexPaths = collectionView.indexPathsForSelectedItems {
      let indices = indexPaths.map { $0.item }.sorted().reversed()
      for index in indices {
        deleteItemFromFirebase(recipe: filteredFavoriteRecipes[index])
        filteredFavoriteRecipes.remove(at: index)
      }
      // update collectionView
      collectionView.deleteItems(at: indexPaths)
    }
    // dismiss the toolbar
    toolBar.isHidden = true
  }
  
  func deleteItemFromFirebase(recipe: Recipe) {
    // Delete items from favorite
    ref.child("favorites").child(userID).child(recipe.firebaseId).removeValue()
    // Delete items from collections
    for collectionId in recipe.whichCollectionToBelong {
      let ref = Database.database().reference()
      ref.child("recipeCollections/\(collectionId)/\(recipe.firebaseId)").removeValue()
      deleteCollectionIfIsEmpty(collectionId: collectionId)
      changeImageIfItemIsDeleted(deleteRecipe: recipe)
    }
  }
  
  func deleteCollectionIfIsEmpty(collectionId: String) {
    ref.child("recipeCollections").child(collectionId).observe(.value) { (snapshot) in
      if !snapshot.exists() {
        self.ref.child("userCollections").child(self.userID!).child(collectionId).removeValue()
      }
    }
  }
  
  func changeImageIfItemIsDeleted(deleteRecipe:Recipe ) {
    for collection in collections {
      if deleteRecipe.image == collection.image {
        if let id = collection.firebaseId {
          var imageList = [String]()
          ref.child("recipeCollections").child(id).observe(.value) { (snapshot) in
            for child in snapshot.children {
              if let collectionSnapshot = (child as! DataSnapshot).value as? [String:
                Any] {
                let image = collectionSnapshot["image"]
                imageList.append(image as! String)
              }
            }
            
            let imagePath: String = imageList.randomElement() ?? ""
            self.ref.child("userCollections").child(self.userID!)
              .child(collection.firebaseId!).child("image").setValue(imagePath)
          }
        }
      }
    }
  }
  
}

extension FavoriteVC: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if typeSegmentControll.selectedSegmentIndex == ViewType.grid.rawValue || isAddToMode {
      if filteredCollections.count > 0 {
        return filteredCollections.count
      } else {
        return 0
      }

    } else {
      if filteredFavoriteRecipes.count > 0 {
        return filteredFavoriteRecipes.count
      } else {
        return 0
      }

    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if typeSegmentControll.selectedSegmentIndex == ViewType.grid.rawValue || isAddToMode {
      let collection = filteredCollections[indexPath.row]
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CollectionViewCellForGrid.reuseIdentifier,
        for: indexPath)
        as! CollectionViewCellForGrid
      cell.setupContents(withTitle: collection.name, andImage: collection.image, ciContext: ciContext)
      return cell
    } else {
      let recipe = filteredFavoriteRecipes[indexPath.row]
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CollectionViewCellForList.reuseIdentifier,
        for: indexPath)
        as! CollectionViewCellForList
      cell.setupContents(withTitle: recipe.title, andImage: recipe.image)
      cell.toggleEditMode(isEditing: isEditing)
      return cell
    }
  }
  
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if isAddToMode {
      let collection = filteredCollections[indexPath.row]
      // Check if selected items are already belong to the collection.
      if let indices = indexPathsOfSelectedItems {
        for index in indices {
          let recipe = filteredFavoriteRecipes[index]
          if let collectionId = collection.firebaseId {
            if !recipe.whichCollectionToBelong.contains(collectionId) {
              // Add to the collection.
              recipe.whichCollectionToBelong.append(collectionId)
              // Update firebase.
              for id in recipe.whichCollectionToBelong {
                recipe.updateRecipeInCollection(collectionId: id)
              }
              recipe.updateWhichCollectionToBelong(userId: userID)
              collection.updateRecipeCollection(recipe: recipe)
            }
          }
        }
      }
      isAddToMode = false
      isEditing = false
      return
    }
    
    if typeSegmentControll.selectedSegmentIndex == ViewType.list.rawValue {
      if !isEditing {
        let recipe = filteredFavoriteRecipes[indexPath.row]
        selectedRecipeId = recipe.firebaseId
        self.performSegue(withIdentifier: "goToDetail", sender: self.collectionView)
      } else {
        self.toolBar.isHidden = false
      }
      
    } else {
      let collection = filteredCollections[indexPath.row]
      selectedCollectionId = collection.firebaseId
      self.performSegue(withIdentifier: "goToCollection", sender: self.collectionView)
    }
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToCollection" {
      let destVC = segue.destination as! CollectionVC
      destVC.collectionId = selectedCollectionId
      destVC.userCollections = collections
    } else if segue.identifier == "goToDetail" {
      let destVC = segue.destination as! DetailVC
      destVC.recipeId = selectedRecipeId
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if isEditing {
      if let indexPaths = collectionView.indexPathsForSelectedItems, indexPaths.count == 0 {
        self.toolBar.isHidden = true
      }
    }
  }
}

extension FavoriteVC: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    // Check if the text field in the seachBar is empty
    if searchText.isEmpty {
      filteredFavoriteRecipes = favoriteRecipes
      filteredCollections = collections
      self.collectionView.reloadData()
    } else {
      filteredFavoriteRecipes = favoriteRecipes.filter({ (recipe: Recipe) -> Bool in
        return recipe.title.lowercased().contains(searchText.lowercased())
      })
      filteredCollections = collections.filter({ (collection: Collection) -> Bool in
        return collection.name.lowercased().contains(searchText.lowercased())
      })
      self.collectionView.reloadData()
    }
  }
}

extension FavoriteVC {
  func hideKeyBoard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(FavoriteVC.dismissKeyBoard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    
  }
  
  @objc func dismissKeyBoard() {
    view.endEditing(true)
  }
}


