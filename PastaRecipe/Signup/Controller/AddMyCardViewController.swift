//
//  AddMyCardViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 05/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import Stripe
import JGProgressHUD
import FormTextField
import AZTabBar

class AddMyCardViewController: UIViewController {
    
    //IBOUTLET
    @IBOutlet weak var AddCardTableView: UITableView!
    
    //CONSTANT
    
    //VARIABLE
    var cardNumber = String()
    var date = String()
    var cvc = String()
    var userData = LoginModel()
    var dataDic:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

//MARK:- HELPING METHODS EXTENSION
extension AddMyCardViewController{
    func signUpApi(){
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork(){
                self.dataDic = [String:Any]()
                self.dataDic[Constant.user_name] = self.userData.user_detail.user_name
                self.dataDic[Constant.user_email] = self.userData.user_detail.user_email
                self.dataDic[Constant.user_password] = self.userData.user_detail.user_password
                self.dataDic[Constant.user_type] = "user"
                self.dataDic[Constant.zipcode] = self.userData.more_detail.address.zipcode
                self.dataDic[Constant.address_main] = self.userData.more_detail.address.address_main
                self.dataDic[Constant.billing_address] = self.userData.user_detail.billing_address                
                self.dataDic[Constant.country] = self.userData.more_detail.address.country
                self.dataDic[Constant.state] = self.userData.more_detail.address.state
                self.dataDic[Constant.city] = self.userData.more_detail.address.city
                self.dataDic[Constant.phone_number] = ""
                self.dataDic[Constant.card_number] = self.cardNumber
                self.dataDic[Constant.expired_date_c] = self.date
                self.dataDic[Constant.cvc] = self.cvc
                self.dataDic[Constant.lat] = self.userData.more_detail.address.lat
                self.dataDic[Constant.lng] = self.userData.more_detail.address.lng
                self.callWebService(.signup, hud: hud)
            }
        }
    }
}


//MARK:- UITABLEVIEW METHOD'S EXTENSION
extension AddMyCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddMyNewCardTableViewCell") as! AddMyNewCardTableViewCell
        cell.CardNumberTextfield.delegate = self
        cell.CardNumberTextfield.tag = 0
        cell.ExpireDateTextfield.delegate = self
        cell.ExpireDateTextfield.tag = 1
        cell.CVCTextfield.delegate = self
        cell.CVCTextfield.tag = 2
        cell.DoneBtn.addTarget(self, action: #selector(DoneBtn(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func DoneBtn(_ sender:UIButton) {
        signUpApi()
    }
}

extension AddMyCardViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension AddMyCardViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0{
            self.cardNumber = textField.text!
        }else if textField.tag == 1{
            self.date = textField.text!
        } else {
            self.cvc = textField.text!
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.cardNumber = textField.text!
        case 1:
            self.date = textField.text!
        case 2:
            self.cvc = textField.text!
        default:
            break
        }
    }
}


// MARK:-Api Methods Extension
extension AddMyCardViewController:WebServiceResponseDelegate{
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let service = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: dataDic, relatedViewController: self,hud: hud)
        service.delegateForWebServiceResponse = self
        service.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .signup:
            
            if let data = dataDict as? Dictionary<String, Any>{
                if let loginUser = LoginModel(dic: data as NSDictionary){
                    CommonHelper.saveCachedUserData(loginUser)
                    self.navigationController?.tabBarController?.selectedIndex = 0
                    defaults.set(true, forKey: Constant.userLoginStatusKey)
                    hud.dismiss()
                    PopupHelper.alertWithOk(title: "Success", message: "You account created successfully", controler: self)
                    if let controller = self.parent?.parent as? AZTabBarController{
                        let profileVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: "profileVC")
                        controller.setViewController(profileVC, atIndex: 1)
                    }
                }
                hud.dismiss()
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}
