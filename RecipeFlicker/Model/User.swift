//
//  User.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-11-01.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

@objcMembers class RLMUser: Object {
  @objc dynamic public var userId = ""
  @objc dynamic public var isFirstSignIn = false
  public var recipesOfTheDay = List<Recipe>()
  
  convenience init(userId: String) {
    self.init()
    self.userId = userId
  }
}

extension RLMUser {
  static func all(in realm: Realm = try! Realm()) -> Results<RLMUser> {
    return realm.objects(RLMUser.self)
  }
}
