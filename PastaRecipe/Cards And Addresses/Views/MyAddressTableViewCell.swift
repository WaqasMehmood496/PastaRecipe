//
//  MyAddressTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 10/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class MyAddressTableViewCell: UITableViewCell {
    
    //IBOUTLETS
    @IBOutlet weak var ZipCodeLabel: UILabel!
    @IBOutlet weak var CountryLabel: UILabel!
    @IBOutlet weak var StateLabel: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var DefaultAddressLabel: UILabel!
    @IBOutlet weak var SetDefaultAddressBtn: UIButton!
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
