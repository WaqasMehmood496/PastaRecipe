//
//  AddNewAddressViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 11/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import iOSDropDown
import JGProgressHUD

class AddNewAddressViewController: UIViewController, PassDataDelegate {
    
    //IBOUTLET
    @IBOutlet weak var ZipCodeTF: DropDown!
    @IBOutlet weak var AddressTF: UITextField!
    @IBOutlet weak var CountryTF: UITextField!
    @IBOutlet weak var StateTF: UITextField!
    @IBOutlet weak var CityTF: UITextField!
    @IBOutlet weak var DefaultImage: UIImageView!
    @IBOutlet weak var BillingZipCodeTF: DropDown!
    @IBOutlet weak var BillingAddressTF: UITextField!
    @IBOutlet weak var BillingCountryTF: UITextField!
    @IBOutlet weak var BillingStateTF: UITextField!
    @IBOutlet weak var BillingCityTF: UITextField!
    
    //CONSTANT
    let MapsVCIdentifier = "MapsViewController"
    
    //VARIABLE
    var selectedZipCode = ""
    var dataDic:[String:Any]!
    var isDefault = false
    var isEditAddress = false
    var userLocation = LocationModel()
    var delegate:CardAndAddressViewController?
    var myAddress = MyAddressModel()
    var myBillingAddress = MyAddressModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeDropDown()
    }
    
    //IBACTION'S
    @IBAction func AddAddressBtnAction(_ sender: Any) {
        // Make sure all fields are entered
        if validateFields() {
            if isEditAddress {
                self.AddressApi(isEditProfile: true)
            } else {
                self.AddressApi(isEditProfile: false)
            }
        } else {
            PopupHelper.showAlertControllerWithError(forErrorMessage: "All fields are required, Please enter your complete address", forViewController: self)
        }
    }
    
    @IBAction func openMapBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard (
            name: Constant.mainStoryboard,
            bundle: Bundle.main
        )
        let mapController = storyboard.instantiateViewController (
            identifier: MapsVCIdentifier
        ) as! MapsViewController
        mapController.delagate = self
        self.present(mapController, animated: true, completion: nil)
    }
    
    @IBAction func DefaultBtnAction(_ sender: Any) {
        if isDefault {
            isDefault = false
            self.DefaultImage.image = UIImage(named: "")
        } else {
            isDefault = true
            self.DefaultImage.image = UIImage(named: "check")
        }
    }
}




//MARK: - DELEGATE METHODS EXTENSION
extension AddNewAddressViewController {
    func passCurrentLocation(data: LocationModel) {
        userLocation = data
        self.AddressTF.text = data.address
    }
}

//MARK: - HELPING METHODS EXTENSION
extension AddNewAddressViewController {
    func setupUI() {
        addPaddingOnFields()
        if isEditAddress {
            AddressTF.text = myAddress.address_main
            ZipCodeTF.text = myAddress.zipcode
            StateTF.text = myAddress.state
            CityTF.text = myAddress.city
            CountryTF.text = myAddress.country
            
            BillingAddressTF.text = myBillingAddress.address_main
            BillingZipCodeTF.text = myBillingAddress.zipcode
            BillingStateTF.text = myBillingAddress.state
            BillingCityTF.text = myBillingAddress.city
            BillingCountryTF.text = myBillingAddress.country
        }
    }
    
    func addPaddingOnFields() {
        ZipCodeTF.setLeftPaddingPoints(8)
        setupPaddingOnFields(fileds: [AddressTF,CountryTF,StateTF,CityTF])
    }
    
    func setupPaddingOnFields(fileds:[UITextField]) {
        for field in fileds {
            field.setLeftPaddingPoints(4)
            field.setRightPaddingPoints(4)
        }
    }
    
    func initializeDropDown() {
        ZipCodeTF.optionArray = Constant.zipCodes
        ZipCodeTF.selectedIndex = 0
        ZipCodeTF.text = Constant.zipCodes.first
        ZipCodeTF.didSelect{(selectedText , index , id) in
            self.selectedZipCode = String(index + 1)
        }
    }
    
    func validateFields() -> Bool {
        if ZipCodeTF.text != "" && ZipCodeTF.text != " " && AddressTF.text != "" && self.AddressTF.text != " " && CountryTF.text != "" && CountryTF.text != " " && StateTF.text != "" && StateTF.text != " " && CityTF.text != "" && CityTF.text != " " {
            return true
        } else {
            return false
        }
    }
    
    func addressApiParamerters(isEditProfile:Bool) {
        if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
            dataDic[Constant.zipcode] = ZipCodeTF.text!
            dataDic[Constant.address_main] = AddressTF.text!
            dataDic[Constant.country] = CountryTF.text
            dataDic[Constant.state] = StateTF.text!
            dataDic[Constant.city] = CityTF.text!
            dataDic[Constant.user_id] = Int(userId)
            if isEditProfile {
                dataDic[Constant.adresss_id] = myAddress.adresss_id
            }
            if isDefault {
                dataDic[Constant.bydefault] = 1
            } else {
                dataDic[Constant.bydefault] = 0
            }
            dataDic[Constant.lat] = userLocation.address_lat
            dataDic[Constant.lng] = userLocation.address_lng
        }
    }
    
    func showNetworkError() {
        PopupHelper.alertWithOk(title: "Network Error", message: "You are not connected to internet. Please check your internet connection", controler: self)
    }
}



//MARK: - API CALLING METHOD'S EXTENSION
extension AddNewAddressViewController {
    func AddressApi(isEditProfile:Bool) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                self.dataDic = [String:Any]()
                self.addressApiParamerters(isEditProfile: isEditProfile)
                if isEditProfile {
                    self.callWebService(.editadress, hud: hud)
                } else {
                    self.callWebService(.addadress, hud: hud)
                }
            } else {
                hud.dismiss()
                self.showNetworkError()
            }
        }
    }
}



// MARK:- API RESPONSE HANDLING METHOD'S
extension AddNewAddressViewController:WebServiceResponseDelegate {
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let service = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: dataDic, relatedViewController: self,hud: hud)
        service.delegateForWebServiceResponse = self
        service.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .addadress:
            if let data = dataDict as? Dictionary<String, Any>{
                if let address = data["default_adress"] as? NSDictionary {
                    hud.dismiss()
                    myAddress = MyAddressModel(dic: address) ?? MyAddressModel()
                    delegate?.upDateAddress(addressData: myAddress, isDefault: isDefault)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    hud.dismiss()
                }
            } else {
                hud.dismiss()
            }
        case .editadress:
            if let data = dataDict as? Dictionary<String, Any>{
                if let address = data["update_adress"] as? NSDictionary {
                    hud.dismiss()
                    myAddress = MyAddressModel(dic: address) ?? MyAddressModel()
                    self.delegate?.upDateAddress(addressData: myAddress, isDefault: isDefault)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    hud.dismiss()
                }
            } else {
                hud.dismiss()
            }
        default:
            hud.dismiss()
        }
    }
}
