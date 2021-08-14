//
//  EmailVerificationViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 05/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class EmailVerificationViewController: UIViewController {
    
    //IBOUTLET
    @IBOutlet weak var VerificationCode: UITextField!
    
    //CONSTANT
    
    //VARIABLE
    var code = String()
    var userData = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    //IBACTION
    @IBAction func VerifyBtnAction(_ sender: Any) {
        if let userEnterdCode = self.VerificationCode.text{
            if userEnterdCode == code {
                self.moveToAddressVC()
            } else {
                PopupHelper.showAlertControllerWithError(forErrorMessage: "Code not match with your email code", forViewController: self)
            }
        }
    }
    
    func moveToAddressVC() {
        let shippingVC = storyboard?.instantiateViewController(identifier: "ShippingAddressViewController") as! ShippingAddressViewController
        shippingVC.userData = self.userData
        self.navigationController?.pushViewController(shippingVC, animated: true)
    }
    
    func setupUI() {
        VerificationCode.setLeftPaddingPoints(8)
        VerificationCode.setRightPaddingPoints(8)
    }
}
