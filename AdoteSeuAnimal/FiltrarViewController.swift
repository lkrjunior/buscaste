//
//  FiltrarViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 06/09/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class FiltrarViewController: UIViewController {
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
        
    }
    @IBAction func btnVoltarClick(_ sender: Any)
    {
        self.showVoltar()
    }
    @IBAction func btnPesquisarClick(_ sender: Any)
    {
        
    }
    
    func showVoltar()
    {
        let tb = self.storyboard?.instantiateViewController(withIdentifier:"TabBarScene") as! TabBarController
        tb.selectedIndex = 0
        self.present(tb, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.AjustarCampos()
    }

    func AjustarCampos()
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
