//
//  SubsPlanTableViewCell.swift
//  PastaRecipe
//
//  Created by Waqas on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class SubsPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var subscribeBTn: UIButton!
    @IBOutlet weak var TotalCostLbl: UILabel!
    @IBOutlet weak var PlanImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
