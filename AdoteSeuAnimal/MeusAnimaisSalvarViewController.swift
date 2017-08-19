//
//  MeusAnimaisSalvarViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 19/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class MeusAnimaisSalvarViewController: UIViewController {

    @IBAction func btnSairClick(_ sender: Any)
    {
        self.showVoltar()
    }
    
    @IBAction func btnSalvarClick(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
