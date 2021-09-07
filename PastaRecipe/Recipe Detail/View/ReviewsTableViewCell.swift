//
//  ReviewsTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 30/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class ReviewsTableViewCell: UITableViewCell {

//    @IBOutlet weak var UserImage: UIImageView!
//    @IBOutlet weak var NameLabel: UILabel!
//    @IBOutlet weak var ReviewLabel: UILabel!
    
    @IBOutlet weak var ReviewsCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
