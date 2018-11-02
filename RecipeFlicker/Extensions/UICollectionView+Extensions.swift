//
//  UICollectionView+Extensions.swift
//  Amtrip
//
//  Created by Kenta Kodashima on 2018-10-11.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
  public func setNoDataLabelForCollectionView() {
    let labelWidth = self.bounds.size.width
    let labelHeight = self.bounds.size.height
    let noDataLabel = UILabel(
      frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
    )
    noDataLabel.text = "There are no pages yet."
    noDataLabel.textColor = AppColors.appText.value
    noDataLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 18)
    noDataLabel.textAlignment = .center
    self.backgroundView = noDataLabel
  }
}
