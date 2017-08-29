//
//  Combos+CoreDataProperties.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 28/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import Foundation
import CoreData


extension Combos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Combos> {
        return NSFetchRequest<Combos>(entityName: "Combos")
    }

    @NSManaged public var data: String?
    @NSManaged public var json: String?

}
