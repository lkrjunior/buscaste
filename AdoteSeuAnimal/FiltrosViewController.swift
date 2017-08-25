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
    
    @IBAction func btnAdicionarClick(_ sender: Any)
    {
        self.showAdicionar()
    }
    
    var carregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var idPessoa : Int = 0
    var totalItens : Int = 0
    var genero : [String] = [String]()
    var idadeMin : [Int] = [Int]()
    var idadeMax : [Int] = [Int]()
    var pesoMin : [Double] = [Double]()
    var pesoMax : [Double] = [Double]()
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
        pesoMin = [Double]()
        pesoMax = [Double]()
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
                            self.pesoMin.append(Util.JSON_RetornaDouble(dict: dict, campo: "pesoMin"))
                            self.pesoMax.append(Util.JSON_RetornaDouble(dict: dict, campo: "pesoMax"))
                            
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
    
    func showAdicionar(idFiltro : Int = 0)
    {
        let view = self.storyboard?.instantiateViewController(withIdentifier:"FiltrosSalvarSid") as! FiltrosSalvarViewController
        view.idPessoa = self.idPessoa
        view.idFiltro = idFiltro
        if (idFiltro > 0)
        {
            view.carregarDados = true
        }
        self.present(view, animated: true, completion: nil)
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
        Util.AjustaLayoutCell(view: cell)
        
        cell.lblGenero.text = genero[indexPath.row]
        cell.lblIdade.text = "Idade: " + String(idadeMin[indexPath.row]) + " a " + String(idadeMax[indexPath.row])
        cell.lblPeso.text = "Peso: " + String(pesoMin[indexPath.row]) + " a " + String(pesoMax[indexPath.row])
        
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalItens
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
            print("Deletar " + String(self.id[indexPath.row]))
            self.Deletar(idFiltro: self.id[indexPath.row])
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Editar") { (action, indexPath) in
            print("Editar " + String(self.id[indexPath.row]))
            self.Editar(idFiltro: self.id[indexPath.row])
        }
        
        share.backgroundColor = UIColor.blue
        
        return [delete, share]
    }

    func Deletar(idFiltro : Int)
    {}
    
    func Editar(idFiltro : Int)
    {}
    
}
