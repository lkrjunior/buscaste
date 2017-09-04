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
    var id : [Int] = [Int]()
    
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
        
        totalItens = 0
        nome = [String]()
        genero = [String]()
        descricao = [String]()
        id = [Int]()

        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/Animal/GetAnimal?idTipo=1&idCadastro=" + String(idPessoa), method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
            {
                response in
                
                if let erro = response.error
                {
                    if erro.localizedDescription != ""
                    {
                        Util.AlertaErroView(mensagem: (response.error?.localizedDescription)!, view: self, indicatorView: self.carregamento)
                    }
                }
            
                if let data = response.data
                {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Response: \(String(describing: json))")
                    if (json == nil || json == "" || json == "null")
                    {
                        Util.AlertaErroView(mensagem: "Erro ao carregar os dados", view: self, indicatorView: self.carregamento)
                    }
                    else
                    {
                        let listaDict = Util.converterParaDictionary(text: json!)
                        let lista = Util.JSON_RetornaObjLista(dict: listaDict!, campo: "lista")
                        
                        self.totalItens = lista.count
                        
                        for dict in lista
                        {
                            //let dict = Util.converterParaDictionary(text: listaObj)
                            _ = dict as Dictionary
                            
                            let idAnimal = Util.JSON_RetornaInt(dict: dict, campo: "id")
                            let nomeAnimal = Util.JSON_RetornaString(dict: dict, campo: "nome")
                            let descricao = Util.JSON_RetornaString(dict: dict, campo: "descricao")
                            let generoDesc = Util.JSON_RetornaStringInterna(dict: dict, objeto: "genero", campo: "genero")
                            
                            self.id.append(idAnimal)
                            self.genero.append(generoDesc)
                            self.nome.append(nomeAnimal)
                            self.descricao.append(descricao)
                        }
                        self.tableMeusAnimais.reloadData()
                        self.carrega(inicio: false)
                    }
                }
                else
                { self.carrega(inicio: false) }
            }
    }
    
    func showAdicionar(idAnimal : Int = 0)
    {
        let view = self.storyboard?.instantiateViewController(withIdentifier:"MeusAnimaisSalvar") as! MeusAnimaisSalvarViewController
        view.idPessoa = self.idPessoa
        view.telefonePessoa = self.telefonePessoa
        view.emailPessoa = self.emailPessoa
        view.idAnimal = idAnimal
        if (idAnimal > 0)
        {
            view.carregarDados = true
        }
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
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        else
        {
            carregamento.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMeusAnimais", for: indexPath) as! MeusAnimaisTableViewCell
        Util.AddViewForCell(cell: cell, table: tableMeusAnimais)
        cell.lblDescricao.text = "teste"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //cell.Ajusta()
        cell.lblNome.text = nome[indexPath.row]
        cell.lblGenero.text = genero[indexPath.row]
        cell.lblDescricao.text = descricao[indexPath.row]
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("2")
        return totalItens
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
            print("Deletar " + String(self.id[indexPath.row]))
            self.DeletarAnimal(idAnimal: self.id[indexPath.row])
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Editar") { (action, indexPath) in
            print("Editar " + String(self.id[indexPath.row]))
            self.EditarAnimal(idAnimal: self.id[indexPath.row])
        }
        
        share.backgroundColor = UIColor.blue
        
        return [delete, share]
    }
    
    func DeletarAnimal(idAnimal : Int)
    {
        let alert = UIAlertController(title: "Confirmação", message: "Confirma deletar o animal.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action: UIAlertAction!) in
            print("Sim")
            
            self.carrega(inicio: true)
            
            let params = ["id": idAnimal,
                          "pessoa": ["idPessoa": self.idPessoa],
                          "animalTipo": 1,
                          "excluir" : "true"
                ] as [String : AnyObject]
            
            Alamofire.request("http://lkrjunior-com.umbler.net/api/Animal/SaveAnimal", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
                
                if let erro = response.error
                {
                    if erro.localizedDescription != ""
                    {
                        Util.AlertaErroView(mensagem: (response.error?.localizedDescription)!, view: self, indicatorView: self.carregamento)
                    }
                }
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Response: \(String(describing: json))")
                    
                    let dict = Util.converterParaDictionary(text: json!)
                    let status = Util.JSON_RetornaInt(dict: dict!, campo: "status")
                    if status == 1
                    {
                        self.carrega(inicio: false)
                        
                        self.GetDados()
                    }
                    else
                    {
                        Util.AlertaErroView(mensagem: "Erro ao salvar os dados", view: self, indicatorView: self.carregamento)
                        self.carrega(inicio: false)
                    }
                }
                else { self.carrega(inicio: false) }
            }

            
        }))
        
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Não")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func EditarAnimal(idAnimal : Int)
    {
        self.showAdicionar(idAnimal: idAnimal)
    }

}
