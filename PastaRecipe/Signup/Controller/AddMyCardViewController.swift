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

class AddMyCardViewController: UIViewController, PassDataDelegate {
    
    //IBOUTLET
    @IBOutlet weak var AddCardTableView: UITableView!
    
    //VARIABLE
    var cardNumber = String()
    var date = String()
    var cvc = String()
    var userData = LoginModel()
    var dataDic:[String:Any]!
    var isBillingAddressAdded = false
    var isDefaultAddress = false
    //var billingAddress = AddressModel()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func passCurrentLocation(data: LocationModel) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = AddCardTableView.cellForRow(at: indexPath) as! AddMyNewCardTableViewCell
        cell.BillingAddressField.text = data.address
    }
}

//MARK:- HELPING METHODS EXTENSION
extension AddMyCardViewController {
    
    
    func openMap() {
        let storyboard = UIStoryboard (
            name: Constant.mainStoryboard,
            bundle: Bundle.main
        )
        let mapController = storyboard.instantiateViewController (
            identifier: "MapsViewController"
        ) as! MapsViewController
        mapController.delagate = self
        self.present(mapController, animated: true, completion: nil)
    }
    
    func signUpApi() {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                self.dataDic = [String:Any]()
                self.dataDic[Constant.user_name] = self.userData.user_detail.user_name
                self.dataDic[Constant.user_email] = self.userData.user_detail.user_email
                self.dataDic[Constant.user_password] = self.userData.user_detail.user_password
                self.dataDic[Constant.user_type] = "user"
                // Shipping Address Parameters
                self.dataDic[Constant.zipcode] = self.userData.more_detail.address.zipcode
                self.dataDic[Constant.address_main] = self.userData.more_detail.address.address_main
                self.dataDic[Constant.country] = self.userData.more_detail.address.country
                self.dataDic[Constant.state] = self.userData.more_detail.address.state
                self.dataDic[Constant.city] = self.userData.more_detail.address.city
                self.dataDic[Constant.lat] = self.userData.more_detail.address.lat
                self.dataDic[Constant.lng] = self.userData.more_detail.address.lng
                // Card Parameters
                self.dataDic[Constant.phone_number] = ""
                self.dataDic[Constant.card_number] = self.cardNumber
                self.dataDic[Constant.expired_date_c] = self.date
                self.dataDic[Constant.cvc] = self.cvc
                // Billing Address Parameters
                if self.isDefaultAddress {
                    self.dataDic[Constant.bzipcode] = self.userData.more_detail.address.zipcode
                    self.dataDic[Constant.baddress_main] = self.userData.more_detail.address.address_main
                    self.dataDic[Constant.bcountry] = self.userData.more_detail.address.country
                    self.dataDic[Constant.bstate] = self.userData.more_detail.address.state
                    self.dataDic[Constant.bcity] = self.userData.more_detail.address.city
                    self.dataDic[Constant.blat] = self.userData.more_detail.address.lat
                    self.dataDic[Constant.blng] = self.userData.more_detail.address.lng
                } else {
                    self.dataDic[Constant.bzipcode] = self.userData.more_detail.address.bzipcode
                    self.dataDic[Constant.baddress_main] = self.userData.more_detail.address.baddress_main
                    self.dataDic[Constant.bcountry] = self.userData.more_detail.address.bcountry
                    self.dataDic[Constant.bstate] = self.userData.more_detail.address.bstate
                    self.dataDic[Constant.bcity] = self.userData.more_detail.address.bcity
                    self.dataDic[Constant.blat] = self.userData.more_detail.address.blat
                    self.dataDic[Constant.blng] = self.userData.more_detail.address.blng
                }
                
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
        cell.CheckMarkImage.image = UIImage(named: "")
        cell.BillingAddressBtn.addTarget(self, action: #selector(billingAddressBtnAction(_:)), for: .touchUpInside)
        cell.OpenMapBtn.addTarget(self, action: #selector(OpenMapBtn(_:)), for: .touchUpInside)
        
        cell.ZipCodeField.setLeftPaddingPoints(4)
        cell.BillingAddressField.setLeftPaddingPoints(4)
        cell.CountryField.setLeftPaddingPoints(4)
        cell.StateField.setLeftPaddingPoints(4)
        cell.CityField.setLeftPaddingPoints(4)
        
        cell.BillingAddressField.delegate = self
        cell.ZipCodeField.delegate = self
        cell.CountryField.delegate = self
        cell.StateField.delegate = self
        cell.CityField.delegate = self
        
        cell.ZipCodeField.tag = 3
        cell.BillingAddressField.tag = 4
        cell.CountryField.tag = 5
        cell.StateField.tag = 6
        cell.CityField.tag = 7
        
        return cell
    }
    
    @objc func DoneBtn(_ sender:UIButton) {
        if isBillingAddressAdded {
            signUpApi()
        } else {
            PopupHelper.alertWithOk(title: "Shipping Address", message: "Please confirm shipping address", controler: self)
        }
    }
    
    @objc func billingAddressBtnAction(_ sender:UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = AddCardTableView.cellForRow(at: indexPath) as! AddMyNewCardTableViewCell
        if isDefaultAddress {
            isBillingAddressAdded = false
            isDefaultAddress = false
            cell.CheckMarkImage.image = UIImage(named: "")
            cell.ZipCodeField.text = ""
            cell.BillingAddressField.text = ""
            cell.CountryField.text = ""
            cell.CityField.text = ""
            cell.StateField.text = ""
        } else {
            isDefaultAddress = true
            isBillingAddressAdded = true
            cell.CheckMarkImage.image = UIImage(named: "check")
            cell.ZipCodeField.text = userData.more_detail.address.zipcode
            if let address = userData.more_detail.address.address_main {
                cell.BillingAddressField.text = address
            }
            cell.CountryField.text = userData.more_detail.address.country
            cell.CityField.text = userData.more_detail.address.city
            cell.StateField.text = userData.more_detail.address.state
        }
    }
    
    @objc func OpenMapBtn(_ sender:UIButton) {
        openMap()
    }
    
}


extension AddMyCardViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension AddMyCardViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.cardNumber = textField.text!
        } else if textField.tag == 1 {
            self.date = textField.text!
        } else if textField.tag == 2 {
            self.cvc = textField.text!
        } else if textField.tag == 3 {
            self.userData.more_detail.address.bzipcode = textField.text!
        } else if textField.tag == 4 {
            self.userData.more_detail.address.baddress_main = textField.text!
        } else if textField.tag == 5 {
            self.userData.more_detail.address.bcountry = textField.text!
        } else if textField.tag == 6 {
            self.userData.more_detail.address.bstate = textField.text!
        } else {
            self.userData.more_detail.address.bcity = textField.text!
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
        case 3:
            self.userData.more_detail.address.bzipcode = textField.text!
        case 4:
            self.userData.more_detail.address.baddress_main = textField.text!
        case 5:
            self.userData.more_detail.address.bcountry = textField.text!
        case 6:
            self.userData.more_detail.address.bstate = textField.text!
        case 7:
            self.userData.more_detail.address.bcity = textField.text!
            self.isBillingAddressAdded = true
        default:
            break
        }
    }
}


// MARK:-Api Methods Extension
extension AddMyCardViewController:WebServiceResponseDelegate {
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let service = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: dataDic, relatedViewController: self,hud: hud)
        service.delegateForWebServiceResponse = self
        service.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .signup:
            if let data = dataDict as? Dictionary<String, Any> {
                if let loginUser = LoginModel(dic: data as NSDictionary) {
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
            } else {
                hud.dismiss()
            }
            
        default:
            hud.dismiss()
        }
    }
}
