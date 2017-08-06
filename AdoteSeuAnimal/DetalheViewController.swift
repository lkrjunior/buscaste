//
//  DetalheViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 28/05/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetalheViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    var carregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var nome : String = ""
    var tipoAnimal : Int = 0
    var idAnimal : Int = 0
    var latitude : Double = 0
    var longitude : Double = 0
    var foto : [UInt8] = []
    
    var dNome : String = ""
    var dGenero : String = ""
    var dRaca : String = ""
    var dIdade : String = ""
    var dPorte : String = ""
    var dPeso : String = ""
    var dCidade : String = ""
    var dVacina : String = ""
    var dTelefone : String = ""
    var dEmail : String = ""
    var telephoneLink : String = ""
    var emailLink : String = ""
    var nomeLink : String = ""
    
    @IBOutlet weak var detalheTableViewOutlet: UITableView!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func buttonTelephoneClick(_ sender: Any)
    {
        let url = URL(string: "tel://" + telephoneLink.replacingOccurrences(of: " ", with: ""))!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func buttonEmailClick(_ sender: Any)
    {
        let subject = "Quero adotar " + nomeLink
        let body = ""
        let coded = "mailto:" + emailLink + "?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: coded)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
            //UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else
        {
            carregamento.stopAnimating()
            //UIApplication.shared.endIgnoringInteractionEvents()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        
        if self.tipoAnimal == 1
        {
            self.mapKitView.isHidden = true
        }
        else
        {
            self.imageView.isHidden = true
        }
        
        self.GetDadosAnimal()
        
    }
    
    func imageFromByteArray(data: [UInt8], size: CGSize) -> UIImage? {
        guard data.count >= 8 else {
            print("data too small")
            return nil
        }
        
        let width  = Int(size.width)
        let height = Int(size.height)
        
        NSLog(String(data.count))
        guard data.count >= width * height * 4 else {
            print("data not large enough to hold \(width)x\(height)")
            return nil
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let msgData = NSMutableData(bytes: data, length: data.count)
        
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let bitmapContext = CGContext(data: msgData.mutableBytes, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width*4, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("context is nil")
            return nil
        }
        
        let dataPointer = bitmapContext.data?.assumingMemoryBound(to: UInt8.self)
        
        for index in 0 ..< width * height * 4  {
            dataPointer?[index] = data[index]
        }
        
        guard let cgImage = bitmapContext.makeImage() else {
            print("image is nil")
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func readJSONObjectAnimal(object: [String: AnyObject]) {
        guard let lista = object["lista"] as? [[String: AnyObject]] else
        { return }
        
        for listaObj in lista {
            guard let animalTipo = listaObj["animalTipoInt"] as? Int else { return }
            guard let id = listaObj["id"] as? Int else { return }
            if animalTipo == 1
            {
                var listaDic = listaObj as Dictionary
                if !(listaDic["foto"] is NSNull)
                {
                    guard let fotoObj = listaObj["foto"] as? [String : AnyObject] else { return }
                    guard let idFoto = fotoObj["idFoto"] as? Int else { return }
                    if idFoto > 0
                    {
                        guard let fotoByte = fotoObj["foto"] as? String else { return }
                        guard let tipoFoto = fotoObj["tipo"] as? String else { return }
                        NSLog(fotoByte)
                        NSLog(tipoFoto)
                    
                        mapKitView.isHidden = true
                    
                        if let fileBase64 = fotoObj["foto"] as? String {
                            DispatchQueue.main.async() {
                                let imageArray = NSData(base64Encoded: fileBase64, options: [])
                                self.imageView.image = UIImage(data: imageArray! as Data)
                                self.imageView.reloadInputViews()
                                self.carrega(inicio: false)
                            }
                        
                        } else {
                            print("missing `file` entry")
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async() {
                            self.carrega(inicio: false)
                        }
                    }
                    
                    
                    guard let oNome = listaObj["nome"] as? String else { return }
                    dNome = "Nome: " + oNome
                    nomeLink = oNome
                    
                    guard let oGenero = listaObj["genero"] as? [String : AnyObject] else { return }
                    guard let oIdGenero = oGenero["idGenero"] as? Int else { return }
                    if oIdGenero > 0
                    {
                        guard let oDescGenero = oGenero["genero"] as? String else { return }
                        dGenero = oDescGenero
                    }
                    
                    guard let oRaca = listaObj["raca"] as? [String : AnyObject] else { return }
                    guard let oIdRaca = oRaca["idRaca"] as? Int else { return }
                    if oIdRaca > 0
                    {
                        guard let oDescRaca = oRaca["raca"] as? String else { return }
                        dRaca = oDescRaca
                    }

                    guard let oIdade = listaObj["idade"] as? Int else { return }
                    dIdade = String(oIdade) + " anos"
                    
                    guard let oPorte = listaObj["porte"] as? [String : AnyObject] else { return }
                    guard let oIdPorte = oPorte["idPorte"] as? Int else { return }
                    if oIdPorte > 0
                    {
                        guard let oDescPorte = oPorte["porte"] as? String else { return }
                        dPorte = "Porte " + oDescPorte
                    }
                    
                    guard let oPeso = listaObj["peso"] as? Double else { return }
                    dPeso = String(oPeso) + " kg"
                    
                    guard let oCidade = listaObj["cidade"] as? [String : AnyObject] else { return }
                    guard let oIdCidade = oCidade["idCidade"] as? Int else { return }
                    if oIdCidade > 0
                    {
                        guard let oDescCidade = oCidade["cidade"] as? String else { return }
                        guard let oUF = oCidade["uf"] as? [String : AnyObject] else { return }
                        guard let oDescUF = oUF["uf"] as? String else { return }
                        dCidade = oDescCidade + "/" + oDescUF
                    }
                    
                    guard let oVacina = listaObj["vacinas"] as? String else { return }
                    dVacina = "Vacinas: " + oVacina
                    
                    guard let oPessoa = listaObj["pessoa"] as? [String : AnyObject] else { return }
                    guard let oNomePessoa = oPessoa["nome"] as? String else { return }
                    guard let oTelefone = listaObj["telefone"] as? String else { return }
                    dTelefone = "Contato: " + oNomePessoa + " (" + oTelefone + ")"
                    telephoneLink = oTelefone
                    
                    guard let oEmail = listaObj["email"] as? String else { return }
                    dEmail = "E-mail: " + oEmail
                    emailLink = oEmail
                    
                }
                else
                {
                    DispatchQueue.main.async() {
                        self.carrega(inicio: false)
                    }
                }

            }
            else
            {
                imageView.isHidden = true
                guard let latitude = listaObj["latitude"] as? Double else { return }
                guard let longitude = listaObj["longitude"] as? Double else { return }
                NSLog(String(latitude))
                NSLog(String(longitude))
                
                DispatchQueue.main.async() {
                    let annotation = MKPointAnnotation()
                    let centerCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.coordinate = centerCoordinate
                    annotation.title = "Localizacao"
                    self.mapKitView.addAnnotation(annotation)
                
                    let pinToZoomOn = annotation
                    //let span = MKCoordinateSpanMake(0.1, 0.1)
                    let span = MKCoordinateSpanMake(0.005, 0.005)
                    let region = MKCoordinateRegion(center: pinToZoomOn.coordinate, span: span)
                    self.mapKitView.setRegion(region, animated: true)
                    self.carrega(inicio: false)
                }
            }
            //guard let data = listaObj["dataFormatada"] as? String else { return }
            //guard let desc = listaObj["descricao"] as? String else { break }
            
        }

    }

    
    func GetDadosAnimal()
    {
        self.carrega(inicio: true)
        let url = "http://lkrjunior-com.umbler.net/api/AnimalGet/GetAnimalId?idTipo=" + String(tipoAnimal) + "&idAnimal=" + String (idAnimal)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 90
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    self.readJSONObjectAnimal(object: dictionary)
                    
                    DispatchQueue.main.async() {
                        self.detalheTableViewOutlet.delegate = self
                        self.detalheTableViewOutlet.dataSource = self
                        self.detalheTableViewOutlet.reloadData()
                        
                    }
                }
            } catch {
                

                // Handle Error
            }
            
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellDetalhe", for: indexPath) as! DetalheTableViewCell
        
        cell.lblId.text = nome
        
        if self.tipoAnimal == 1
        {
            cell.lblNome.isHidden = false
            cell.lblGenero.isHidden = false
            cell.lblRaca.isHidden = false
            cell.lblIdade.isHidden = false
            cell.lblPorte.isHidden = false
            cell.lblPeso.isHidden = false
            cell.lblCidade.isHidden = false
            cell.lblVacinas.isHidden = false
            cell.lblTelefone.isHidden = false
            cell.lblEmail.isHidden = false
        }
        else
        {
            cell.lblNome.isHidden = true
            cell.lblGenero.isHidden = true
            cell.lblRaca.isHidden = true
            cell.lblIdade.isHidden = true
            cell.lblPorte.isHidden = true
            cell.lblPeso.isHidden = true
            cell.lblCidade.isHidden = true
            cell.lblVacinas.isHidden = true
            cell.lblTelefone.isHidden = true
            cell.lblEmail.isHidden = true
        }
        cell.lblNome.text = dNome
        cell.lblGenero.text = dGenero
        cell.lblRaca.text = dRaca
        cell.lblIdade.text = dIdade
        cell.lblPorte.text = dPorte
        cell.lblPeso.text = dPeso
        cell.lblCidade.text = dCidade
        cell.lblVacinas.text = dVacina
        cell.lblTelefone.text = dTelefone
        cell.lblEmail.text = dEmail
        cell.buttonMail.isHidden = false
        cell.buttonTelephone.isHidden = false
        cell.buttonTelephone.frame.size = CGSize(width: 36, height: 36)
        cell.buttonMail.frame.size = CGSize(width: 36, height: 36)
        
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


}
