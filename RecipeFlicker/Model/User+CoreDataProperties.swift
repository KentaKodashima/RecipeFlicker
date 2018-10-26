//
//  User+CoreDataProperties.swift
//  RecipeFlicker
//
//  Created by Kenta Kodashima on 2018-10-25.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var userId: String?

}
