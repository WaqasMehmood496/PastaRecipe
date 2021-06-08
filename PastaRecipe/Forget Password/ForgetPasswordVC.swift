//
//  ForgetPasswordVC.swift
//  PastaRecipe
//
//  Created by Waqas on 16/12/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var ForgetBtn: UIButton!
    
    var attrs = [
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0),
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    var attributedString = NSMutableAttributedString(string:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uiSetup()
        
    }
    
    @IBAction func SendEmailBtn(_ sender: Any) {
        //forgetApi()
    }
    
}

// MARK:- Functions
extension ForgetPasswordVC{
    
    func uiSetup() {
//        let buttonTitleStr = NSMutableAttributedString(string:"SEND EMAIL", attributes:attrs)
//        attributedString.append(buttonTitleStr)
//        ForgetBtn.setAttributedTitle(attributedString, for: .normal)
        
        ForgetBtn.layer.cornerRadius = ForgetBtn.frame.height/2
        
        EmailTF.layer.cornerRadius = 8
        EmailTF.clipsToBounds = true
        EmailTF.setRightPaddingPoints(5)
        EmailTF.setRightPaddingPoints(5)
        EmailTF.attributedPlaceholder = NSAttributedString(string: "Email",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
//    func forgetApi() {
//        let email = EmailTF.text!
//        if email != "" && email != " "{
//            let headers = ["Accept":"application/json","Content-Type":"application/x-www-form-urlencoded"]
//            let parameter = ["user_email":"\(email)"]
//            if Connectivity.isConnectedToNetwork(){
//                AlamoHelper.PostRequest(Url: baseUrl+"forgetPassword", Parm: parameter, Header: headers) { (JSON) in
//                    if JSON["error"].stringValue == "0"{
//                        ShowAlert(view: self, message: "\(JSON["msg"].stringValue)", Title: "Succes")
//                    }else{
//                        ShowAlert(view: self, message: "\(JSON["msg"].stringValue)", Title: "Succes")
//                    }
//                }
//            }else{
//                // Show toast message
//                print("Network not found")
//                ShowAlert(view: self, message: "You are not connected to the internet. Please check your connection", Title: "Network Connection Error")
//            }
//        }else{
//            ShowAlert(view: self, message: "Email field is empty", Title: "Field Empty")
//        }
//    }
}
