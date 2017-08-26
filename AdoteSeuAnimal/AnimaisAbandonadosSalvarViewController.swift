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

class AnimaisAbandonadosSalvarViewController: UIViewController, UITextFieldDelegate {
    @IBAction func btnSalvarClick(_ sender: Any)
    {
        
    }
    @IBAction func btnFecharClick(_ sender: Any)
    {
        self.showVoltar()
    }
    
    @IBOutlet weak var txtDescricao: UITextField!
    @IBOutlet weak var lblLocalizacao: UILabel!
    @IBOutlet weak var mkMapa: MKMapView!
    @IBOutlet weak var carregamento: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.AjustaTextFields()
        
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
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        tb.selectedIndex = 2
        self.present(tb, animated: true, completion: nil)
    }
    

}
