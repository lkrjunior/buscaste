//
//  MeusAnimaisSalvarViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 19/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import Alamofire

class MeusAnimaisSalvarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageCamera.restorationIdentifier = "Camera"
        imageAlbum.restorationIdentifier = "Album"
        imageCamera.delegate = self
        imageAlbum.delegate = self
        
        self.CarregaCombos()
        self.CarregaJSONCombos()
        
        //trocando de lugar
        //if (idAnimal > 0)
        //{
        //    self.CarregaDados()
        //}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (idAnimal > 0 && carregarDados)
        {
            self.CarregaDados()
        }
    }
    
    func CarregaDados()
    {
        print("Carregando dados")
        
        self.carrega(inicio: true)
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/AnimalGet/GetAnimal?idTipo=1&idAnimal=" + String(idAnimal), method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
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
                        
                        for dict in lista!
                        {
                            var listaDic = dict as Dictionary
                            
                            //let idAnimal = dict["id"] as! Int?
                            let nomeAnimal = dict["nome"] as! String?
                            let descricao = dict["descricao"] as! String?
                            
                            self.txtNome.text = nomeAnimal
                            self.txtDescricao.text = descricao
                            
                            if !(listaDic["genero"] is NSNull)
                            {
                                let generoObj = dict["genero"] as? [String : AnyObject]
                                self.txtGenero.text = generoObj?["genero"] as? String
                                self.generosId = (generoObj?["idGenero"] as? Int)!
                            }
                            
                            if !(listaDic["foto"] is NSNull)
                            {
                                let fotoObj = dict["foto"] as? [String : AnyObject]
                                if let fileBase64 = fotoObj?["fotoString"] as? String
                                {
                                    let imageArray = NSData(base64Encoded: fileBase64, options: [])
                                    self.imagem.image = UIImage(data: imageArray! as Data)
                                    self.imagem.reloadInputViews()
                                }

                            }
                            
                            if !(listaDic["raca"] is NSNull)
                            {
                                let racaObj = dict["raca"] as? [String : AnyObject]
                                self.txtRaca.text = racaObj?["raca"] as? String
                                self.racasId = (racaObj?["idRaca"] as? Int)!
                            }
                            
                            let idade = dict["idade"] as! Int?
                            self.txtIdade.text = String(idade!)
                            
                            
                            if !(listaDic["porte"] is NSNull)
                            {
                                let porteObj = dict["porte"] as? [String : AnyObject]
                                self.txtPorte.text = porteObj?["porte"] as? String
                                self.portesId = (porteObj?["idPorte"] as? Int)!
                            }
                            
                            let peso = dict["peso"] as! Double?
                            self.txtPeso.text = String(peso!)
                            
                            
                            if !(listaDic["cidade"] is NSNull)
                            {
                                let cidadeObj = dict["cidade"] as? [String : AnyObject]
                                self.txtCidade.text = cidadeObj?["cidade"] as? String
                                self.cidadesId = (cidadeObj?["idCidade"] as? Int)!
                                
                                let ufObj = cidadeObj?["uf"] as? [String : AnyObject]
                                self.txtUF.text = ufObj?["uf"] as? String
                                self.ufsId = (ufObj?["idUf"] as? Int)!
                                
                                self.CarregaCidadesPeloUf()
                            }
                            
                            let vacinas = dict["vacinas"] as! String?
                            self.txtVacinas.text = vacinas!
                            
                        }
                        self.carrega(inicio: false)
                    }
                    self.carregarDados = false
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
        
        let imagemDados = UIImageJPEGRepresentation(imagem.image!, 0.3)
        
        let img = imagemDados!.base64EncodedString()
        
        let params = ["nome": "nome",
                      "tipo": "jpg",
                      "fotoString": img
            ] as [String : AnyObject]
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/Foto/SaveFoto", method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("Response: \(String(describing: json))")
                
                let dict = Util.converterParaDictionary(text: json!)
                let status = dict?["status"] as! Int
                let idFoto = dict?["id"] as! Int
                if status == 1
                {
                    
                    //Salvar o animal
                    let paramsCad = ["id" : self.idAnimal,
                                     "animalTipo": 1,
                                     "pessoa": ["idPessoa": self.idPessoa],
                                     "genero": ["idGenero": self.generosId],
                                     "raca": ["idRaca": self.racasId],
                                     "idade": self.txtIdade.text!,
                                     "porte": ["idPorte": self.portesId],
                                     "peso": self.txtPeso.text!,
                                     "cidade": ["idCidade": self.cidadesId, "Uf" : ["idUf": self.ufsId]],
                                     "telefone": self.telefonePessoa,
                                     "email": self.emailPessoa,
                                     "descricao": self.txtDescricao.text!,
                                     "vacinas": self.txtVacinas.text!,
                                     "foto": ["idFoto": idFoto],
                                     "nome": self.txtNome.text!,
                        ] as [String : AnyObject]
                    Alamofire.request("http://lkrjunior-com.umbler.net/api/Animal/SaveAnimal", method: .post, parameters: paramsCad, encoding: URLEncoding.httpBody).responseJSON { response in
                        
                        if let data = response.data {
                            let json = String(data: data, encoding: String.Encoding.utf8)
                            print("Response: \(String(describing: json))")
                            
                            let dict = Util.converterParaDictionary(text: json!)
                            let status = dict?["status"] as! Int
                            if status == 1
                            {
                                self.carrega(inicio: false)
                                
                                self.showVoltar()
                            }
                            else
                            {
                                self.carrega(inicio: false)
                            }
                        }
                    }

                    
                    
                    
                    //self.carrega(inicio: false)
                    
                    //self.showVoltar()
                }
                else
                {
                    self.carrega(inicio: false)
                }
            }
        }
    }
    
    func CarregaJSONCombos()
    {
        self.carrega(inicio: true)
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/Combos/GetCombos", method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
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
                        
                        for dict in lista!
                        {
                            let tipo = dict["tipo"] as! String?
                            let id = dict["id"] as! Int?
                            let id2 = dict["id2"] as! Int?
                            let descricao = dict["descricao"] as! String?
                            
                            if (tipo != nil)
                            {
                                if (tipo == "Cidade")
                                {
                                    self.cidades.append(descricao!)
                                    self.cidadesIds.append(id!)
                                    self.cidadesIdsUfs.append(id2!)
                                }
                                else if (tipo == "Uf")
                                {
                                    self.ufs.append(descricao!)
                                    self.ufsIds.append(id!)
                                }
                                else if (tipo == "Genero")
                                {
                                    self.generos.append(descricao!)
                                    self.generosIds.append(id!)
                                }
                                else if (tipo == "Raca")
                                {
                                    self.racas.append(descricao!)
                                    self.racasIds.append(id!)
                                }
                                else if (tipo == "Porte")
                                {
                                    self.portes.append(descricao!)
                                    self.portesIds.append(id!)
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
                        self.carrega(inicio: false)
                    }
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
    }
    
    func DonePickerRaca()
    {
        txtRaca.inputView?.removeFromSuperview()
        txtRaca.inputAccessoryView?.removeFromSuperview()
    }
    
    func DonePickerPorte()
    {
        txtPorte.inputView?.removeFromSuperview()
        txtPorte.inputAccessoryView?.removeFromSuperview()
    }
    
    func DonePickerCidade()
    {
        txtCidade.inputView?.removeFromSuperview()
        txtCidade.inputAccessoryView?.removeFromSuperview()
    }
    
    func DonePickerUf()
    {
        txtUF.inputView?.removeFromSuperview()
        txtUF.inputAccessoryView?.removeFromSuperview()
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
            txtGenero.text = generos[row]
            generosId = generosIds[row]
        }
        else if (pickerView.restorationIdentifier == "Porte")
        {
            txtPorte.text = portes[row]
            portesId = portesIds[row]
        }
        else if (pickerView.restorationIdentifier == "Cidade")
        {
            txtCidade.text =  cidadesAux[row]
            cidadesId = cidadesAuxIds[row]
        }
        else if (pickerView.restorationIdentifier == "Uf")
        {
            txtUF.text = ufs[row]
            ufsId = ufsIds[row]
            
            self.CarregaCidadesPeloUf()
        }
        else
        {
            txtRaca.text = racas[row]
            racasId = racasIds[row]
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
