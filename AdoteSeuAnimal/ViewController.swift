//
//  ViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 27/05/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var carregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var tableViewAnimal: UITableView!
    
    var totalAnimal : Int = 0
    var animalTipoArray = [Int]()
    var idArray = [Int]()
    var animal = [String]()
    var dataA = [String]()
    var genero = [String]()
    var raca = [String]()
    var descricao = [String]()
    
    func carrega(inicio: Bool)
    {
        if inicio == true
        {
            carregamento.center = self.view.center
            carregamento.hidesWhenStopped = true
            carregamento.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            self.view.addSubview(carregamento)
            carregamento.startAnimating()
            //UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else
        {
            carregamento.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSLog("viewDidLoad")
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.GetDadosAnimal()
        
    }
    
    func readJSONObjectAnimal(object: [String: AnyObject]) {
        guard let lista = object["lista"] as? [[String: AnyObject]] else
        { return }
        totalAnimal = lista.count

        for listaObj in lista {
            guard let animalTipo = listaObj["animalTipoInt"] as? Int else { return }
            guard let id = listaObj["id"] as? Int else { return }
            guard let data = listaObj["dataFormatada"] as? String else { return }
            guard let desc = listaObj["descricao"] as? String else { break }
            
            var listaDic = listaObj as Dictionary
            if !(listaDic["genero"] is NSNull)
            {
                guard let generoObj = listaObj["genero"] as? [String : AnyObject] else { break }
                genero.append(generoObj["genero"] as! String)
            }
            else
            {
                genero.append("")
            }
            
            if !(listaDic["raca"] is NSNull)
            {
                guard let racaObj = listaObj["raca"] as? [String : AnyObject] else { break }
                raca.append(racaObj["raca"] as! String)
            }
            else
            {
                raca.append("")
            }
            
            if animalTipo == 1
            {
                animal.append("Animal para doação")
            }
            else
            {
                animal.append("Animal abandonado")
            }
            
            dataA.append(data)
            descricao.append(desc)
            animalTipoArray.append(animalTipo)
            idArray.append(id)
        }
    }

    func GetDadosAnimal()
    {
        self.carrega(inicio: true)
        var request = URLRequest(url: URL(string: "http://lkrjunior-com.umbler.net/api/Animal/GetAnimal")!)
        request.httpMethod = "GET"
        //var timeoutPadrao = request.timeoutInterval
        request.timeoutInterval = 90
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
   
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    self.readJSONObjectAnimal(object: dictionary)
                    DispatchQueue.main.async() {
                        self.tableViewAnimal.delegate = self
                        self.tableViewAnimal.dataSource = self
                        self.tableViewAnimal.reloadData()
                        self.carrega(inicio: false)
                    }
                }
            } catch {
                // Handle Error
            }
            
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellLinhaDoTempo", for: indexPath) as! CustomTableViewCell
        if animal.count > 0
        {
            let myColor : CGColor = UIColor.darkText.cgColor
            cell.contentView.layer.borderColor = myColor
            cell.contentView.layer.borderWidth = 2;
            
            cell.lblAnimal.text = animal[indexPath.row]
            cell.lblData.text = dataA[indexPath.row]
            cell.lblGenero.text = "Genero: " + (genero[indexPath.row] == "" ? "não identificado" : genero[indexPath.row])
            cell.lblRaca.text = "Raça: " + (raca[indexPath.row] == "" ? "não identificada" : raca[indexPath.row])
            cell.lblDesricao.text = "Descrição: " + descricao[indexPath.row]
        }
        
        NSLog("1")
        return cell
        
    }

    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("2")
        return totalAnimal
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueDetalheAnimal"
        {
            let destino = segue.destination as! DetalheViewController
            let indexPath = self.tableViewAnimal.indexPathForSelectedRow
            
            destino.nome = descricao[(indexPath?.row)!]
            destino.tipoAnimal = animalTipoArray[(indexPath?.row)!]
            destino.idAnimal = idArray[(indexPath?.row)!]
            
            
            NSLog("prepareForSegue")
        }
        
    }

}

