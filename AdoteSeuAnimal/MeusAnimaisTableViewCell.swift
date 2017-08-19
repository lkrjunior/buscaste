//
//  MeusAnimaisTableViewCell.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 19/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class MeusAnimaisTableViewCell: UITableViewCell {
    
    var idTipo : Int = 0
    var idAnimal : Int = 0
    
    @IBOutlet weak var lblNome: UILabel!

    @IBOutlet weak var lblGenero: UILabel!

    @IBOutlet weak var lblDescricao: UILabel!
    @IBAction func btnEditar(_ sender: Any)
    {
        
    }
    @IBAction func Deletar(_ sender: Any)
    {
        
    }
    
    public func Ajusta()
    {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
    }
}
