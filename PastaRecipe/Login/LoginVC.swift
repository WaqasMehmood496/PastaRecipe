//
//  ViewController.swift
//  PastaRecipe
//
//  Created by moin janjua on 26/09/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AZTabBar
class LoginVC: UIViewController {
    
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signupbtn: UIButton!
    @IBOutlet weak var SIgnupbtn: UIButton!
    
    var attrs = [
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0),
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    var attributedString = NSMutableAttributedString(string:"")
    var dataDic:[String:Any]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        if EmailTF.text  != "" && passwordTF.text != ""{
            self.dataDic = [String:Any]()
            self.dataDic[Constant.user_email] = self.EmailTF.text
            self.dataDic[Constant.user_password] = self.passwordTF.text
            self.callLoginApi()
        }
        
    }
    @IBAction func forgetPassword(_ sender: Any) {
        self.performSegue(withIdentifier: "forgetPasswordSegue", sender: nil)
    }
    @IBAction func SignupBtnAction(_ sender: Any) {
        moveToSignUp()
    }
    
}


//MARK: Functions
extension LoginVC{
    
    func uiSetup() {
        signupbtn.layer.cornerRadius = signupbtn.frame.height/2
        EmailTF.layer.cornerRadius = 8
        EmailTF.clipsToBounds = true
        EmailTF.setRightPaddingPoints(8)
        EmailTF.setLeftPaddingPoints(8)
        passwordTF.layer.cornerRadius = 8
        passwordTF.clipsToBounds = true
        passwordTF.setLeftPaddingPoints(8)
        passwordTF.setRightPaddingPoints(8)
    }
    
    func moveToSignUp() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func callLoginApi(){
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            WebServicesHelper.callWebService(Parameters:self.dataDic,action: .login, httpMethodName: .post){ (indx,action,isNetwork, error, dataDict) in
                if isNetwork{
                    if let err = error{
                        hud.dismiss()
                        PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                    }
                    else{
                        if let data = dataDict as? Dictionary<String, Any>{
                            if let loginUser = LoginModel(dic: data as NSDictionary){
                                CommonHelper.saveCachedUserData(loginUser)
                                defaults.set(true, forKey: Constant.userLoginStatusKey)
                                hud.dismiss()
                                PopupHelper.alertWithOk(title: "Success", message: "You login successfully", controler: self)
                                if let controller = self.parent?.parent as? AZTabBarController{
                                    let profileVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: "profileVC")
                                    controller.setViewController(profileVC, atIndex: 1)
                                }
                            }
                        }else{
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
    func ChangeRootVC(storyboardId:String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = mainStoryboard.instantiateViewController(withIdentifier: storyboardId)
        UIApplication.shared.windows.first?.rootViewController = tabbarVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
