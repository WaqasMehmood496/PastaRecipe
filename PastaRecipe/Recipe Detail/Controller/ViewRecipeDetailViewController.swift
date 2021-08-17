//
//  ViewRecipeDetailViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 16/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class ViewRecipeDetailViewController: UIViewController {

    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!

    var image = String()
    var name = String()
    var detail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        self.RecipeImage.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "101"))
        self.DescriptionLabel.text = detail
        self.TitleLabel.text = name
    }
    

}
