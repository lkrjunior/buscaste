//
//  AnimaisAbandonadosSalvarViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 22/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class AnimaisAbandonadosSalvarViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var gerenciadorLocalizacao = CLLocationManager()
    
    @IBAction func btnSalvarClick(_ sender: Any)
    {
        self.Save()
    }
    @IBAction func btnFecharClick(_ sender: Any)
    {
        self.showVoltar()
    }
    
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var lblLocalizacao: UILabel!
    @IBOutlet weak var mkMapa: MKMapView!
    @IBOutlet weak var carregamento: UIActivityIndicatorView!
    
    var idAnimal : Int = 0
    var animalTipo : Int = 2
    var latitude : Double = 0
    var longitude : Double = 0
    var localizacao : String = ""
    var idPessoa : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.AjustaTextFields()
        self.AjustaOpcoesMapa()
        
    }
    
    func AjustaOpcoesMapa()
    {
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse
        {
            let altertaController = UIAlertController(title: "Permissão de localização", message: "Necessária permissão para acesso a sua localização!", preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString)
                {
                    UIApplication.shared.open( configuracoes as URL )
                }
            })
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            altertaController.addAction(acaoConfiguracoes)
            altertaController.addAction(acaoCancelar)
            
            present(altertaController, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacaoUsuario = locations.last
        
        latitude = (localizacaoUsuario?.coordinate.latitude)!
        longitude = (localizacaoUsuario?.coordinate.longitude)!
        
        let areaExibicao : MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        let localizacao : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let regiao : MKCoordinateRegion = MKCoordinateRegionMake(localizacao, areaExibicao)
        mkMapa.setRegion(regiao, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario!, completionHandler: { (detalhesLocal, erro) in
            if (erro == nil)
            {
                let dadosLocal = detalhesLocal?.first
                if dadosLocal != nil
                {
                    self.localizacao = (dadosLocal?.locality)! + "/" + (dadosLocal?.administrativeArea)!
                    self.lblLocalizacao.text = self.localizacao
                }
            }
            else
            {
                print(erro ?? "")
            }
        })
        
    }
    
    func AjustaTextFields()
    {
        lblLocalizacao.text = ""
        txtDescricao.delegate = self
        self.addToolBar(textField: txtDescricao)
    }
    
    func addToolBar(textField: UITextField)
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AnimaisAbandonadosSalvarViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AnimaisAbandonadosSalvarViewController.cancelPressed))
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

    func showVoltar()
    {
        gerenciadorLocalizacao.stopUpdatingLocation()
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        tb.selectedIndex = 2
        self.present(tb, animated: true, completion: nil)
    }
    
    func Save()
    {
        
        Util.carrega(carregamento: self.carregamento, view: self, inicio: true)
        
        //Salvar o animal abandonado
        let descricaoString = self.txtDescricao.text! == "" ? "" : self.txtDescricao.text!
        let paramsCad = ["id": self.idAnimal,
                         "animalTipo": self.animalTipo,
                         "pessoa": ["idPessoa": self.idPessoa],
                         "descricao": descricaoString,
                         "latitude": self.latitude,
                         "longitude": self.longitude,
                         "localizacao": self.localizacao,
                         ] as [String : AnyObject]
        
        Alamofire.request("http://lkrjunior-com.umbler.net/api/Animal/SaveAnimal", method: .post, parameters: paramsCad, encoding: URLEncoding.httpBody).responseJSON { response in
            
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("Response: \(String(describing: json))")
                
                let dict = Util.converterParaDictionary(text: json!)
                let status = dict?["status"] as! Int
                if status == 1
                {
                    Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                    
                    self.showVoltar()
                }
                else
                {
                    Util.carrega(carregamento: self.carregamento, view: self, inicio: false)
                }
            }
        }
        
    }

}
