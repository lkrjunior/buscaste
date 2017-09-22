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
import Alamofire

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
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    static func AlertaErroViewValidacao(mensagem : String, textField : UITextField, view : UIViewController, indicatorView : UIActivityIndicatorView!)
    {
        let alert = UIAlertController(title: "Campos obrigatórios", message: mensagem, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            textField.becomeFirstResponder()
        }))
        view.present(alert, animated: true, completion: nil)
        if (indicatorView != nil)
        {
            indicatorView.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    static func carrega(carregamento: UIActivityIndicatorView, view: UIViewController, inicio: Bool)
    {
        if inicio == true
        {
            carregamento.center = view.view.center
            carregamento.hidesWhenStopped = true
            carregamento.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            carregamento.color = UIColor.black
            view.view.addSubview(carregamento)
            carregamento.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            //UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else
        {
            carregamento.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //UIApplication.shared.endIgnoringInteractionEvents()
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
    
    static func GetDadosBD_Combos() -> Combos
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requisicao = NSFetchRequest<Combos>(entityName : "Combos")
        
        do
        {
            let combos = try context.fetch(requisicao)
            if combos.count > 0
            {
                return combos[0]
            }
            else
            {
                return Combos()
            }
        }
        catch
        {
            print("Erro ao ler os dados do banco de dados")
            return Combos()
        }
    }
    
    static func SaveDadosBD_Combos(combos : Combos)
    {
        do
        {
            let combosGet = self.GetDadosBD_Combos()
            if combosGet.data != nil && combosGet.data != ""
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let combosDelete = combosGet as NSManagedObject
                context.delete(combosDelete)
                try context.save()
            
                let combosSave = NSEntityDescription.insertNewObject(forEntityName: "Combos", into: context)
                combosSave.setValue(combos.data, forKey: "data")
                combosSave.setValue(combos.json, forKey: "json")
                try context.save()
            }
        }
        catch
        {
            print("Erro ao salvar os dados do banco de dados")
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
        return [String: AnyObject]()
    }
    
    static func JSON_RetornaDouble(dict: Dictionary<String, AnyObject>, campo : String) -> Double
    {
        let obj = dict[campo] as AnyObject?
        if obj == nil { return 0 }
        
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
        if obj == nil { return 0 }
        
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
        if obj == nil { return "" }
        
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
    
    static func JSON_RetornaObjLista(dict: Dictionary<String, AnyObject>, campo : String) -> [[String: AnyObject]]
    {
        let obj = dict[campo] as AnyObject?
        if obj == nil { return [[String: AnyObject]]() }
        
        if !(obj is NSNull)
        {
            let objInt = dict[campo] as! [[String: AnyObject]]
            return objInt
        }
        else
        {
            return [[String: AnyObject]]()
        }
    }
    
    static func JSON_RetornaStringInterna(dict: Dictionary<String, AnyObject>, objeto: String, campo : String) -> String
    {
        if !(dict[objeto] is NSNull)
        {
            let obj = dict[objeto] as? [String : AnyObject]
            if obj == nil { return "" }
            
            let interno = obj?[campo] as AnyObject!
            if interno == nil { return "" }
            
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
            if obj == nil { return 0 }
            
            let interno = obj?[campo] as AnyObject!
            if interno == nil { return 0 }
            
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
            if obj == nil { return [String : AnyObject]() }
            
            let interno = obj?[campo] as AnyObject!
            if interno == nil { return [String : AnyObject]() }
            
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
    
    static func compressImage_2048 (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 2048.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
    
    static func compressImage_1536 (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 1536.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
    
    static func compressImage_1024 (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 1024.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
    
    static func compressImage_512 (_ image: UIImage) -> UIImage {
        
        let actualHeight:CGFloat = image.size.height
        let actualWidth:CGFloat = image.size.width
        let imgRatio:CGFloat = actualWidth/actualHeight
        let maxWidth:CGFloat = 512.0
        let resizedHeight:CGFloat = maxWidth/imgRatio
        let compressionQuality:CGFloat = 0.5
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData)!
        
    }
    
    static func AddViewForCell(cell : UITableViewCell, table : UITableView)
    {
        let viewForCell: UIView = UIView(frame: CGRect(x:0, y:0, width:table.frame.size.width , height:(cell.contentView.frame.size.height) - 8 ))
        viewForCell.backgroundColor = UIColor(red: 213/255, green: 218/255, blue: 255/255, alpha: 1)
        viewForCell.alpha = 1
        viewForCell.isUserInteractionEnabled = true
        viewForCell.layer.cornerRadius = 10
        viewForCell.layer.masksToBounds = true
        
        viewForCell.layer.shadowColor = UIColor.black.cgColor
        viewForCell.layer.shadowOpacity = 0.8
        viewForCell.layer.shadowOffset = CGSize(width: -5, height: 5)
        viewForCell.layer.shadowRadius = 5
        
        if cell.tag == 0
        {
            cell.contentView.addSubview(viewForCell)
            cell.contentView.sendSubview(toBack: viewForCell)
            cell.tag = 1
        }
    }
    
    static func GetDateAtual() -> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    static func ValidaCampoString(textField : UITextField, mensagem : String, view : UIViewController, indicator : UIActivityIndicatorView) -> Bool
    {
        if (textField.text?.isEmpty)!
        {
            Util.AlertaErroViewValidacao(mensagem: mensagem, textField: textField, view: view, indicatorView: indicator)
            return false
        }
        return true
    }
    
    static func ValidaCampoInt(int : Int, textField : UITextField, mensagem : String, view : UIViewController, indicator : UIActivityIndicatorView) -> Bool
    {
        if int == 0
        {
            Util.AlertaErroViewValidacao(mensagem: mensagem, textField: textField, view: view, indicatorView: indicator)
            return false
        }
        return true
    }
    
    static func CombosGetCache() -> String
    {
        if let listaCombos = UserDefaults.standard.object(forKey: "Combos")
        {
            return listaCombos as! String
        }
        else
        {
            return ""
        }
    }
    
    static func CombosSaveCache(combos : String)
    {
        UserDefaults.standard.set(combos, forKey: "Combos")
        UserDefaults.standard.synchronize()
    }
    
    static func CarregaCombosRequisicao()
    {
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/Combos/GetCombos", method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
            {
                response in
                
                if let erro = response.error
                {
                    if erro.localizedDescription != ""
                    {
                        print(erro.localizedDescription)
                    }
                }
                
                if let data = response.data
                {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Response: \(String(describing: json))")
                    if (json == nil || json == "" || json == "null")
                    {
                        print("Erro ao carregar os dados da lista combos")
                    }
                    else
                    {
                        let listaDict = self.converterParaDictionary(text: json!)
                        let lista = self.JSON_RetornaObjLista(dict: listaDict!, campo: "lista")
                        
                        if lista.count > 0
                        {
                            Util.CombosSaveCache(combos: json!)
                        }
                    }
                }
                else
                {
                    print("Erro ao carregar os dados da lista combos")
                }
        }
    }

    static func FiltrarGet() -> ClassFiltrar
    {
        if let pesquisar = UserDefaults.standard.object(forKey: "fPesquisar")
        {
            let filtros : ClassFiltrar = ClassFiltrar()
            
            let fPesquisar = pesquisar as! Bool
            let fTipoAnimal = UserDefaults.standard.object(forKey: "fTipoAnimal") as! Int
            let fIdGenero = UserDefaults.standard.object(forKey: "fIdGenero") as! Int
            let fIdRaca = UserDefaults.standard.object(forKey: "fIdRaca") as! Int
            let fIdPorte = UserDefaults.standard.object(forKey: "fIdPorte") as! Int
            let fIdUf = UserDefaults.standard.object(forKey: "fIdUf") as! Int
            let fIdCidade = UserDefaults.standard.object(forKey: "fIdCidade") as! Int
            let fIdadeMin = UserDefaults.standard.object(forKey: "fIdadeMin") as! Int
            let fIdadeMax = UserDefaults.standard.object(forKey: "fIdadeMax") as! Int
            let fPesoMin = UserDefaults.standard.object(forKey: "fPesoMin") as! Double
            let fPesoMax = UserDefaults.standard.object(forKey: "fPesoMax") as! Double
            let genero = UserDefaults.standard.object(forKey: "genero") as! String
            let raca = UserDefaults.standard.object(forKey: "raca") as! String
            let porte = UserDefaults.standard.object(forKey: "porte") as! String
            let uf = UserDefaults.standard.object(forKey: "uf") as! String
            let cidade = UserDefaults.standard.object(forKey: "cidade") as! String
            
            filtros.fPesquisar = fPesquisar
            filtros.fTipoAnimal = fTipoAnimal
            filtros.fIdGenero = fIdGenero
            filtros.fIdRaca = fIdRaca
            filtros.fIdPorte = fIdPorte
            filtros.fIdUf = fIdUf
            filtros.fIdCidade = fIdCidade
            filtros.fIdadeMin = fIdadeMin
            filtros.fIdadeMax = fIdadeMax
            filtros.fPesoMin = fPesoMin
            filtros.fPesoMax = fPesoMax
            filtros.genero = genero
            filtros.raca = raca
            filtros.porte = porte
            filtros.uf = uf
            filtros.cidade = cidade
                
            return filtros
        }
        return ClassFiltrar()
    }
    
    static func FiltrarSave(filtros : ClassFiltrar, limpar : Bool)
    {
        if limpar == true
        {
            UserDefaults.standard.set(false, forKey: "fPesquisar")
            UserDefaults.standard.set(0, forKey: "fTipoAnimal")
            UserDefaults.standard.set(0, forKey: "fIdGenero")
            UserDefaults.standard.set(0, forKey: "fIdRaca")
            UserDefaults.standard.set(0, forKey: "fIdPorte")
            UserDefaults.standard.set(0, forKey: "fIdUf")
            UserDefaults.standard.set(0, forKey: "fIdCidade")
            UserDefaults.standard.set(0, forKey: "fIdadeMin")
            UserDefaults.standard.set(0, forKey: "fIdadeMax")
            UserDefaults.standard.set(0, forKey: "fPesoMin")
            UserDefaults.standard.set(0, forKey: "fPesoMax")
            UserDefaults.standard.set("", forKey: "genero")
            UserDefaults.standard.set("", forKey: "raca")
            UserDefaults.standard.set("", forKey: "porte")
            UserDefaults.standard.set("", forKey: "uf")
            UserDefaults.standard.set("", forKey: "cidade")
            UserDefaults.standard.synchronize()
        }
        else
        {
            UserDefaults.standard.set(filtros.fPesquisar, forKey: "fPesquisar")
            UserDefaults.standard.set(filtros.fTipoAnimal, forKey: "fTipoAnimal")
            UserDefaults.standard.set(filtros.fIdGenero, forKey: "fIdGenero")
            UserDefaults.standard.set(filtros.fIdRaca, forKey: "fIdRaca")
            UserDefaults.standard.set(filtros.fIdPorte, forKey: "fIdPorte")
            UserDefaults.standard.set(filtros.fIdUf, forKey: "fIdUf")
            UserDefaults.standard.set(filtros.fIdCidade, forKey: "fIdCidade")
            UserDefaults.standard.set(filtros.fIdadeMin, forKey: "fIdadeMin")
            UserDefaults.standard.set(filtros.fIdadeMax, forKey: "fIdadeMax")
            UserDefaults.standard.set(filtros.fPesoMin, forKey: "fPesoMin")
            UserDefaults.standard.set(filtros.fPesoMax, forKey: "fPesoMax")
            UserDefaults.standard.set(filtros.genero, forKey: "genero")
            UserDefaults.standard.set(filtros.raca, forKey: "raca")
            UserDefaults.standard.set(filtros.porte, forKey: "porte")
            UserDefaults.standard.set(filtros.uf, forKey: "uf")
            UserDefaults.standard.set(filtros.cidade, forKey: "cidade")
            UserDefaults.standard.synchronize()
        }
    }
    
}
