//
//  MeusAnimaisViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 19/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class MeusAnimaisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableMeusAnimais: UITableView!
    var carregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        //tableMeusAnimais.layer.borderColor = UIColor.black.cgColor
        //tableMeusAnimais.layer.borderWidth = 1.0

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
        }
        else
        {
            carregamento.stopAnimating()
        }
    }

    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMeusAnimais", for: indexPath) as! MeusAnimaisTableViewCell
        cell.lblDescricao.text = "teste"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.Ajusta()
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("2")
        return 2
    }

}
