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

class AnimaisAbandonadosSalvarViewController: UIViewController {
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

        lblLocalizacao.text = ""
    }

    func showVoltar()
    {
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        tb.selectedIndex = 2
        self.present(tb, animated: true, completion: nil)
    }
    

}
