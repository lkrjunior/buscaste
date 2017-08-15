//
//  Util.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 14/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import Foundation
import UIKit

class Util
{
    static func Alerta(titulo : String, mensagem : String) -> UIAlertController
    {
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    static func AlertaErro(mensagem : String) -> UIAlertController
    {
        let alert = UIAlertController(title: "Erro", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}
