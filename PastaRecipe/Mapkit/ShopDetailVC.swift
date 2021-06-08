//
//  ShopDetailVC.swift
//  PastaRecipe
//
//  Created by Waqas on 17/12/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit

class ShopDetailVC: UIViewController {
    
    @IBOutlet weak var TitleLable: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    var mapmarkerObj = MapMarkerModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(mapmarkerObj.title)
        TitleLable.text = mapmarkerObj.title
        AddressLabel.text = mapmarkerObj.address
        DistanceLabel.text = mapmarkerObj.distance
        DescriptionLabel.text = mapmarkerObj.descrip
        // Do any additional setup after loading the view.
    }

}
