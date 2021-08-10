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
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func CustomerPackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.subsctiptionChoiceDelegate(type: Constant.custom_Pack)
    }
    
    @IBAction func CrossBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
