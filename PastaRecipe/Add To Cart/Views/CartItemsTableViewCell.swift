//
//  CartItemsTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 04/06/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class CartItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemTilte: UILabel!
    @IBOutlet weak var Coins: UILabel!
    @IBOutlet weak var ItemQuantity: UILabel!
    @IBOutlet weak var DecrementBtn: UIButton!
    @IBOutlet weak var IncrementBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
