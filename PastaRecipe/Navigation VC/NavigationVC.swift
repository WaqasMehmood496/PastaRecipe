//
//  NavigationVC.swift
//  PastaRecipe
//
//  Created by Waqas on 07/01/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.layoutIfNeeded()
        
    }
}
