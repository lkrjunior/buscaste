//
//  MeusAnimaisSalvarViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 19/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import Alamofire

class MeusAnimaisSalvarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var generos = [String]()
    var generosIds = [Int]()
    var generosId : Int = 0
    var racas = [String]()
    var racasIds = [Int]()
    var racasId : Int = 0
    var portes = [String]()
    var portesIds = [Int]()
    var portesId : Int = 0
    var ufs = [String]()
    var ufsIds = [Int]()
    var ufsId : Int = 0
    var cidades = [String]()
    var cidadesIds = [Int]()
    var cidadesIdsUfs = [Int]()
    var cidadesId : Int = 0
    var cidadesAux = [String]()
    var cidadesAuxIds = [Int]()
    var idPessoa : Int = 0
    var telefonePessoa : String = ""
    var emailPessoa : String = ""
    var idAnimal : Int = 0
    var carregarDados : Bool = false
    
    //variaveis para controle do indicator
    var carregandoCombo : Bool = false
    var carregandoLista : Bool = false
    //
    
    @IBAction func btnSairClick(_ sender: Any)
    {
        self.showVoltar()
    }
    
    @IBAction func btnSalvarClick(_ sender: Any)
    {
        self.Save()
    }
    @IBAction func btnCameraClick(_ sender: Any) {
        self.Camera()
    }
    @IBAction func btnAlbumClick(_ sender: Any) {
        self.Album()
    }
    @IBAction func btnSave(_ sender: Any) {
        self.Save()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.showVoltar()
    }
    
    @IBOutlet weak var carregamento: UIActivityIndicatorView!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtGenero: UITextField!
    @IBOutlet weak var txtRaca: UITextField!
    @IBOutlet weak var txtIdade: UITextField!
    @IBOutlet weak var txtPorte: UITextField!
    @IBOutlet weak var txtPeso: UITextField!
    @IBOutlet weak var txtUF: UITextField!
    @IBOutlet weak var txtCidade: UITextField!
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var txtVacinas: UITextField!
    @IBOutlet weak var imagem: UIImageView!
    
    var imageCamera = UIImagePickerController()
    var imageAlbum = UIImagePickerController()
    
    func carrega(inicio: Bool)
    {
        if inicio == true
        {
            carregamento.center = self.view.center
            carregamento.frame.origin.y = carregamento.frame.origin.y - 30
            //carregamento.frame.origin.y = self.imagem.frame.origin.y - 50
            carregamento.hidesWhenStopped = true
            carregamento.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            carregamento.color = UIColor.black
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imageCamera.restorationIdentifier = "Camera"
        imageAlbum.restorationIdentifier = "Album"
        imageCamera.delegate = self
        imageAlbum.delegate = self
        
        self.CarregaCombos()
        self.CarregaJSONCombos()
        self.AjustaTextFields()
        
        //trocando de lugar
        //if (idAnimal > 0)
        //{
        //    self.CarregaDados()
        //}
    }
    
    func addToolBar(textField: UITextField)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MeusAnimaisSalvarViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MeusAnimaisSalvarViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed()
    {
        view.endEditing(true)
    }
    
    func cancelPressed()
    {
        view.endEditing(true)
    }
    
    func AjustaTextFields()
    {
        self.txtNome.placeholder = "Nome do animal"
        self.txtGenero.placeholder = "Genero"
        self.txtRaca.placeholder = "Raça"
        self.txtIdade.placeholder = "Idade (anos)"
        self.txtPorte.placeholder = "Porte"
        self.txtPeso.placeholder = "Peso (kg)"
        self.txtUF.placeholder = "UF"
        self.txtCidade.placeholder = "Cidade"
        self.txtDescricao.placeholder = "Descrição breve do animal"
        self.txtVacinas.placeholder = "Vacinas realizadas no animal"
        
        txtIdade.keyboardType = .numberPad
        txtPeso.keyboardType = .decimalPad
        self.addToolBar(textField: txtNome)
        self.addToolBar(textField: txtIdade)
        self.addToolBar(textField: txtPeso)
        self.addToolBar(textField: txtDescricao)
        self.addToolBar(textField: txtVacinas)
        
        self.txtGenero.restorationIdentifier = "genero"
        self.txtRaca.restorationIdentifier = "raca"
        self.txtPorte.restorationIdentifier = "porte"
        self.txtUF.restorationIdentifier = "uf"
        self.txtCidade.restorationIdentifier = "cidade"
        
        self.txtGenero.addTarget(self, action: #selector(MeusAnimaisSalvarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtRaca.addTarget(self, action: #selector(MeusAnimaisSalvarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtPorte.addTarget(self, action: #selector(MeusAnimaisSalvarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtUF.addTarget(self, action: #selector(MeusAnimaisSalvarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtCidade.addTarget(self, action: #selector(MeusAnimaisSalvarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        
        self.txtNome.delegate = self
        self.txtGenero.delegate = self
        self.txtRaca.delegate = self
        self.txtPorte.delegate = self
        self.txtIdade.delegate = self
        self.txtPeso.delegate = self
        self.txtUF.delegate = self
        self.txtCidade.delegate = self
        self.txtDescricao.delegate = self
        self.txtVacinas.delegate = self
        
        self.txtNome.tag = 0
        self.txtGenero.tag = 1
        self.txtRaca.tag = 2
        self.txtIdade.tag = 3
        self.txtPorte.tag = 4
        self.txtPeso.tag = 5
        self.txtUF.tag = 6
        self.txtCidade.tag = 7
        self.txtDescricao.tag = 8
        self.txtVacinas.tag = 9
    }
    
    func textFieldTouchInside(textField: UITextField)
    {
        let id = textField.restorationIdentifier ?? ""
        let valor = textField.text ?? ""
        switch id {
        case "genero":
            if (valor == "" && generos.count > 0)
            {
                textField.text = generos[0]
                generosId = generosIds[0]
            }
            return
        case "raca":
            if (valor == "" && racas.count > 0)
            {
                textField.text = racas[0]
                racasId = racasIds[0]
            }
            return
        case "porte":
            if (valor == "" && portes.count > 0)
            {
                textField.text = portes[0]
                portesId = portesIds[0]
            }
            return
        case "uf":
            if (valor == "" && ufs.count > 0)
            {
                textField.text = ufs[0]
                ufsId = ufsIds[0]
                self.CarregaCidadesPeloUf()
            }
            return
        case "cidade":
            if (valor == "" && cidades.count > 0 && ufsId > 0)
            {
                textField.text = cidades[0]
                cidadesId = cidadesIds[0]
            }
            return
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
            textFieldTouchInside(textField: nextField)
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        if (idAnimal > 0 && carregarDados)
        {
            self.CarregaDados()
        }
    }
    
    func CarregaDados()
    {
        carregandoLista = true
        print("Carregando dados")
        
        self.carrega(inicio: true)
        
        Alamofire.request(Util.getUrlApi() + "api/AnimalGet/GetAnimal?idTipo=1&idAnimal=" + String(idAnimal), method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
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
                        
                        for dict in lista
                        {
                            var listaDic = dict as Dictionary
                            
                            //let idAnimal = dict["id"] as! Int?
                            let nomeAnimal = Util.JSON_RetornaString(dict: dict, campo: "nome")
                            let descricao = Util.JSON_RetornaString(dict: dict, campo: "descricao")
                            
                            self.txtNome.text = nomeAnimal
                            self.txtDescricao.text = descricao
                            
                            self.txtGenero.text = Util.JSON_RetornaStringInterna(dict: dict, objeto: "genero", campo: "genero")
                            self.generosId = Util.JSON_RetornaIntInterna(dict: dict, objeto: "genero", campo: "idGenero")
                            
                            if !(listaDic["foto"] is NSNull)
                            {
                                let fotoObj = Util.JSON_RetornaStringInterna(dict: dict, objeto: "foto", campo: "fotoString")
                                let fileBase64 = fotoObj
                                if fileBase64 != ""
                                {
                                    let imageArray = NSData(base64Encoded: fileBase64, options: [])
                                    self.imagem.image = UIImage(data: imageArray! as Data)
                                    self.imagem.reloadInputViews()
                                }

                            }
                            
                            self.txtRaca.text = Util.JSON_RetornaStringInterna(dict: dict, objeto: "raca", campo: "raca")
                            self.racasId = Util.JSON_RetornaIntInterna(dict: dict, objeto: "raca", campo: "idRaca")
                            
                            let idade = Util.JSON_RetornaInt(dict: dict, campo: "idade")
                            self.txtIdade.text = String(idade)
                            
                            self.txtPorte.text = Util.JSON_RetornaStringInterna(dict: dict, objeto: "porte", campo: "porte")
                            self.portesId = Util.JSON_RetornaIntInterna(dict: dict, objeto: "porte", campo: "idPorte")
                            
                            let peso = Util.JSON_RetornaDouble(dict: dict, campo: "peso")
                            self.txtPeso.text = String(peso)
                            
                            let oIdCidade = Util.JSON_RetornaIntInterna(dict: dict, objeto: "cidade", campo: "idCidade")
                            
                            if oIdCidade > 0
                            {
                                self.txtCidade.text = Util.JSON_RetornaStringInterna(dict: dict, objeto: "cidade", campo: "cidade")
                                self.cidadesId = Util.JSON_RetornaIntInterna(dict: dict, objeto: "cidade", campo: "idCidade")
                                
                                let ufObj = Util.JSON_RetornaObjInterna(dict: dict, objeto: "cidade", campo: "uf")
                                self.txtUF.text = Util.JSON_RetornaString(dict: ufObj, campo: "uf")
                                self.ufsId = Util.JSON_RetornaInt(dict: ufObj, campo: "idUf")
                                
                                self.CarregaCidadesPeloUf()
                            }
                            
                            //let vacinas = dict["vacinas"] as! String?
                            let vacinas = Util.JSON_RetornaString(dict: dict, campo: "vacinas")
                            self.txtVacinas.text = vacinas
                            
                        }
                        if (self.carregandoCombo == false)
                        {
                            self.carrega(inicio: false)
                        }
                    }
                    self.carregarDados = false
                    self.carregandoLista = false
                }
                else
                {
                    self.carregarDados = false
                    self.carregandoLista = false
                    self.carrega(inicio: false)
                }
        }

    }
    
    func Camera()
    {
        imageCamera.sourceType = .camera
        present(imageCamera, animated: true, completion: nil)
    }
    
    func Album()
    {
        imageAlbum.sourceType = .savedPhotosAlbum
        present(imageAlbum, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imagemRecuperada = info[ UIImagePickerControllerOriginalImage] as! UIImage
        imagem.image = imagemRecuperada

        if (picker.restorationIdentifier == "Album")
        {
            imageAlbum.dismiss(animated: true, completion: nil)
        }
        else
        {
            imageCamera.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //trocando de lugar
        //self.CarregaCombos()
        //self.CarregaJSONCombos()
    }
    
    
    func Save()
    {
        self.carrega(inicio: true)
        
        
        //Valida os campos obrigatórios
        if !(Util.ValidaCampoString(textField: self.txtNome, mensagem: "Informe o nome do animal", view: self, indicator: self.carregamento))
        { return }
        
        if !(Util.ValidaCampoInt(int: self.generosId, textField: self.txtGenero, mensagem: "Informe o genero do animal", view: self, indicator: self.carregamento))
        { return }
        
        if !(Util.ValidaCampoInt(int: self.racasId, textField: self.txtRaca, mensagem: "Informe a raça do animal", view: self, indicator: self.carregamento))
        { return }
        
        if !(Util.ValidaCampoString(textField: self.txtIdade, mensagem: "Informe a idade do animal", view: self, indicator: self.carregamento))
        { return }
        
        if !(Util.ValidaCampoInt(int: self.portesId, textField: self.txtPorte, mensagem: "Informe o porte do animal", view: self, indicator: self.carregamento))
        { return }
        
        if !(Util.ValidaCampoString(textField: self.txtPeso, mensagem: "Informe o peso do animal", view: self, indicator: self.carregamento))
        { return }
        
        if !(Util.ValidaCampoInt(int: self.ufsId, textField: self.txtUF, mensagem: "Informe sua UF", view: self, indicator: self.carregamento))
        { return }
        
        if !(Util.ValidaCampoInt(int: self.cidadesId, textField: self.txtCidade, mensagem: "Informe sua cidade", view: self, indicator: self.carregamento))
        { return }
        
        if !(Util.ValidaCampoString(textField: self.txtDescricao, mensagem: "Informe uma breve descrição do animal", view: self, indicator: self.carregamento))
        { return }
        
        if (txtVacinas.text?.isEmpty)!
        {
            txtVacinas.text = ""
        }
        
        //Original let imagemDados = UIImageJPEGRepresentation(imagem.image!, 0.3)
        
        //300kb let imagemSalvar = Util.compressImage_1536(imagem.image!)
        //300kb let imagemDados = UIImageJPEGRepresentation(imagemSalvar, 0.5)
        
        //30kb let imagemSalvar = Util.compressImage_512(imagem.image!)
        //30kb let imagemDados = UIImageJPEGRepresentation(imagemSalvar, 0.3)
        
        let imagemSalvar = Util.compressImage_512(imagem.image!)
        let imagemDados = UIImageJPEGRepresentation(imagemSalvar, 0.5)
        
        //let imagemSalvarPequena = Util.compressImage_512(imagem.image!)
        //let imagemDadosPequena = UIImageJPEGRepresentation(imagemSalvarPequena, 0.3)
        
        let img = imagemDados!.base64EncodedString()
        //let imgPequena = imagemDadosPequena!.base64EncodedString()
        
        let params = ["nome": "nome",
                      "tipo": "jpg",
                      "fotoString": img,
            ] as [String : AnyObject]
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        Alamofire.request(Util.getUrlApi() + "api/Foto/SaveFoto", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
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
                let idFoto = Util.JSON_RetornaInt(dict: dict!, campo: "id")
                if status == 1
                {
                    
                    //Salvar o animal
                    let pesoString = self.txtPeso.text!.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
                    let idade = self.txtIdade.text! == "" ? "0" : self.txtIdade.text!
                    let peso = pesoString == "" ? "0" : pesoString
                    let paramsCad = ["id" : self.idAnimal,
                                     "animalTipo": 1,
                                     "pessoa": ["idPessoa": self.idPessoa],
                                     "genero": ["idGenero": self.generosId],
                                     "raca": ["idRaca": self.racasId],
                                     "idade": idade,
                                     "porte": ["idPorte": self.portesId],
                                     "peso": peso,
                                     "cidade": ["idCidade": self.cidadesId, "Uf" : ["idUf": self.ufsId]],
                                     "telefone": self.telefonePessoa,
                                     "email": self.emailPessoa,
                                     "descricao": self.txtDescricao.text!,
                                     "vacinas": self.txtVacinas.text!,
                                     "foto": ["idFoto": idFoto],
                                     "nome": self.txtNome.text!,
                        ] as [String : AnyObject]
                    
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    
                    Alamofire.request(Util.getUrlApi() + "api/Animal/SaveAnimal", method: .post, parameters: paramsCad, encoding: URLEncoding.httpBody).responseJSON { response in
                        
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
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
                                
                                self.showVoltar()
                            }
                            else
                            {
                                Util.AlertaErroView(mensagem: "Erro ao salvar os dados", view: self, indicatorView: self.carregamento)
                                self.carrega(inicio: false)
                            }
                        }
                        else
                        { self.carrega(inicio: false) }
                    }

                    //self.carrega(inicio: false)
                    
                    //self.showVoltar()
                }
                else
                {
                    Util.AlertaErroView(mensagem: "Erro ao salvar a foto do animal!", view: self, indicatorView: self.carregamento)
                    self.carrega(inicio: false)
                }
            }
            else
            { self.carrega(inicio: false) }
        }
    }
    
    func NAO_USAR_CarregaJSONCombos()
    {
        //let dataAtual = Util.GetDateAtual()
        carregandoCombo = true
        
        self.carrega(inicio: true)
        
        Alamofire.request(Util.getUrlApi() + "api/Combos/GetCombos", method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
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
                        
                        for dict in lista
                        {
                            let tipo = Util.JSON_RetornaString(dict: dict, campo: "tipo")
                            let id = Util.JSON_RetornaInt(dict: dict, campo: "id")
                            let id2 = Util.JSON_RetornaInt(dict: dict, campo: "id2")
                            let descricao = Util.JSON_RetornaString(dict: dict, campo: "descricao")
                            
                            if (tipo != "")
                            {
                                if (tipo == "Cidade")
                                {
                                    self.cidades.append(descricao)
                                    self.cidadesIds.append(id)
                                    self.cidadesIdsUfs.append(id2)
                                }
                                else if (tipo == "Uf")
                                {
                                    self.ufs.append(descricao)
                                    self.ufsIds.append(id)
                                }
                                else if (tipo == "Genero")
                                {
                                    self.generos.append(descricao)
                                    self.generosIds.append(id)
                                }
                                else if (tipo == "Raca")
                                {
                                    self.racas.append(descricao)
                                    self.racasIds.append(id)
                                }
                                else if (tipo == "Porte")
                                {
                                    self.portes.append(descricao)
                                    self.portesIds.append(id)
                                }
                            }
                            else
                            {
                                self.generos = [String]()
                                self.generosIds = [Int]()
                                self.generosId = 0
                                self.racas = [String]()
                                self.racasIds = [Int]()
                                self.racasId = 0
                                self.portes = [String]()
                                self.portesIds = [Int]()
                                self.portesId = 0
                                self.ufs = [String]()
                                self.ufsIds = [Int]()
                                self.ufsId = 0
                                self.cidades = [String]()
                                self.cidadesIds = [Int]()
                                self.cidadesIdsUfs = [Int]()
                                self.cidadesId = 0
                                self.cidadesAux = [String]()
                                self.cidadesAuxIds = [Int]()

                            }
                        }
                        if (self.carregandoLista == false)
                        {
                            self.carrega(inicio: false)
                        }
                    }
                    self.carregandoCombo = false
                }
                else
                {
                    self.carregandoCombo = false
                    self.carrega(inicio: false)
                }
        }

    }
    
    func CarregaJSONCombos()
    {
        //let dataAtual = Util.GetDateAtual()
        carregandoCombo = true
        
        self.carrega(inicio: true)
        
        let combosCache = Util.CombosGetCache()
        if combosCache != ""
        {
            self.CarregaComboLista(json: combosCache)
            if (self.carregandoLista == false)
            {
                self.carrega(inicio: false)
            }
            self.carregandoCombo = false
        }
        else
        {
            Alamofire.request(Util.getUrlApi() + "api/Combos/GetCombos", method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
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
                            self.CarregaComboLista(json: json)
                            if (self.carregandoLista == false)
                            {
                                self.carrega(inicio: false)
                            }
                        }
                        self.carregandoCombo = false
                    }
                    else
                    {
                        self.carregandoCombo = false
                        self.carrega(inicio: false)
                    }
            }
        }
    }
    
    func CarregaComboLista(json : String!)
    {
        let listaDict = Util.converterParaDictionary(text: json!)
        let lista = Util.JSON_RetornaObjLista(dict: listaDict!, campo: "lista")
        
        if lista.count > 0
        {
            Util.CombosSaveCache(combos: json)
        }
        
        for dict in lista
        {
            let tipo = Util.JSON_RetornaString(dict: dict, campo: "tipo")
            let id = Util.JSON_RetornaInt(dict: dict, campo: "id")
            let id2 = Util.JSON_RetornaInt(dict: dict, campo: "id2")
            let descricao = Util.JSON_RetornaString(dict: dict, campo: "descricao")
            
            if (tipo != "")
            {
                if (tipo == "Cidade")
                {
                    self.cidades.append(descricao)
                    self.cidadesIds.append(id)
                    self.cidadesIdsUfs.append(id2)
                }
                else if (tipo == "Uf")
                {
                    self.ufs.append(descricao)
                    self.ufsIds.append(id)
                }
                else if (tipo == "Genero")
                {
                    self.generos.append(descricao)
                    self.generosIds.append(id)
                }
                else if (tipo == "Raca")
                {
                    self.racas.append(descricao)
                    self.racasIds.append(id)
                }
                else if (tipo == "Porte")
                {
                    self.portes.append(descricao)
                    self.portesIds.append(id)
                }
            }
            else
            {
                self.generos = [String]()
                self.generosIds = [Int]()
                self.generosId = 0
                self.racas = [String]()
                self.racasIds = [Int]()
                self.racasId = 0
                self.portes = [String]()
                self.portesIds = [Int]()
                self.portesId = 0
                self.ufs = [String]()
                self.ufsIds = [Int]()
                self.ufsId = 0
                self.cidades = [String]()
                self.cidadesIds = [Int]()
                self.cidadesIdsUfs = [Int]()
                self.cidadesId = 0
                self.cidadesAux = [String]()
                self.cidadesAuxIds = [Int]()
                
            }
        }
    }
    
    func CarregaCombos()
    {
        carrega(inicio: true)
        
        let toolBarGenero = UIToolbar()
        toolBarGenero.barStyle = UIBarStyle.default
        toolBarGenero.isTranslucent = true
        toolBarGenero.tintColor = UIColor.blue
        toolBarGenero.sizeToFit()
        
        let doneButtonGenero = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MeusAnimaisSalvarViewController.DonePickerGenero))
        let spaceButtonGenero = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBarGenero.setItems([spaceButtonGenero, doneButtonGenero], animated: false)
        toolBarGenero.isUserInteractionEnabled = true
        
        let pickerViewGenero = UIPickerView()
        pickerViewGenero.delegate = self
        pickerViewGenero.restorationIdentifier = "Genero"
        pickerViewGenero.showsSelectionIndicator = true

        txtGenero.inputView = pickerViewGenero
        txtGenero.inputAccessoryView = toolBarGenero
        
        
        let toolBarRaca = UIToolbar()
        toolBarRaca.barStyle = UIBarStyle.default
        toolBarRaca.isTranslucent = true
        toolBarRaca.tintColor = UIColor.blue
        toolBarRaca.sizeToFit()
        
        let doneButtonRaca = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MeusAnimaisSalvarViewController.DonePickerRaca))
        let spaceButtonRaca = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBarRaca.setItems([spaceButtonRaca, doneButtonRaca], animated: false)
        toolBarRaca.isUserInteractionEnabled = true
        
        let pickerViewRaca = UIPickerView()
        pickerViewRaca.delegate = self
        pickerViewRaca.restorationIdentifier = "Raca"
        pickerViewRaca.showsSelectionIndicator = true
        
        txtRaca.inputView = pickerViewRaca
        txtRaca.inputAccessoryView = toolBarRaca
        
        
        let toolBarPorte = UIToolbar()
        toolBarPorte.barStyle = UIBarStyle.default
        toolBarPorte.isTranslucent = true
        toolBarPorte.tintColor = UIColor.blue
        toolBarPorte.sizeToFit()
        
        let doneButtonPorte = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MeusAnimaisSalvarViewController.DonePickerPorte))
        let spaceButtonPorte = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBarPorte.setItems([spaceButtonPorte, doneButtonPorte], animated: false)
        toolBarPorte.isUserInteractionEnabled = true
        
        let pickerViewPorte = UIPickerView()
        pickerViewPorte.delegate = self
        pickerViewPorte.restorationIdentifier = "Porte"
        pickerViewPorte.showsSelectionIndicator = true
        
        txtPorte.inputView = pickerViewPorte
        txtPorte.inputAccessoryView = toolBarPorte
        
        
        let toolBarUf = UIToolbar()
        toolBarUf.barStyle = UIBarStyle.default
        toolBarUf.isTranslucent = true
        toolBarUf.tintColor = UIColor.blue
        toolBarUf.sizeToFit()
        
        let doneButtonUf = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MeusAnimaisSalvarViewController.DonePickerUf))
        let spaceButtonUf = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBarUf.setItems([spaceButtonUf, doneButtonUf], animated: false)
        toolBarUf.isUserInteractionEnabled = true
        
        let pickerViewUf = UIPickerView()
        pickerViewUf.delegate = self
        pickerViewUf.restorationIdentifier = "Uf"
        pickerViewUf.showsSelectionIndicator = true
        
        txtUF.inputView = pickerViewUf
        txtUF.inputAccessoryView = toolBarUf
        
        
        let toolBarCidade = UIToolbar()
        toolBarCidade.barStyle = UIBarStyle.default
        toolBarCidade.isTranslucent = true
        toolBarCidade.tintColor = UIColor.blue
        toolBarCidade.sizeToFit()
        
        let doneButtonCidade = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MeusAnimaisSalvarViewController.DonePickerCidade))
        let spaceButtonCidade = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBarCidade.setItems([spaceButtonCidade, doneButtonCidade], animated: false)
        toolBarCidade.isUserInteractionEnabled = true
        
        let pickerViewCidade = UIPickerView()
        pickerViewCidade.delegate = self
        pickerViewCidade.restorationIdentifier = "Cidade"
        pickerViewCidade.showsSelectionIndicator = true
        
        txtCidade.inputView = pickerViewCidade
        txtCidade.inputAccessoryView = toolBarCidade
        
        carrega(inicio: false)
    }
    
    func DonePickerGenero()
    {
        txtGenero.inputView?.removeFromSuperview()
        txtGenero.inputAccessoryView?.removeFromSuperview()
        if textFieldShouldReturn(txtGenero) {}
    }
    
    func DonePickerRaca()
    {
        txtRaca.inputView?.removeFromSuperview()
        txtRaca.inputAccessoryView?.removeFromSuperview()
        if textFieldShouldReturn(txtRaca) {}
    }
    
    func DonePickerPorte()
    {
        txtPorte.inputView?.removeFromSuperview()
        txtPorte.inputAccessoryView?.removeFromSuperview()
        if textFieldShouldReturn(txtPorte) {}
    }
    
    func DonePickerCidade()
    {
        txtCidade.inputView?.removeFromSuperview()
        txtCidade.inputAccessoryView?.removeFromSuperview()
        if textFieldShouldReturn(txtCidade) {}
    }
    
    func DonePickerUf()
    {
        txtUF.inputView?.removeFromSuperview()
        txtUF.inputAccessoryView?.removeFromSuperview()
        if textFieldShouldReturn(txtUF) {}
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if (pickerView.restorationIdentifier == "Genero")
        {
            return generos.count
        }
        else if (pickerView.restorationIdentifier == "Porte")
        {
            return portes.count
        }
        else if (pickerView.restorationIdentifier == "Cidade")
        {
            return cidadesAux.count
        }
        else if (pickerView.restorationIdentifier == "Uf")
        {
            return ufs.count
        }
        else
        {
            return racas.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if (pickerView.restorationIdentifier == "Genero")
        {
            return generos[row]
        }
        else if (pickerView.restorationIdentifier == "Porte")
        {
            return portes[row]
        }
        else if (pickerView.restorationIdentifier == "Cidade")
        {
            return cidadesAux[row]
        }
        else if (pickerView.restorationIdentifier == "Uf")
        {
            return ufs[row]
        }
        else
        {
            return racas[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (pickerView.restorationIdentifier == "Genero")
        {
            if generos.indices.contains(row)
            {
                txtGenero.text = generos[row]
                generosId = generosIds[row]
            }
        }
        else if (pickerView.restorationIdentifier == "Porte")
        {
            if portes.indices.contains(row)
            {
                txtPorte.text = portes[row]
                portesId = portesIds[row]
            }
        }
        else if (pickerView.restorationIdentifier == "Cidade")
        {
            if cidadesAux.indices.contains(row)
            {
                txtCidade.text =  cidadesAux[row]
                cidadesId = cidadesAuxIds[row]
            }
        }
        else if (pickerView.restorationIdentifier == "Uf")
        {
            if ufs.indices.contains(row)
            {
                txtUF.text = ufs[row]
                ufsId = ufsIds[row]
            
                self.CarregaCidadesPeloUf()
            }
        }
        else
        {
            if racas.indices.contains(row)
            {
                txtRaca.text = racas[row]
                racasId = racasIds[row]
            }
        }
    }
    
    func CarregaCidadesPeloUf()
    {
        var i : Int = 0
        for item in cidadesIdsUfs {
            if (item == self.ufsId)
            {
                cidadesAux.append(cidades[i])
                cidadesAuxIds.append(cidadesIds[i])
            }
            i = i + 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showVoltar()
    {
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        tb.selectedIndex = 1
        self.present(tb, animated: true, completion: nil)
    }
    
}
