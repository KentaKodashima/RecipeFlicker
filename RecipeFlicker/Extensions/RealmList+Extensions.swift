//
//  RealmList+Extensions.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-24.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import RealmSwift

extension List {
  func toArray<T>(ofType: T.Type) -> [T] {
    let array = Array(self) as! [T]
    return array
  }
}
