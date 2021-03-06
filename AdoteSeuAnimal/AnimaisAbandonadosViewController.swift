//
//  AnimaisAbandonadosViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 22/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class AnimaisAbandonadosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var gerenciadorLocalizacao = CLLocationManager()
    
    @IBOutlet weak var tableViewAnimais: UITableView!
    @IBAction func btnAdicionarClick(_ sender: Any)
    {
        self.showAdicionar()
    }
    @IBAction func btnAdd(_ sender: Any) {
        self.showAdicionar()
    }

    var carregamento : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var idPessoa : Int = 0
    var telefonePessoa : String = ""
    var emailPessoa : String = ""
    var nomePessoa : String = ""
    var totalItens : Int = 0
    var descricao : [String] = [String]()
    var data : [String] = [String]()
    var local : [String] = [String]()
    var latitude : [Double] = [Double]()
    var longitude : [Double] = [Double]()
    var id : [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        gerenciadorLocalizacao.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.totalItens = 0
        self.tableViewAnimais.reloadData()
        self.GetDadosBD()
        self.GetDados()
    }
    
    func GetDados()
    {
        Util.carrega(carregamento: self.carregamento, view: self, inicio: true)
        
        totalItens = 0
        descricao = [String]()
        data = [String]()
        local = [String]()
        latitude = [Double]()
        longitude = [Double]()
        id = [Int]()
        
        
        Alamofire.request(Util.getUrlApi() + "api/Animal/GetAnimal?idTipo=2&idCadastro=" + String(idPessoa), method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
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
                            let listaDic = dict as Dictionary
                            
                            self.id.append(Util.JSON_RetornaInt(dict: dict, campo: "id"))
                            self.descricao.append(Util.JSON_RetornaString(dict: listaDic, campo: "descricao"))
                            self.data.append(Util.JSON_RetornaString(dict: dict, campo: "dataFormatada"))
                            self.latitude.append(Util.JSON_RetornaDouble(dict: dict, campo: "latitude"))
                            self.longitude.append(Util.JSON_RetornaDouble(dict: dict, campo: "longitude"))
                            self.local.append(Util.JSON_RetornaString(dict: dict, campo: "localizacao"))
                            
                            /* TROCANDO DE LUGAR, IRA SALVAR NO BD
                            let localizacao : CLLocation = CLLocation(latitude: self.latitude.last!, longitude: self.longitude.last!)
                            
                            CLGeocoder().reverseGeocodeLocation(localizacao, completionHandler: { (detalhesLocal, erro) in
                                if (erro == nil)
                                {
                                    let dadosLocal = detalhesLocal?.first
                                    if dadosLocal != nil
                                    {
                                        self.local.append((dadosLocal?.locality)! + "/" + (dadosLocal?.administrativeArea)!)
                                        self.tableViewAnimais.reloadData()
                                    }
                                }
                                else
                                {
                                    print(erro ?? "")
                                }
                            })
                            */
                        }
                        self.tableViewAnimais.reloadData()
                        Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                    }
                }
                else
                { Util.carrega(carregamento: self.carregamento, view: self, inicio: false) }
        }
        
        //Atualiza as localiza
        
    }
    
    func showAdicionar(idAnimal : Int = 0)
    {
        var senha : String = ""
        var usuario : [Usuario] = Util.GetDadosBD_Usuario()
        if usuario.count > 0
        {
            if let senhaBd = usuario[0].senha
            {
                senha = senhaBd
            }
        }
        if senha == ""
        {
            Util.AlertaView(titulo: "Informação", mensagem: "Confirme sua senha no menu Perfil. A senha foi enviada para o seu e-mail cadastrado", view: self)
        }
        else
        {
            let view = self.storyboard?.instantiateViewController(withIdentifier:"AnimaisAbandonadosSalvarSid") as! AnimaisAbandonadosSalvarViewController
            view.idPessoa = self.idPessoa
            view.nomePessoa = self.nomePessoa
            view.telefonePessoa = self.telefonePessoa
            view.emailPessoa = self.emailPessoa
            self.present(view, animated: true, completion: nil)
        }
    }
    
    func GetDadosBD()
    {
        idPessoa = 0
        let usuario = Util.GetDadosBD_Usuario()
        if usuario.count > 0
        {
            idPessoa = Int(usuario[0].idUsuario)
            emailPessoa = usuario[0].email!
            telefonePessoa = usuario[0].telefone!
            nomePessoa = usuario[0].nome!
        }
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAnimaisAbandonados", for: indexPath) as! AnimaisAbandonadosTableViewCell
        
        if descricao.indices.contains(indexPath.row)
        {
            Util.AddViewForCell(cell: cell, table: tableViewAnimais)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            //Util.AjustaLayoutCell(view: cell)
        
            cell.lblDescricao.text = descricao[indexPath.row]
            cell.lblData.text = "Sinalizado em " + data[indexPath.row]
            cell.lblLocal.text = "Localização : "
            cell.lblDeslize.text = ""
            if (indexPath.row == 0)
            {
                cell.lblDeslize.text = "< deslize"
            }
            let isIndexValid = local.indices.contains(indexPath.row)
            if isIndexValid
            {
                cell.lblLocal.text = cell.lblLocal.text! + "" + local[indexPath.row]
            }
        }
        
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalItens
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
            print("Deletar " + String(self.id[indexPath.row]))
            self.Deletar(idAnimal: self.id[indexPath.row])
        }
        
        return [delete]
    }
    
    func Deletar(idAnimal : Int)
    {
        var senha : String = ""
        var usuario : [Usuario] = Util.GetDadosBD_Usuario()
        if usuario.count > 0
        {
            if let senhaBd = usuario[0].senha
            {
                senha = senhaBd
            }
        }
        if senha == ""
        {
            Util.AlertaView(titulo: "Informação", mensagem: "Confirme sua senha no menu Perfil. A senha foi enviada para o seu e-mail cadastrado", view: self)
            return
        }
        
        let alert = UIAlertController(title: "Confirmação", message: "Confirma deletar o animal abandonado.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action: UIAlertAction!) in
            print("Sim")
            
            Util.carrega(carregamento: self.carregamento, view: self, inicio: true)
            
            let params = ["id": idAnimal,
                          "animalTipo" : 2,
                          "pessoa": ["idPessoa": self.idPessoa],
                          "excluir" : "true"
                ] as [String : AnyObject]
            
            Alamofire.request(Util.getUrlApi() + "api/Animal/SaveAnimal", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
                
                if let erro = response.error
                {
                    if erro.localizedDescription != ""
                    {
                        Util.AlertaErroView(mensagem: (response.error?.localizedDescription)!, view: self, indicatorView: self.carregamento)
                    }
                }
                
                if let data = response.data {
                    var json = String(data: data, encoding: String.Encoding.utf8)
                    print("Response: \(String(describing: json))")
                    
                    if (json == nil || json == "null")
                    {   json =  "" }
                    
                    let dict = Util.converterParaDictionary(text: json!)
                    let status = Util.JSON_RetornaInt(dict: dict!, campo: "status")
                    if status == 1
                    {
                        Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                        
                        self.GetDados()
                    }
                    else
                    {
                        Util.AlertaErroView(mensagem: "Erro ao deletar os dados!", view: self, indicatorView: self.carregamento)
                        Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                    }
                }
                else
                { Util.carrega(carregamento: self.carregamento, view: self, inicio: false) }
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Não")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}
