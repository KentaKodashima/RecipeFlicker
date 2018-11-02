//
//  FavoriteVC.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-16.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {
  
  enum ViewType: Int {
    case list
    case grid
    
    
  }
  
  @IBOutlet weak var typeSegmentControll: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let gridLayout = GridFlowLayout()
  let listLayout = ListFlowLayout()
  
  let recipeFactory = ReplicaRecipeFactory()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    typeSegmentControll.tintColor = AppColors.accent.value
    if recipeFactory.recipes.count > 0 {
      collectionView.collectionViewLayout = listLayout
      collectionView.register(CollectionViewCellForList.self,
                              forCellWithReuseIdentifier: CollectionViewCellForList.reuseIdentifier)
      collectionView.register(CollectionViewCellForGrid.self, forCellWithReuseIdentifier: CollectionViewCellForGrid.reuseIdentifier)
    } else {
      collectionView.setNoDataLabelForCollectionView()
    }
    
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
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension FavoriteVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recipeFactory.recipes.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let recipe = recipeFactory.recipes[indexPath.row]
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
