//
//  CustomerSupportViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 08/05/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class CustomerSupportViewController: UIViewController {

    @IBOutlet weak var FNameTF: UITextField!
    @IBOutlet weak var LNameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PhoneTF: UITextField!
    @IBOutlet weak var MessageTF: UITextView!
    @IBOutlet var SignUpBtn: UIButton!
    
    var dataDic:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func clearData(){
        FNameTF.text = nil
        LNameTF.text = nil
        EmailTF.text = nil
        PhoneTF.text = nil
        MessageTF.text = nil
    }
    @IBAction func SignUpBtn(_ sender: Any) {
        //signupApiCall()
        let fname = FNameTF.text!
        let lname = LNameTF.text!
        let email = EmailTF.text!
        let phone = PhoneTF.text!
        let message = MessageTF.text!
        
        if email != "" && email != " " && phone != "" && phone != " " && fname != "" && fname != " " && lname != "" && lname != " " && message != "" && message != " "{
            self.dataDic = [String:Any]()
            self.dataDic[Constant.first_name] = fname
            self.dataDic[Constant.last_name] = lname
            self.dataDic[Constant.email] = email
            self.dataDic[Constant.phone_number] = phone
            self.dataDic[Constant.message] = message
            self.callSignUpApi()
        }
        else{
            
            CommonHelper.sharedInstance.ShowAlert(view: self, message: "Please fill all feilds", Title: "Error")
            self.clearData()
            
        }
    }
    func callSignUpApi(){
        
    
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            
            
            WebServicesHelper.callWebService(Parameters:self.dataDic,action: .customer_Support, httpMethodName: .post){ (indx,action,isNetwork, error, dataDict) in
                
                if isNetwork{
                    if let err = error{
                        hud.dismiss()
                        PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                    }
                    else{
                        if let dic = dataDict as? Dictionary<String,Any>{
                            if let data = dic["msg"] as? String{
                                hud.dismiss()
                                
                                CommonHelper.sharedInstance.ShowAlert(view: self, message: data, Title: "Support")
                                
                                //Move to next Screen

                                
                                print("Success")
                                
                        }
                        else{
                            hud.dismiss()
                            PopupHelper.showAlertControllerWithError(forErrorMessage: "something went wrong", forViewController: self)
                        }
                    }
                    else{
                        hud.dismiss()
                        PopupHelper.showAlertControllerWithError(forErrorMessage: "something went wrong", forViewController: self)
                            
                        }
                 }
                }
                else{
                    hud.dismiss()
                    PopupHelper.alertWithNetwork(title: "Network Connection", message: "Please connect your internet connection", controler: self)
                }
            }
        }
        
        
        
        
        
    }

}
