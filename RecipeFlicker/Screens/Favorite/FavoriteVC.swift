//
//  FavoriteVC.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-16.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {
  
  enum ViewType {
    case grid
    case list
  }
  
  @IBOutlet weak var typeSegmentControll: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let gridLayout = GridFlowLayout()
  let listLayout = ListFlowLayout()
  
  let recipeFactory = ReplicaRecipeFactory()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.collectionViewLayout = gridLayout
    
  }
  
  @IBAction func onSegmentControlTapped(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case ViewType.grid.hashValue:
      changeView(flowLayout: gridLayout)
      break
    case ViewType.list.hashValue:
      changeView(flowLayout: listLayout)
      break
    default:
      break
    }
  }
  
  func changeView(flowLayout: UICollectionViewFlowLayout) {
    UIView.animate(withDuration: 0.2) {
      self.collectionView.collectionViewLayout.invalidateLayout()
      self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
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
    <#code#>
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    <#code#>
  }
  
  
}
