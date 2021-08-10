//
//  LoginPageVC.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class LoginPageVC: UIViewController {
    
    //CONSTANT'S
    let loginVCIdentifier = "LoginVC"
    let signupVCIdentifier = "SignupVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func SignInBtn(_ sender: Any) {
        let login = storyboard?.instantiateViewController(identifier: loginVCIdentifier) as! LoginVC
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    @IBAction func CreateAccountBtn(_ sender: Any) {
        let login = storyboard?.instantiateViewController(identifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(login, animated: true)
    }
}
