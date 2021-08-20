//
//  SubscriptionPopupViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 04/06/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class SubscriptionPopupViewController: UIViewController {

    var delegate:SubscriptioPopDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func CrossBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
