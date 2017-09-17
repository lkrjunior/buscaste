//
//  FiltrosTableViewCell.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 22/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class FiltrosTableViewCell: UITableViewCell {
    @IBOutlet weak var lblGenero: UILabel!
    @IBOutlet weak var lblIdade: UILabel!
    @IBOutlet weak var lblPeso: UILabel!
    @IBOutlet weak var lblDeslize: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
