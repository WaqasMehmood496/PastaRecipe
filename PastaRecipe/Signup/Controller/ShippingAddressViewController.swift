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
    //@IBOutlet weak var BillingAddressTF: UITextField!
    @IBOutlet weak var CountryTF: UITextField!
    @IBOutlet weak var StateTF: UITextField!
    @IBOutlet weak var CityTF: UITextField!
    //@IBOutlet weak var DefaultImage: UIImageView!
    
    //CONSTANT
    let zipCodesArray = [
        "33133","33176","33157","33012","33156","33181","33140","33014","33166","33147","33158","33054","33132","33034","33172","33168","33056","33190","33178","33184","33154","33141","33018","33189","33174","33196","33016","33169","33175","33015","33134","33143","33187","33031","33129","33010","33130","33179","33033","33109","33167","33165","33162","33125","33039","33127","33149","33139","33186","33170","33136","33013","33182","33155","33055","33137","33150","33173","33138","33131","33193","33144","33142","33177","33146","33135","33035","33185","33194","33032","33128","33180","33160","33145","33030","33126","33183","33122","33076","33067","33073","33442","33441","33065","33071","33063","33066","33064","33069","33060","33062","33321","33068","33351","33319","33309","33334","33308","33323","33322","33313","33311","33306","33305","33304","33301","33327","33326","33325","33324","33317","33312","33315","33316","33332","33331","33330","33328","33314","33004","33029","33028","33027","33026","33025","33024","33023","33021","33020","33009","33019"
    ]
    
    
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
            let addressDetailObj = AddressModel(adresss_id: "1", zipcode: selectedZipCode, address_main: self.AddressTF.text!, country: self.CountryTF.text!, state: self.StateTF.text!, city: self.CityTF.text!, lat: String(describing: userLocation.address_lat), lng: String(describing: userLocation.address_lng), bydefault: "", user_id: "")
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
