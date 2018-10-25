//
//  GridFlowLayout.swift
//  RecipeFlicker
//
//  Created by minami on 2018-10-25.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {
  
  let itemHeight: CGFloat  = 160
  
  func itemWidth() -> CGFloat {
    return (collectionView!.frame.width - 30) / 2
  }
  
  func setUpLayout() {
    minimumInteritemSpacing = 1
    minimumLineSpacing = 1
    scrollDirection = .vertical
  }
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUpLayout()
    fatalError("init(coder:) has not been implemented")
  }
  
  override var itemSize: CGSize {
    set {
      self.itemSize = CGSize(width: itemWidth(), height: itemHeight)
    }
    get {
      return CGSize(width: itemWidth(), height: itemHeight)
    }
  }
  
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
    return collectionView!.contentOffset
  }

}
