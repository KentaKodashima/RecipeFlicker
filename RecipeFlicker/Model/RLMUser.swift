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
  
  enum Property: String {
    case userId, realmId
  }
  
  @objc dynamic private(set) var realmId = UUID().uuidString
  @objc dynamic public var userId = ""
  @objc dynamic public var isFirstSignIn = true
  @objc dynamic public var lastFetchTime: Date? = nil
  public var recipesOfTheDay = List<Recipe>()
  
  convenience init(userId: String) {
    self.init()
    self.userId = userId
  }
  
  override static func primaryKey() -> String? {
    return Recipe.Property.realmId.rawValue
  }
}

extension RLMUser {
  static func all(in realm: Realm = try! Realm()) -> Results<RLMUser> {
    return realm.objects(RLMUser.self)
  }
}
