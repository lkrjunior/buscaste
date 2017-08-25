//
//  Util.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 14/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
    
    static func carrega(carregamento: UIActivityIndicatorView, view: UIViewController, inicio: Bool)
    {
        if inicio == true
        {
            carregamento.center = view.view.center
            carregamento.hidesWhenStopped = true
            carregamento.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.view.addSubview(carregamento)
            carregamento.startAnimating()
        }
        else
        {
            carregamento.stopAnimating()
        }
    }

    static func GetDadosBD_Usuario() -> [Usuario]
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requisicao = NSFetchRequest<Usuario>(entityName : "Usuario")
        
        do
        {
            let usuario = try context.fetch(requisicao)
            return usuario
        }
        catch
        {
            print("Erro ao ler os dados do banco de dados")
            return [Usuario]()
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
    
    static func JSON_RetornaDouble(dict: Dictionary<String, AnyObject>, campo : String) -> Double
    {
        let obj = dict[campo] as AnyObject?
        if !(obj is NSNull)
        {
            let double = dict[campo] as! Double?
            return double!
        }
        else
        {
            return 0
        }
    }
    
    static func JSON_RetornaInt(dict: Dictionary<String, AnyObject>, campo : String) -> Int
    {
        let obj = dict[campo] as AnyObject?
        if !(obj is NSNull)
        {
            let int = dict[campo] as! Int?
            return int!
        }
        else
        {
            return 0
        }
    }
    
    static func JSON_RetornaString(dict: Dictionary<String, AnyObject>, campo : String) -> String
    {
        let obj = dict[campo] as AnyObject?
        if !(obj is NSNull)
        {
            let string = dict[campo] as! String?
            return string!
        }
        else
        {
            return ""
        }
    }
    
    static func JSON_RetornaStringInterna(dict: Dictionary<String, AnyObject>, objeto: String, campo : String) -> String
    {
        if !(dict[objeto] is NSNull)
        {
            let obj = dict[objeto] as? [String : AnyObject]
            let interno = obj?[campo] as AnyObject!
            if !(interno is NSNull)
            {
                let string = obj?[campo] as! String
                return string
            }
            else
            {
                return ""
            }
        }
        else
        {
            return ""
        }
    }
    
    static func JSON_RetornaIntInterna(dict: Dictionary<String, AnyObject>, objeto: String, campo : String) -> Int
    {
        if !(dict[objeto] is NSNull)
        {
            let obj = dict[objeto] as? [String : AnyObject]
            let interno = obj?[campo] as AnyObject!
            if !(interno is NSNull)
            {
                let int = obj?[campo] as! Int
                return int
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 0
        }
    }
    
    static func JSON_RetornaObjInterna(dict: Dictionary<String, AnyObject>, objeto: String, campo : String) -> [String : AnyObject]
    {
        if !(dict[objeto] is NSNull)
        {
            let obj = dict[objeto] as? [String : AnyObject]
            let interno = obj?[campo] as AnyObject!
            if !(interno is NSNull)
            {
                let obj = obj?[campo] as! [String : AnyObject]
                return obj
            }
            else
            {
                return [String : AnyObject]()
            }
        }
        else
        {
            return [String : AnyObject]()
        }
    }
    
    static func AjustaLayoutCell(view : UITableViewCell)
    {
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
    }
    
}
