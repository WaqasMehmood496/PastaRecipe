//
//  ReviewCollectionViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 06/09/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import Cosmos

class ReviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ReviewRating: CosmosView!
    @IBOutlet weak var ReviewTitle: UILabel!
    @IBOutlet weak var ReviewDetail: UILabel!
    @IBOutlet weak var ReviewUser: UILabel!
}
