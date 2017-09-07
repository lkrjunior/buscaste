//
//  FiltrarViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 06/09/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import Alamofire

class FiltrarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBAction func doacaoClick(_ sender: Any)
    {
        self.clickAnimal()
    }
    @IBAction func abandonadoClick(_ sender: Any)
    {
        self.clickAnimal()
    }
    @IBOutlet weak var carregamento: UIActivityIndicatorView!
    @IBOutlet weak var txtGenero: UITextField!
    @IBOutlet weak var txtRaca: UITextField!
    @IBOutlet weak var txtPorte: UITextField!
    @IBOutlet weak var txtUf: UITextField!
    @IBOutlet weak var txtCidade: UITextField!
    @IBOutlet weak var txtIdadeMin: UITextField!
    @IBOutlet weak var txtIdadeMax: UITextField!
    @IBOutlet weak var txtPesoMin: UITextField!
    @IBOutlet weak var txtPesoMax: UITextField!
    @IBOutlet weak var switchDoacao: UISwitch!
    @IBOutlet weak var switchAbandonado: UISwitch!
    @IBAction func btnLimparClick(_ sender: Any)
    {
        self.Limpar()
        self.clickAnimal()
    }
    @IBAction func btnVoltarClick(_ sender: Any)
    {
        self.showVoltar()
    }
    @IBAction func btnPesquisarClick(_ sender: Any)
    {
        self.Pesquisar()
    }
    
    func clickAnimal()
    {
        if (switchAbandonado.isOn && !switchDoacao.isOn)
        {
            txtGenero.isEnabled = false
            txtRaca.isEnabled = false
            txtPorte.isEnabled = false
            txtUf.isEnabled = false
            txtCidade.isEnabled = false
            txtIdadeMin.isEnabled = false
            txtIdadeMax.isEnabled = false
            txtPesoMin.isEnabled = false
            txtPesoMax.isEnabled = false
        }
        else
        {
            txtGenero.isEnabled = true
            txtRaca.isEnabled = true
            txtPorte.isEnabled = true
            txtUf.isEnabled = true
            txtCidade.isEnabled = true
            txtIdadeMin.isEnabled = true
            txtIdadeMax.isEnabled = true
            txtPesoMin.isEnabled = true
            txtPesoMax.isEnabled = true
        }
    }
    
    func Pesquisar()
    {
        if !switchDoacao.isOn && !switchAbandonado.isOn
        {
            Util.AlertaErroView(mensagem: "Informe pelo menos um tipo", view: self, indicatorView: nil)
            return
        }
        
        let filtros : ClassFiltrar = ClassFiltrar()
        
        filtros.fPesquisar = true
        if (switchDoacao.isOn && switchAbandonado.isOn)
        {
            filtros.fTipoAnimal = 0
        }
        else if (switchDoacao.isOn)
        {
            filtros.fTipoAnimal = 1
        }
        else if (switchAbandonado.isOn)
        {
            filtros.fTipoAnimal = 2
        }
        filtros.fIdGenero = self.generosId
        filtros.fIdRaca = self.racasId
        filtros.fIdPorte = self.portesId
        filtros.fIdUf = self.ufsId
        filtros.fIdCidade = self.cidadesId
        
        let pesoMinString = self.txtPesoMin.text!.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
        let pesoMaxString = self.txtPesoMax.text!.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
        let idadeMin = self.txtIdadeMin.text! == "" ? "0" : self.txtIdadeMin.text!
        let idadeMax = self.txtIdadeMax.text! == "" ? "0" : self.txtIdadeMax.text!
        let pesoMin = pesoMinString == "" ? "0" : pesoMinString
        let pesoMax = pesoMaxString == "" ? "0" : pesoMaxString
        
        filtros.fIdadeMin = Int(idadeMin)!
        filtros.fIdadeMax = Int(idadeMax)!
        filtros.fPesoMin = Double(pesoMin)!
        filtros.fPesoMax = Double(pesoMax)!
        filtros.genero = txtGenero.text!
        filtros.raca = txtRaca.text!
        filtros.porte = txtPorte.text!
        filtros.uf = txtUf.text!
        filtros.cidade = txtCidade.text!
        
        if (filtros.fTipoAnimal == 2)
        {
            filtros.fIdGenero = 0
            filtros.fIdRaca = 0
            filtros.fIdPorte = 0
            filtros.fIdUf = 0
            filtros.fIdCidade = 0
            filtros.fIdadeMin = 0
            filtros.fIdadeMax = 0
            filtros.fPesoMin = 0
            filtros.fPesoMax = 0
            filtros.genero = ""
            filtros.raca = ""
            filtros.porte = ""
            filtros.uf = ""
            filtros.cidade = ""
        }
        
        Util.FiltrarSave(filtros: filtros, limpar: false)
        
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        tb.selectedIndex = 0
        self.present(tb, animated: true, completion: nil)
    }
    
    func Limpar(switchNao : Bool = false)
    {
        self.generosId = 0
        self.racasId = 0
        self.portesId = 0
        self.ufsId = 0
        self.cidadesId = 0
        self.txtGenero.text = ""
        self.txtRaca.text = ""
        self.txtPorte.text = ""
        self.txtUf.text = ""
        self.txtCidade.text = ""
        self.txtIdadeMin.text = ""
        self.txtIdadeMax.text = ""
        self.txtPesoMin.text = ""
        self.txtPesoMax.text = ""
        if switchNao == false
        {
            switchDoacao.isOn = true
            switchAbandonado.isOn = true
        }
        self.CarregaCombos()
        Util.FiltrarSave(filtros: ClassFiltrar(), limpar: true)
    }
    
    func showVoltar()
    {
        //Util.FiltrarSave(filtros: ClassFiltrar(), limpar: true)
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        tb.selectedIndex = 0
        self.present(tb, animated: true, completion: nil)
    }
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.CarregaCombos()
        self.CarregaJSONCombos()
        self.AjustarCampos()
        self.CarregaFiltros()
    }
    
    func CarregaFiltros()
    {
        let filtros = Util.FiltrarGet()
        self.generosId = filtros.fIdGenero
        self.racasId = filtros.fIdRaca
        self.portesId = filtros.fIdPorte
        self.ufsId = filtros.fIdUf
        self.cidadesId = filtros.fIdCidade
        self.txtGenero.text = filtros.genero
        self.txtRaca.text = filtros.raca
        self.txtPorte.text = filtros.porte
        self.txtUf.text = filtros.uf
        self.txtCidade.text = filtros.cidade
        self.txtIdadeMin.text = filtros.fIdadeMin == 0 ? "" : String(filtros.fIdadeMin)
        self.txtIdadeMax.text = filtros.fIdadeMax == 0 ? "" : String(filtros.fIdadeMax)
        self.txtPesoMin.text = filtros.fPesoMin == 0 ? "" : String(filtros.fPesoMin)
        self.txtPesoMax.text = filtros.fPesoMax == 0 ? "" : String(filtros.fPesoMax)
        
        if filtros.fTipoAnimal == 1
        {
            switchDoacao.isOn = true
            switchAbandonado.isOn = false
        }
        else if filtros.fTipoAnimal == 2
        {
            switchDoacao.isOn = false
            switchAbandonado.isOn = true
        }
        else
        {
            switchDoacao.isOn = true
            switchAbandonado.isOn = true
        }
        self.clickAnimal()
    }

    func AjustarCampos()
    {
        txtGenero.placeholder = "Genero"
        txtRaca.placeholder = "Raça"
        txtPorte.placeholder = "Porte"
        txtUf.placeholder = "UF"
        txtCidade.placeholder = "Cidade"
        txtIdadeMin.placeholder = "Idade mínima"
        txtIdadeMax.placeholder = "Idade máxima"
        txtPesoMin.placeholder = "Peso mínima"
        txtPesoMax.placeholder = "Peso máxima"
        
        txtIdadeMin.keyboardType = .numberPad
        txtIdadeMax.keyboardType = .numberPad
        txtPesoMin.keyboardType = .decimalPad
        txtPesoMax.keyboardType = .decimalPad
        self.addToolBar(textField: txtIdadeMin)
        self.addToolBar(textField: txtIdadeMax)
        self.addToolBar(textField: txtPesoMin)
        self.addToolBar(textField: txtPesoMax)
        
        self.txtGenero.restorationIdentifier = "genero"
        self.txtRaca.restorationIdentifier = "raca"
        self.txtPorte.restorationIdentifier = "porte"
        self.txtUf.restorationIdentifier = "uf"
        self.txtCidade.restorationIdentifier = "cidade"
        
        self.txtGenero.addTarget(self, action: #selector(FiltrarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtRaca.addTarget(self, action: #selector(FiltrarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtPorte.addTarget(self, action: #selector(FiltrarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtUf.addTarget(self, action: #selector(FiltrarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtCidade.addTarget(self, action: #selector(FiltrarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        
        self.txtGenero.delegate = self
        self.txtRaca.delegate = self
        self.txtPorte.delegate = self
        self.txtUf.delegate = self
        self.txtCidade.delegate = self
        self.txtIdadeMin.delegate = self
        self.txtIdadeMax.delegate = self
        self.txtPesoMin.delegate = self
        self.txtPesoMax.delegate = self
        
        self.txtGenero.tag = 0
        self.txtRaca.tag = 1
        self.txtPorte.tag = 2
        self.txtUf.tag = 3
        self.txtCidade.tag = 4
        self.txtIdadeMin.tag = 5
        self.txtIdadeMax.tag = 6
        self.txtPesoMin.tag = 7
        self.txtPesoMax.tag = 8
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
            if (valor == "" && cidades.count > 0)
            {
                textField.text = cidades[0]
                cidadesId = cidadesIds[0]
            }
            return
        default:
            return
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
    
    func addToolBar(textField: UITextField)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrarViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FiltrarViewController.cancelPressed))
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
            txtUf.text = ufs[row]
            ufsId = ufsIds[row]
            
            self.CarregaCidadesPeloUf()
        }
        else
        {
            txtRaca.text = racas[row]
            racasId = racasIds[row]
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
    
    func CarregaJSONCombos()
    {
        Util.carrega(carregamento: self.carregamento, view: self, inicio: true)
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/Combos/GetCombos", method: .get, parameters: nil, encoding: URLEncoding.httpBody).responseJSON
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
                        Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                    }
                }
                else
                {
                    Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                }
        }
        
    }
    
    func CarregaCombos()
    {
        Util.carrega(carregamento:self.carregamento, view: self, inicio: true)
        
        let toolBarGenero = UIToolbar()
        toolBarGenero.barStyle = UIBarStyle.default
        toolBarGenero.isTranslucent = true
        toolBarGenero.tintColor = UIColor.blue
        toolBarGenero.sizeToFit()
        
        let doneButtonGenero = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrarViewController.DonePickerGenero))
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
        
        let doneButtonRaca = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrarViewController.DonePickerRaca))
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
        
        let doneButtonPorte = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrarViewController.DonePickerPorte))
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
        
        let doneButtonUf = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrarViewController.DonePickerUf))
        let spaceButtonUf = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBarUf.setItems([spaceButtonUf, doneButtonUf], animated: false)
        toolBarUf.isUserInteractionEnabled = true
        
        let pickerViewUf = UIPickerView()
        pickerViewUf.delegate = self
        pickerViewUf.restorationIdentifier = "Uf"
        pickerViewUf.showsSelectionIndicator = true
        
        txtUf.inputView = pickerViewUf
        txtUf.inputAccessoryView = toolBarUf
        
        
        let toolBarCidade = UIToolbar()
        toolBarCidade.barStyle = UIBarStyle.default
        toolBarCidade.isTranslucent = true
        toolBarCidade.tintColor = UIColor.blue
        toolBarCidade.sizeToFit()
        
        let doneButtonCidade = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrarViewController.DonePickerCidade))
        let spaceButtonCidade = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBarCidade.setItems([spaceButtonCidade, doneButtonCidade], animated: false)
        toolBarCidade.isUserInteractionEnabled = true
        
        let pickerViewCidade = UIPickerView()
        pickerViewCidade.delegate = self
        pickerViewCidade.restorationIdentifier = "Cidade"
        pickerViewCidade.showsSelectionIndicator = true
        
        txtCidade.inputView = pickerViewCidade
        txtCidade.inputAccessoryView = toolBarCidade
        
        Util.carrega(carregamento:self.carregamento, view: self, inicio: false)
    }
    
    func DonePickerGenero()
    {
        txtGenero.inputView?.removeFromSuperview()
        txtGenero.inputAccessoryView?.removeFromSuperview()
        //if textFieldShouldReturn(txtGenero) {}
    }
    
    func DonePickerRaca()
    {
        txtRaca.inputView?.removeFromSuperview()
        txtRaca.inputAccessoryView?.removeFromSuperview()
        //if textFieldShouldReturn(txtRaca) {}
    }
    
    func DonePickerPorte()
    {
        txtPorte.inputView?.removeFromSuperview()
        txtPorte.inputAccessoryView?.removeFromSuperview()
        //if textFieldShouldReturn(txtPorte) {}
    }
    
    func DonePickerCidade()
    {
        txtCidade.inputView?.removeFromSuperview()
        txtCidade.inputAccessoryView?.removeFromSuperview()
        //if textFieldShouldReturn(txtCidade) {}
    }
    
    func DonePickerUf()
    {
        txtUf.inputView?.removeFromSuperview()
        txtUf.inputAccessoryView?.removeFromSuperview()
        //if textFieldShouldReturn(txtUf) {}
    }

}
