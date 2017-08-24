//
//  AnimaisAbandonadosViewController.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 22/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class AnimaisAbandonadosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAnimaisAbandonados", for: indexPath) as! AnimaisAbandonadosTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
