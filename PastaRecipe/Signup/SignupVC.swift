//
//  SignupVC.swift
//  PastaRecipe
//
//  Created by Waqas on 15/12/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var ZipCodeTF: UITextField!
    @IBOutlet weak var StateTF: UITextField!
    @IBOutlet weak var CityTF: UITextField!
    @IBOutlet weak var AddressTF: UITextField!
    @IBOutlet var SignUpBtn: UIButton!
    
    var attrs = [
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15.0),
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    var attributedString = NSMutableAttributedString(string:"")
    var dataDic:[String:Any]!
    
    let zipCodesArray = ["33133","33176","33157","33012","33156","33181","33140","33014","33166","33147","33158","33054","33132","33034","33172","33168","33056","33190","33178","33184","33154","33141","33018","33189","33174","33196","33016","33169","33175","33015","33134","33143","33187","33031","33129","33010","33130","33179","33033","33109","33167","33165","33162","33125","33039","33127","33149","33139","33186","33170","33136","33013","33182","33155","33055","33137","33150","33173","33138","33131","33193","33144","33142","33177","33146","33135","33035","33185","33194","33032","33128","33180","33160","33145","33030","33126","33183","33122","33076","33067","33073","33442","33441","33065","33071","33063","33066","33064","33069","33060","33062","33321","33068","33351","33319","33309","33334","33308","33323","33322","33313","33311","33306","33305","33304","33301","33327","33326","33325","33324","33317","33312","33315","33316","33332","33331","33330","33328","33314","33004","33029","33028","33027","33026","33025","33024","33023","33021","33020","33009","33019"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
    }
    
    @IBAction func SignUpBtn(_ sender: Any) {
        self.checkZipCode()
    }
    
    func checkZipCode() {
        let isValid = self.findZipCode(zipCode: self.ZipCodeTF.text!)
        if isValid{
            self.callingSignUpApi()
        }else{
            PopupHelper.alertWithOk(title: "Zip Code Not Valid", message: "This app is noly for USA", controler: self)
        }
    }
    
    func findZipCode(zipCode:String) -> Bool{
        for i in self.zipCodesArray{
            if i == zipCode{
                return true
            }
        }
        return false
    }
    
    func callingSignUpApi() {
        let name = NameTF.text!
        let email = EmailTF.text!
        let address = AddressTF.text!
        let city = CityTF.text!
        let state = StateTF.text!
        let password = PasswordTF.text!
        
        if email != "" && email != " " && password != "" && password != " " && name != "" && name != " "{
            self.dataDic = [String:Any]()
            self.dataDic[Constant.user_name] = name
            self.dataDic[Constant.user_email] = email
            self.dataDic[Constant.user_password] = password
            self.dataDic[Constant.address_main] = address
            self.dataDic[Constant.city] = city
            self.dataDic[Constant.state] = state
            self.dataDic[Constant.user_type] = "user"
            self.callSignUpApi()
        }
        else{
            CommonHelper.sharedInstance.ShowAlert(view: self, message: "Please fill all feilds", Title: "Error")
        }
    }
}

// MARK:-Functions
extension SignupVC{
    func uiSetup() {
        let buttonTitleStr = NSMutableAttributedString(string:"SIGN UP", attributes:attrs)
        attributedString.append(buttonTitleStr)
        NameTF.layer.cornerRadius = 8
        NameTF.clipsToBounds = true
        NameTF.setRightPaddingPoints(5)
        NameTF.setRightPaddingPoints(5)
        NameTF.attributedPlaceholder = NSAttributedString(string: "Name",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        EmailTF.layer.cornerRadius = 8
        EmailTF.clipsToBounds = true
        EmailTF.setRightPaddingPoints(5)
        EmailTF.setRightPaddingPoints(5)
        EmailTF.attributedPlaceholder = NSAttributedString(string: "Email",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        PasswordTF.layer.cornerRadius = 8
        PasswordTF.clipsToBounds = true
        EmailTF.setRightPaddingPoints(5)
        EmailTF.setRightPaddingPoints(5)
        PasswordTF.attributedPlaceholder = NSAttributedString(string: "Password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        SignUpBtn.layer.cornerRadius =
            SignUpBtn.frame.height/2
        
    }
    
    func callSignUpApi(){
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            WebServicesHelper.callWebService(Parameters:self.dataDic,action: .signup, httpMethodName: .post){ (indx,action,isNetwork, error, dataDict) in
                if isNetwork{
                    if let err = error{
                        hud.dismiss()
                        PopupHelper.showAlertControllerWithError(forErrorMessage: err, forViewController: self)
                    }
                    else{
                        if let dic = dataDict as? Dictionary<String,Any>{
                            if let data = dic["user_detail"] as? NSDictionary{
                                print(data)
                                let user = LoginModel(dic: data as NSDictionary)
                                
                                CommonHelper.saveCachedUserData(user!)
                                UserDefaults.standard.set(true, forKey: "userLoginStatus")
                                hud.dismiss()
                                
                                CommonHelper.sharedInstance.ShowAlert(view: self, message: "Registered Successfully", Title: "Resgister")
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
    
    func ChangeRootVC(storyboardId:String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = mainStoryboard.instantiateViewController(withIdentifier: storyboardId)
        UIApplication.shared.windows.first?.rootViewController = tabbarVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
