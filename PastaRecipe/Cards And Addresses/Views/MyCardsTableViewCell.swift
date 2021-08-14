//
//  MyCardsTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 10/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class MyCardsTableViewCell: UITableViewCell {
    
    //IBOUTET'S
    @IBOutlet weak var CardNumberLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CVCLabel: UILabel!
    @IBOutlet weak var DefaultCardLabel: UILabel!
    @IBOutlet weak var SetDefaultCardBtn: UIButton!
    @IBOutlet weak var EditBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
