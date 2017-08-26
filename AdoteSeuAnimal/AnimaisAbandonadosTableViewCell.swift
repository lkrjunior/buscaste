//
//  AnimaisAbandonadosTableViewCell.swift
//  AdoteSeuAnimal
//
//  Created by Luciano Rocha on 22/08/17.
//  Copyright © 2017 Luciano Rocha. All rights reserved.
//

import UIKit

class AnimaisAbandonadosTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDescricao: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblLocal: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
