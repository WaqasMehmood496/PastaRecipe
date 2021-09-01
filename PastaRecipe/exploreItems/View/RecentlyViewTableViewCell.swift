//
//  RecentlyViewTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 31/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class RecentlyViewTableViewCell: UITableViewCell {

    @IBOutlet weak var RecentlyViewCollectionVIew: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
