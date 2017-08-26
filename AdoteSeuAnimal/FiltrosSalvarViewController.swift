//
//  FiltrosSalvarViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 22/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import Alamofire

class FiltrosSalvarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBAction func lblFecharClick(_ sender: Any)
    {
        self.showVoltar()
    }
    @IBOutlet weak var btnSalvarClick: UIButton!
    @IBAction func btnSalvar_Click(_ sender: Any)
    {
        
    }

    @IBOutlet weak var txtGenero: UITextField!
    @IBOutlet weak var txtRaca: UITextField!
    @IBOutlet weak var txtPorte: UITextField!
    @IBOutlet weak var txtIdadeMim: UITextField!
    @IBOutlet weak var txtIdadeMax: UITextField!
    @IBOutlet weak var txtPesoMin: UITextField!
    @IBOutlet weak var txtPesoMax: UITextField!
    @IBOutlet weak var carregamento: UIActivityIndicatorView!
    
    var generos = [String]()
    var generosIds = [Int]()
    var generosId : Int = 0
    var racas = [String]()
    var racasIds = [Int]()
    var racasId : Int = 0
    var portes = [String]()
    var portesIds = [Int]()
    var portesId : Int = 0
    
    var idPessoa : Int = 0
    var idFiltro : Int = 0
    var carregarDados : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CarregaCombos()
        self.CarregaJSONCombos()
        self.AjustaTextFields()
    }
    
    func CarregaJSONCombos()
    {
        Util.carrega(carregamento: self.carregamento, view: self, inicio: true)
        
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
                            let tipo = Util.JSON_RetornaString(dict: dict, campo: "tipo")
                            let id = Util.JSON_RetornaInt(dict: dict, campo: "id")
                            let descricao = Util.JSON_RetornaString(dict: dict, campo: "descricao")
                            
                            if (tipo != "")
                            {
                                if (tipo == "Genero")
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
                            }
                        }
                        Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                    }
                }
        }
        
    }
    
    func AjustaTextFields()
    {
        txtIdadeMim.keyboardType = .numberPad
        txtIdadeMax.keyboardType = .numberPad
        txtPesoMin.keyboardType = .decimalPad
        txtPesoMax.keyboardType = .decimalPad
        self.addToolBar(textField: txtIdadeMim)
        self.addToolBar(textField: txtIdadeMax)
        self.addToolBar(textField: txtPesoMin)
        self.addToolBar(textField: txtPesoMax)
        
        self.txtGenero.restorationIdentifier = "genero"
        self.txtRaca.restorationIdentifier = "raca"
        self.txtPorte.restorationIdentifier = "porte"
        
        self.txtGenero.addTarget(self, action: #selector(FiltrosSalvarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtRaca.addTarget(self, action: #selector(FiltrosSalvarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        self.txtPorte.addTarget(self, action: #selector(FiltrosSalvarViewController.textFieldTouchInside(textField:)), for: UIControlEvents.touchDown)
        
        self.txtGenero.delegate = self
        self.txtRaca.delegate = self
        self.txtPorte.delegate = self
        self.txtIdadeMim.delegate = self
        self.txtIdadeMax.delegate = self
        self.txtPesoMin.delegate = self
        self.txtPesoMax.delegate = self
        
        self.txtGenero.tag = 0
        self.txtRaca.tag = 1
        self.txtPorte.tag = 2
        self.txtIdadeMim.tag = 3
        self.txtIdadeMax.tag = 4
        self.txtPesoMin.tag = 5
        self.txtPesoMax.tag = 6
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
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func addToolBar(textField: UITextField)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrosSalvarViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FiltrosSalvarViewController.cancelPressed))
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
    
    func CarregaCombos()
    {
        Util.carrega(carregamento: carregamento, view: self, inicio: true)
        
        let toolBarGenero = UIToolbar()
        toolBarGenero.barStyle = UIBarStyle.default
        toolBarGenero.isTranslucent = true
        toolBarGenero.tintColor = UIColor.blue
        toolBarGenero.sizeToFit()
        
        let doneButtonGenero = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrosSalvarViewController.DonePickerGenero))
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
        
        let doneButtonRaca = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrosSalvarViewController.DonePickerRaca))
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
        
        let doneButtonPorte = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(FiltrosSalvarViewController.DonePickerPorte))
        let spaceButtonPorte = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBarPorte.setItems([spaceButtonPorte, doneButtonPorte], animated: false)
        toolBarPorte.isUserInteractionEnabled = true
        
        let pickerViewPorte = UIPickerView()
        pickerViewPorte.delegate = self
        pickerViewPorte.restorationIdentifier = "Porte"
        pickerViewPorte.showsSelectionIndicator = true
        
        txtPorte.inputView = pickerViewPorte
        txtPorte.inputAccessoryView = toolBarPorte
        

        Util.carrega(carregamento: carregamento, view: self, inicio: false)
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

    
    func showVoltar()
    {
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        tb.selectedIndex = 3
        self.present(tb, animated: true, completion: nil)
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
        else
        {
            txtRaca.text = racas[row]
            racasId = racasIds[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
