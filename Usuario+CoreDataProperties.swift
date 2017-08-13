//
//  Usuario+CoreDataProperties.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 13/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import Foundation
import CoreData


extension Usuario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Usuario> {
        return NSFetchRequest<Usuario>(entityName: "Usuario")
    }

    @NSManaged public var email: String?
    @NSManaged public var idUsuario: Int32
    @NSManaged public var nome: String?
    @NSManaged public var telefone: String?
    @NSManaged public var tokenFacebook: String?

}
