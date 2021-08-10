//
//  EmailVerificationPopupViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 16/07/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class EmailVerificationPopupViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func OkBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ResendEmailBtnAction(_ sender: Any) {
    }
    
}
