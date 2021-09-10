//
//  ShippingAddressViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 05/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import iOSDropDown

class ShippingAddressViewController: UIViewController, PassDataDelegate {
    
    //IBOUTLET
    
    @IBOutlet weak var ZipCodeTF: DropDown!
    @IBOutlet weak var AddressTF: UITextField!
    @IBOutlet weak var CountryTF: UITextField!
    @IBOutlet weak var StateTF: UITextField!
    @IBOutlet weak var CityTF: UITextField!
    
    //VARIABLE
    let MapsVCIdentifier = "MapsViewController"
    var userData = LoginModel()
    var selectedZipCode = Constant.zipCodes.first
    var userLocation = LocationModel()
    var isSameAsShipping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeDropDown()
    }
    
    //IBACTION'S
    @IBAction func NextBtnAction(_ sender: Any) {
        if validateFields() {
            let addressDetailObj = AddressModel(adresss_id: "1", zipcode: selectedZipCode, address_main: self.AddressTF.text!, country: self.CountryTF.text!, state: self.StateTF.text!, city: self.CityTF.text!, lat: String(describing: userLocation.address_lat), lng: String(describing: userLocation.address_lng), bydefault: "", user_id: "", type: "billing", bzipcode: "", baddress_main: "", bcountry: "", bstate: "", bcity: "", blat: "", blng: "")
            self.userData.more_detail.address = addressDetailObj
            moveToCardVC()
        } else {
            PopupHelper.showAlertControllerWithError(forErrorMessage: "All fields are required", forViewController: self )
        }
    }
    
    @IBAction func openMapBtnAction(_ sender: Any) {
        openMap()
    }
    
    // DELEGATES
    func passCurrentLocation(data: LocationModel) {
        userLocation = data
        self.AddressTF.text = data.address
    }
}

//MARK: - HELPING METHODS EXTENSION
extension ShippingAddressViewController {
    
    func setupUI() {
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
        ZipCodeTF.isSearchEnable = false
        ZipCodeTF.text = ZipCodeTF.optionArray.first
        ZipCodeTF.didSelect { (selectedText , index , id) in
            self.selectedZipCode = selectedText
        }
    }
    
    func validateFields() -> Bool {
        if self.ZipCodeTF.text != "" && self.ZipCodeTF.text != " " && self.AddressTF.text != "" && self.AddressTF.text != " " && self.CountryTF.text != "" && self.CountryTF.text != " " && self.StateTF.text != "" && self.StateTF.text != " " && self.CityTF.text != "" && self.CityTF.text != " " {
            return true
        } else {
            return false
        }
    }
    
    func moveToCardVC() {
        let addCardVC = storyboard?.instantiateViewController(identifier: "AddMyCardViewController") as! AddMyCardViewController
        addCardVC.userData = self.userData
        self.navigationController?.pushViewController(addCardVC, animated: true)
    }
    
    func openMap() {
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
}
