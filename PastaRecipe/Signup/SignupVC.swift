//
//  SignupVC.swift
//  PastaRecipe
//
//  Created by Waqas on 15/12/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD

class SignupVC: UIViewController {
    
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet var SignUpBtn: UIButton!
    
    //Variables
    var dataDic:[String:Any]!
    var userData = LoginModel()
    //Constants
    let window = UIWindow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func SignUpBtn(_ sender: Any) {
        //Fields Validation
        if NameTF.text != "" && NameTF.text != " " && EmailTF.text != "" && EmailTF.text != " " && PasswordTF.text != "" && PasswordTF.text != " " {
            if EmailTF.isValidEmail(EmailTF.text!) {
                getEmailCode()
            } else {
                PopupHelper.showAlertControllerWithError(forErrorMessage: "please enter valid email", forViewController: self)
            }
            
        } else {
            PopupHelper.showAlertControllerWithError(forErrorMessage: "All fields are required", forViewController: self)
        }
    }//End Methods
    
}

//Helping Method's
extension SignupVC{
    
    func setupUI() {
        NameTF.setLeftPaddingPoints(8)
        NameTF.setRightPaddingPoints(8)
        EmailTF.setLeftPaddingPoints(8)
        EmailTF.setRightPaddingPoints(8)
        PasswordTF.setLeftPaddingPoints(8)
        PasswordTF.setRightPaddingPoints(8)
    }
    
    func getEmailCode(){
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork(){
                self.dataDic = [String:Any]()
                self.dataDic[Constant.user_email] = self.EmailTF.text!
                self.callWebService(.verifieduser, hud: hud)
            }
        }
    }
    
    func moveToVerifyEmailVC(code:String) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EmailVerificationViewController") as! EmailVerificationViewController
        controller.userData = self.userData
        controller.code = code
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK:-Api Methods Extension
extension SignupVC:WebServiceResponseDelegate {
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let service = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: dataDic, relatedViewController: self,hud: hud)
        service.delegateForWebServiceResponse = self
        service.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .verifieduser:
            
            if let data = dataDict as? Dictionary<String, Any>{
                if let error = data["error"] as? Int {
                    if error == 1{
                        if let msg = data["msg"] as? String {
                            hud.textLabel.text = msg
                            hud.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud.dismiss(afterDelay: 4, animated: true)
                        }
                    } else {
                        if let code = data["code"] as? String{
                            print(code)
                            let userDataObj = UserDetailModel(user_id: "1", user_name: self.NameTF.text!, user_email: self.EmailTF.text!, user_password: self.PasswordTF.text!, token_id: "", status: "", image_url: "", coins: "", plan_id: "", expired_date: "", user_type: "", verified_status: "", phone_number: "")
                            
                            let moreDetailObj = MoreDetailModel()
                            self.userData = LoginModel(user_detail: userDataObj, more_detail: moreDetailObj)
                            self.userData.user_detail.user_name = self.NameTF.text!
                            self.userData.user_detail.user_email = self.EmailTF.text!
                            self.userData.user_detail.user_password = self.PasswordTF.text!
                            moveToVerifyEmailVC(code: code)
                            hud.dismiss()
                        }
                    }
                } else {
                    hud.dismiss()
                }
            }
        default:
            hud.dismiss()
        }
    }
}
