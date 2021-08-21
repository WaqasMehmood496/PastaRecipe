//
//  ProductsTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 20/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var RecipeName: UILabel!
    @IBOutlet weak var RecipeDetail: UILabel!
    @IBOutlet weak var RecipePrice: UILabel!
    @IBOutlet weak var AddToCartBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
