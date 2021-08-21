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
    
    //CONSTANT
    let zipCodesArray = [
        "33133","33176","33157","33012","33156","33181","33140","33014","33166","33147","33158","33054","33132","33034","33172","33168","33056","33190","33178","33184","33154","33141","33018","33189","33174","33196","33016","33169","33175","33015","33134","33143","33187","33031","33129","33010","33130","33179","33033","33109","33167","33165","33162","33125","33039","33127","33149","33139","33186","33170","33136","33013","33182","33155","33055","33137","33150","33173","33138","33131","33193","33144","33142","33177","33146","33135","33035","33185","33194","33032","33128","33180","33160","33145","33030","33126","33183","33122","33076","33067","33073","33442","33441","33065","33071","33063","33066","33064","33069","33060","33062","33321","33068","33351","33319","33309","33334","33308","33323","33322","33313","33311","33306","33305","33304","33301","33327","33326","33325","33324","33317","33312","33315","33316","33332","33331","33330","33328","33314","33004","33029","33028","33027","33026","33025","33024","33023","33021","33020","33009","33019"
    ]
    let MapsVCIdentifier = "MapsViewController"
    
    //VARIABLE
    var selectedZipCode = ""
    var dataDic:[String:Any]!
    var isDefault = false
    var isEditAddress = false
    var userLocation = LocationModel()
    var delegate:CardAndAddressViewController?
    var myAddress = MyAddressModel()
    
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
        }
    }
    
    func addPaddingOnFields() {
        ZipCodeTF.setLeftPaddingPoints(8)
        ZipCodeTF.setRightPaddingPoints(8)
        AddressTF.setLeftPaddingPoints(8)
        AddressTF.setRightPaddingPoints(8)
        CountryTF.setLeftPaddingPoints(8)
        CountryTF.setRightPaddingPoints(8)
        StateTF.setLeftPaddingPoints(8)
        StateTF.setRightPaddingPoints(8)
        CityTF.setLeftPaddingPoints(8)
        CityTF.setRightPaddingPoints(8)
    }
    
    func initializeDropDown() {
        ZipCodeTF.optionArray = zipCodesArray
        ZipCodeTF.selectedIndex = 0
        ZipCodeTF.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ZipCodeTF.text = zipCodesArray[0]
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
