//
//  SelectedProductTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 30/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class SelectedProductTableViewCell: UITableViewCell {

    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var AddCartBtn: UIButton!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
