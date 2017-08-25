//
//  FiltrosViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 22/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class FiltrosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableViewFiltros: UITableView!
    
    var carregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var idPessoa : Int = 0
    var totalItens : Int = 0
    var genero : [String] = [String]()
    var idadeMin : [Int] = [Int]()
    var idadeMax : [Int] = [Int]()
    var pesoMin : [Int] = [Int]()
    var pesoMax : [Int] = [Int]()
    var id : [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.GetDadosBD()
        self.GetDados()
    }

    func GetDados()
    {
        Util.carrega(carregamento: self.carregamento, view: self, inicio: true)
        
        totalItens = 0
        genero = [String]()
        idadeMin = [Int]()
        idadeMax = [Int]()
        pesoMin = [Int]()
        pesoMax = [Int]()
        id = [Int]()
        
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/PessoaFiltro/GetPessoaFiltro?idPessoa=" + String(idPessoa), method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
            {
                response in
                
                if let data = response.data
                {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Response: \(String(describing: json))")
                    if (json == nil || json == "")
                    {
                        Util.AlertaErroView(mensagem: "Erro ao carregar os dados", view: self, indicatorView: self.carregamento)
                    }
                    else
                    {
                        let listaDict = Util.converterParaDictionary(text: json!)
                        let lista = listaDict?["lista"] as? [[String: AnyObject]]
                        
                        self.totalItens = lista!.count
                        
                        for dict in lista!
                        {
                            let listaDic = dict as Dictionary
                            
                            self.id.append(Util.JSON_RetornaInt(dict: dict, campo: "idPessoaFiltro"))
                            self.genero.append(Util.JSON_RetornaStringInterna(dict: listaDic, objeto: "genero", campo: "genero"))
                            self.idadeMin.append(Util.JSON_RetornaInt(dict: dict, campo: "idadeMin"))
                            self.idadeMax.append(Util.JSON_RetornaInt(dict: dict, campo: "idadeMax"))
                            self.pesoMin.append(Util.JSON_RetornaInt(dict: dict, campo: "pesoMin"))
                            self.pesoMax.append(Util.JSON_RetornaInt(dict: dict, campo: "pesoMax"))
                            
                            /*
                            if !(listaDic["genero"] is NSNull)
                            {
                                let generoObj = dict["genero"] as? [String : AnyObject]
                                let generoInterno = generoObj?["genero"] as AnyObject!
                                if !(generoInterno is NSNull)
                                {
                                    let generoString = generoObj?["genero"] as! String
                                    self.genero.append(generoString)
                                }
                                else
                                {
                                    self.genero.append("")
                                }
                            }
                            else
                            {
                                self.genero.append("")
                            }
                            */
                            
                            /*
                            let idadeMin = dict["idadeMin"] as AnyObject?
                            if !(idadeMin is NSNull)
                            {
                                let idadeMinInt = dict["idadeMin"] as! Int?
                                self.idadeMin.append(idadeMinInt!)
                            }
                            else
                            {
                                self.idadeMin.append(0)
                            }
                            */
                        }
                        self.tableViewFiltros.reloadData()
                        Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                    }
                }
        }
    }
    
    func showAdicionar(idAnimal : Int = 0)
    {
        
    }
    
    func GetDadosBD()
    {
        idPessoa = 0
        let usuario = Util.GetDadosBD_Usuario()
        if usuario.count > 0
        {
            idPessoa = Int(usuario[0].idUsuario)
        }
    }

    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFiltros", for: indexPath) as! FiltrosTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalItens
    }

}
