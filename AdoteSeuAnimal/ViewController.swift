//
//  ViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 27/05/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var carregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func btnFiltro(_ sender: Any)
    {
        let view = self.storyboard?.instantiateViewController(withIdentifier:"FiltrarSid") as! FiltrarViewController
        self.present(view, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableViewAnimal: UITableView!
    
    //27/08/2017
    var totalAnimalPagina : Int = 5
    var paginaAtual : Int = 1
    
    var totalAnimal : Int = 0
    var totalAnimalPage : Int = 3
    var animalTipoArray = [Int]()
    var idArray = [Int]()
    var animal = [String]()
    var dataA = [String]()
    var genero = [String]()
    var raca = [String]()
    var descricao = [String]()
    var nome = [String]()
    //27/08/2017
    var fotosId = [Int]()
    var fotos = [String]()
    var localizacao = [String]()
    
    var filtros : ClassFiltrar = ClassFiltrar()
    
    var idPessoa : Int = 0
    
    //refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = NSAttributedString(string: "Atualizando")
        
        return refreshControl
    }()
    
    //refresh
    func handleRefresh(_ refreshControl: UIRefreshControl) {
       
        //27/08/2017
        paginaAtual = 1
        totalAnimal = 0
        
        self.tableViewAnimal.reloadData()
        
        self.GetDadosAnimal()
        
        //self.tableViewAnimal.reloadData()
        refreshControl.endRefreshing()
    }
    
    func carrega(inicio: Bool)
    {
        if inicio == true
        {
            carregamento.center = self.view.center
            carregamento.hidesWhenStopped = true
            carregamento.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            carregamento.color = UIColor.black
            self.view.addSubview(carregamento)
            carregamento.startAnimating()
            //UIApplication.shared.beginIgnoringInteractionEvents()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        else
        {
            carregamento.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSLog("viewDidLoad")
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.GetDadosBD()
        
        //refresh
        self.tableViewAnimal.addSubview(self.refreshControl)
        
        paginaAtual = 1
        totalAnimal = 0
        
        filtros = Util.FiltrarGet()
        
        self.GetDadosAnimal()
        
    }
    
    func GetDadosBD()
    {
        var pessoa : [Usuario] = Util.GetDadosBD_Usuario()
        if pessoa.count > 0
        {
            idPessoa = Int(pessoa[0].idUsuario)
        }
    }
    
    func readJSONObjectAnimal(object: [String: AnyObject]) {
        
        if (paginaAtual == 1)
        {
            animalTipoArray = [Int]()
            idArray = [Int]()
            animal = [String]()
            dataA = [String]()
            genero = [String]()
            raca = [String]()
            descricao = [String]()
            nome = [String]()
            //fotosId = [Int]()
            //fotos = [String]()
            localizacao = [String]()
        }
        
        let lista = Util.JSON_RetornaObjLista(dict: object, campo: "lista")
        //totalAnimal = lista.count
        totalAnimal = totalAnimal + lista.count

        for listaObj in lista {
            let animalTipo = Util.JSON_RetornaInt(dict: listaObj, campo: "animalTipoInt")
            let id = Util.JSON_RetornaInt(dict: listaObj, campo: "id")
            let data = Util.JSON_RetornaString(dict: listaObj, campo: "dataFormatada")
            let desc = Util.JSON_RetornaString(dict: listaObj, campo: "descricao")
            var generoObj = Util.JSON_RetornaStringInterna(dict: listaObj, objeto: "genero", campo: "genero")
            let racaObj = Util.JSON_RetornaStringInterna(dict: listaObj, objeto: "raca", campo: "raca")
            
            let uf = Util.JSON_RetornaObjInterna(dict: listaObj, objeto: "cidade", campo: "uf")
            let cidade = Util.JSON_RetornaStringInterna(dict: listaObj, objeto: "cidade", campo: "cidade")
            if animalTipo == 1
            {
                let ufInterna = Util.JSON_RetornaString(dict: uf, campo: "uf")
                localizacao.append(cidade + "/" + ufInterna)
            }
            else
            {
                let local = Util.JSON_RetornaString(dict: listaObj, campo: "localizacao")
                localizacao.append(local)

            }
            
            if animalTipo == 1
            {
                animal.append("Animal para doação")
                let nomeJ = Util.JSON_RetornaString(dict: listaObj, campo: "nome")
                nome.append(nomeJ)
            }
            else
            {
                animal.append("Animal abandonado")
                nome.append("")
                generoObj = Util.JSON_RetornaString(dict: listaObj, campo: "endereco")
            }
            
            raca.append(racaObj)
            genero.append(generoObj)
            dataA.append(data)
            descricao.append(desc)
            animalTipoArray.append(animalTipo)
            idArray.append(id)
        }
    }
    
    func NAOUSAR_readJSONObjectAnimal(object: [String: AnyObject]) {
        animalTipoArray = [Int]()
        idArray = [Int]()
        animal = [String]()
        dataA = [String]()
        genero = [String]()
        raca = [String]()
        descricao = [String]()
        nome = [String]()
        fotos = [String]()
        localizacao = [String]()
        
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
                guard let nomeJ = listaObj["nome"] as? String? else { break }
                nome.append(nomeJ!)
            }
            else
            {
                animal.append("Animal abandonado")
                nome.append("")
            }
            
            dataA.append(data)
            descricao.append(desc)
            animalTipoArray.append(animalTipo)
            idArray.append(id)
        }
    }
    
    func MontaStringPesquisa() -> String
    {
        var pesquisa = ""
        var addTipoAnimal = false
        if filtros.fPesquisar == true
        {
            if filtros.fTipoAnimal != 0
            {
                pesquisa = pesquisa + "&tipoAnimal=" + String(filtros.fTipoAnimal)
            }
            if filtros.fIdGenero != 0
            {
                pesquisa = pesquisa + "&idGenero=" + String(filtros.fIdGenero)
                addTipoAnimal = true
            }
            if filtros.fIdRaca != 0
            {
                pesquisa = pesquisa + "&idRaca=" + String(filtros.fIdRaca)
                addTipoAnimal = true
            }
            if filtros.fIdPorte != 0
            {
                pesquisa = pesquisa + "&idPorte=" + String(filtros.fIdPorte)
                addTipoAnimal = true
            }
            if filtros.fIdUf != 0
            {
                pesquisa = pesquisa + "&idUf=" + String(filtros.fIdUf)
                addTipoAnimal = true
            }
            if filtros.fIdCidade != 0
            {
                pesquisa = pesquisa + "&idCidade=" + String(filtros.fIdCidade)
                addTipoAnimal = true
            }
            if filtros.fIdadeMin != 0
            {
                pesquisa = pesquisa + "&idadeMin=" + String(filtros.fIdadeMin)
                addTipoAnimal = true
            }
            if filtros.fIdadeMax != 0
            {
                pesquisa = pesquisa + "&idadeMax=" + String(filtros.fIdadeMax)
                addTipoAnimal = true
            }
            if filtros.fPesoMin != 0
            {
                pesquisa = pesquisa + "&pesoMin=" + String(filtros.fPesoMin)
                addTipoAnimal = true
            }
            if filtros.fPesoMin != 0
            {
                pesquisa = pesquisa + "&pesoMax=" + String(filtros.fPesoMax)
                addTipoAnimal = true
            }
            if addTipoAnimal == true && filtros.fTipoAnimal == 0
            {
                pesquisa = pesquisa + "&tipoAnimal=1"
            }
        }
        return pesquisa
    }

    func GetDadosAnimal()
    {
        self.carrega(inicio: true)
        //27/08/2017
        let paginacao = "?pagina=\(paginaAtual)&itens=\(totalAnimalPagina)"
        let pesquisa = self.MontaStringPesquisa()
        var request = URLRequest(url: URL(string: Util.getUrlApi() + "api/Animal/GetAnimal" + paginacao + pesquisa)!)
        request.httpMethod = "GET"
        //var timeoutPadrao = request.timeoutInterval
        request.timeoutInterval = 60
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                Util.AlertaErroView(mensagem: (error?.localizedDescription)!, view: self, indicatorView: self.carregamento)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                Util.AlertaErroView(mensagem: "Erro ao carregar os dados!", view: self, indicatorView: self.carregamento)
            }
            
            let responseString = String(data: data, encoding: .utf8)
            
            if responseString != nil && responseString != "null"
            {
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let dictionary = object as? [String: AnyObject] {
                        self.readJSONObjectAnimal(object: dictionary)
                        
                        DispatchQueue.main.sync {
                            self.tableViewAnimal.delegate = self
                            self.tableViewAnimal.dataSource = self
                            self.tableViewAnimal.reloadData()
                            self.carrega(inicio: false)
                            //self.CarregaImagens()
                        }
                        //DispatchQueue.main.async {
                        //    self.CarregaImagens()
                        //}
                        if self.totalAnimal == 0 && self.filtros.fPesquisar == true
                        {
                            //Util.AlertaErroView(mensagem: "Nenhum registro encontrado", view: self, indicatorView: self.carregamento)
                            self.SalvarFiltro()
                            self.carrega(inicio: false)
                        }
                    }
                } catch {
                    Util.AlertaErroView(mensagem: error.localizedDescription, view: self, indicatorView: self.carregamento)
                    self.carrega(inicio: false)
                }
            }
            else
            {
                Util.AlertaErroView(mensagem: "Nenhum registro encontrado", view: self, indicatorView: self.carregamento)
                self.carrega(inicio: false)
            }
    
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func SalvarFiltro()
    {
        let alert = UIAlertController(title: "Pesquisa", message: "Nenhum animal encontrado! Você deseja salvar esta pesquisa para receber um alerta assim que estes filtros forem atendidos?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action: UIAlertAction!) in
            print("Sim")
            
            self.carrega(inicio: true)
            
            let paramsCad = ["idPessoaFiltro": 0,
                             "pessoa": ["idPessoa": self.idPessoa],
                             "genero": ["idGenero": self.filtros.fIdGenero],
                             "raca": ["idRaca": self.filtros.fIdRaca],
                             "porte": ["idPorte": self.filtros.fIdPorte],
                             "idadeMin": self.filtros.fIdadeMin,
                             "idadeMax": self.filtros.fIdadeMax,
                             "pesoMin": self.filtros.fPesoMin,
                             "pesoMax": self.filtros.fPesoMax,
                             "idUf": self.filtros.fIdUf,
                             "idCidade": self.filtros.fIdCidade,
                             "animalTipo": self.filtros.fTipoAnimal,
                             ] as [String : AnyObject]
            
            Alamofire.request(Util.getUrlApi() + "api/PessoaFiltro/SavePessoaFiltro", method: .post, parameters: paramsCad, encoding: URLEncoding.httpBody).responseJSON { response in
                
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
                        self.carrega(inicio: false)
                        
                        self.paginaAtual = 1
                        self.totalAnimal = 0
                        
                        Util.FiltrarSave(filtros: ClassFiltrar(), limpar: true)
                        self.filtros = ClassFiltrar()
                        
                        self.GetDadosAnimal()
                    }
                    else
                    {
                        Util.AlertaErroView(mensagem: "Erro ao salvar os dados da pesquisa", view: self, indicatorView: self.carregamento)
                        self.carrega(inicio: false)
                    }
                }
                else { self.carrega(inicio: false) }
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Não")
            
            self.carrega(inicio: false)
            
            self.paginaAtual = 1
            self.totalAnimal = 0
            
            Util.FiltrarSave(filtros: ClassFiltrar(), limpar: true)
            self.filtros = ClassFiltrar()
            
            self.GetDadosAnimal()
        }))
        
        self.present(alert, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellLinhaDoTempo", for: indexPath) as! CustomTableViewCell
        if animal.count > 0 && animal.indices.contains(indexPath.row)
        {
            //let myColor : CGColor = UIColor.darkText.cgColor
            //cell.contentView.layer.borderColor = myColor
            //cell.contentView.layer.borderWidth = 2
            //cell.contentView.layer.cornerRadius = 10
            
            Util.AddViewForCell(cell: cell, table: tableViewAnimal)
            
            cell.lblAnimal.text = animal[indexPath.row]
            cell.lblData.text = dataA[indexPath.row]
            cell.lblGenero.text = (genero[indexPath.row] == "" ? "" : nome[indexPath.row] + " (" + genero[indexPath.row] + ")")
            cell.lblRaca.text = "" + (raca[indexPath.row] == "" ? "" : raca[indexPath.row])
            cell.lblDesricao.text = "" + descricao[indexPath.row]
            cell.lblLocalizacao.text = localizacao[indexPath.row]
            
            //27/08/2017
            cell.imagem.layer.masksToBounds = true
            //cell.imagem.layer.cornerRadius = cell.imagem.frame.width / 2
            cell.imagem.layer.cornerRadius = 50
            if animalTipoArray[indexPath.row] != 1
            {
                cell.imagem.image = UIImage(imageLiteralResourceName: "animalPerdido")
                cell.imagem.reloadInputViews()
                cell.lblGenero.text = descricao[indexPath.row]
                cell.lblRaca.text = localizacao[indexPath.row]
                cell.lblDesricao.text = genero[indexPath.row]
                cell.lblLocalizacao.text = ""
            }
            else
            {
                var busca : Bool = true
                var j : Int = 0
                for _ in self.fotosId {
                    if idArray[indexPath.row] == fotosId[j]
                    {
                        busca = false
                    }
                    j = j + 1
                }
                if busca == true
                {
                    cell.imagem.image = UIImage(imageLiteralResourceName: "semfoto")
                    cell.imagem.reloadInputViews()
                    
                    Alamofire.request(Util.getUrlApi() + "api/AnimalGet/GetAnimal?idTipo=1&idAnimal=" + String(idArray[indexPath.row]), method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
                        {
                            response in
                            
                            if let data = response.data
                            {
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("Response: \(String(describing: json))")
                                if (json == nil || json == "" || json == "null")
                                {
                                    print("Erro ao carregar foto")
                                }
                                else
                                {
                                    let listaDict = Util.converterParaDictionary(text: json!)
                                    let lista = Util.JSON_RetornaObjLista(dict: listaDict!, campo: "lista")
                                    
                                    if lista.count > 0
                                    {
                                        for dict in lista
                                        {
                                            
                                            let imagem = Util.JSON_RetornaStringInterna(dict: dict, objeto: "foto", campo: "fotoString")
                                            if self.idArray.indices.contains(indexPath.row)
                                            {
                                                self.fotosId.append(self.idArray[indexPath.row])
                                                self.fotos.append(imagem)
                                            
                                                let imageArray = NSData(base64Encoded: imagem, options: [])
                                                cell.imagem.image = UIImage(data: imageArray! as Data)
                                                cell.imagem.reloadInputViews()
                                            }
                                        }
                                    }
                                }
                            }
                    }

                    
                    
                }
                else
                {
                
                    if fotosId.count > 0
                    {
                        print(String(indexPath.row))
                        var i = 0
                        for _ in fotosId {
                            if fotosId[i] == idArray[indexPath.row]
                            {
                                let imageArray = NSData(base64Encoded: fotos[i], options: [])
                                cell.imagem.image = UIImage(data: imageArray! as Data)
                                cell.imagem.reloadInputViews()
                            }
                            i = i + 1
                        }
                    }
                }
            }
        }
        
        NSLog("1")
        NSLog("totalAnimal " + String(totalAnimal))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("2")
        return totalAnimal
    }
    
    //refresh
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //27/08/2017
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            print("end of table")
            if ((paginaAtual * totalAnimalPagina) <= totalAnimal)
            {
                paginaAtual = paginaAtual + 1
                self.GetDadosAnimal()
            }
        }
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

