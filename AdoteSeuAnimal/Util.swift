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
    
    static func AlertaView(titulo : String, mensagem : String, view : UIViewController)
    {
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }

    static func AlertaErro(mensagem : String) -> UIAlertController
    {
        let alert = UIAlertController(title: "Erro", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    static func AlertaErroView(mensagem : String, view : UIViewController, indicatorView : UIActivityIndicatorView!)
    {
        let alert = UIAlertController(title: "Erro", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
        if (indicatorView != nil)
        {
            indicatorView.stopAnimating()
        }
    }
    
    static func converterParaDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
