//
//  CustomTableViewCell.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 27/05/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var lblAnimal: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblGenero: UILabel!
    @IBOutlet weak var lblRaca: UILabel!
    @IBOutlet weak var lblDesricao: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
