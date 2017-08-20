//
//  MeusAnimaisViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 19/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class MeusAnimaisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableMeusAnimais: UITableView!
    var carregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var idPessoa : Int = 0
    var nomePessoa : String = ""
    var telefonePessoa : String = ""
    var emailPessoa : String = ""
    var totalItens : Int = 0
    var nome : [String] = [String]()
    var genero : [String] = [String]()
    var descricao : [String] = [String]()
    
    @IBAction func btnAdicionarClick(_ sender: Any)
    {
        self.showAdicionar()
    }
    
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
        self.carrega(inicio: true)
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/Animal/GetAnimal?idTipo=1&idCadastro=" + String(idPessoa), method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
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
                            //let dict = Util.converterParaDictionary(text: listaObj)
                            var listaDic = dict as Dictionary
                            
                            let nomeAnimal = dict["nome"] as! String?
                            let descricao = dict["descricao"] as! String?
                            
                            
                            if !(listaDic["genero"] is NSNull)
                            {
                                let generoObj = dict["genero"] as? [String : AnyObject]
                                self.genero.append(generoObj?["genero"] as! String)
                            }
                            else
                            {
                                self.genero.append("")
                            }
                        
                            if (nomeAnimal != nil)
                            {
                                self.nome.append(nomeAnimal!)
                            }
                            else
                            {
                                self.nome.append("")
                            }
                        
                            if (descricao != nil)
                            {
                                self.descricao.append(descricao!)
                            }
                            else
                            {
                                self.descricao.append("")
                            }
                        }
                        self.tableMeusAnimais.reloadData()
                        self.carrega(inicio: false)
                    }
                }
            }
    }
    
    func showAdicionar()
    {
        let view = self.storyboard?.instantiateViewController(withIdentifier:"MeusAnimaisSalvar") as! MeusAnimaisSalvarViewController
        view.idPessoa = self.idPessoa
        view.telefonePessoa = self.telefonePessoa
        view.emailPessoa = self.emailPessoa
        self.present(view, animated: true, completion: nil)
    }
    
    func GetDadosBD()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let requisicao = NSFetchRequest<Usuario>(entityName : "Usuario")
        
        do
        {
            idPessoa = 0
            let usuario = try context.fetch(requisicao)
            if usuario.count > 0
            {
                idPessoa = Int(usuario[0].idUsuario)
                nomePessoa = usuario[0].nome!
                telefonePessoa = usuario[0].telefone!
                emailPessoa = usuario[0].email!
            }
        }
        catch
        {
            print("Erro ao ler os dados do banco de dados")
        }

    }
    
    func carrega(inicio: Bool)
    {
        if inicio == true
        {
            carregamento.center = self.view.center
            carregamento.hidesWhenStopped = true
            carregamento.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            self.view.addSubview(carregamento)
            carregamento.startAnimating()
        }
        else
        {
            carregamento.stopAnimating()
        }
    }

    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMeusAnimais", for: indexPath) as! MeusAnimaisTableViewCell
        cell.lblDescricao.text = "teste"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.Ajusta()
        cell.lblNome.text = nome[indexPath.row]
        cell.lblGenero.text = genero[indexPath.row]
        cell.lblDescricao.text = descricao[indexPath.row]
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("2")
        return totalItens
    }

}
