//
//  Configuracoes+CoreDataProperties.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 08/10/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import Foundation
import CoreData


extension Configuracoes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Configuracoes> {
        return NSFetchRequest<Configuracoes>(entityName: "Configuracoes")
    }

    @NSManaged public var tokenFacebook: String?

}
