//
//  ConfirmOrderViewController.swift
//  PastaRecipe
//
//  Created by Waqas on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD
import iOSDropDown
class ConfirmOrderViewController: UIViewController, PassDataDelegate {
    
    // IBOUTLET'S
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var ZipCodeTF: DropDown!
    @IBOutlet weak var StateTF: UITextField!
    @IBOutlet weak var CityTF: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var detailstf: UITextField!
    
    //CONSTANT'S
    let MapsVCIdentifier = "MapsViewController"
    let zipCodeMessage = "Zip code and address fields are required"
    let fieldsRequiredMsg = "All fields are required"
    let internetConnectionMsg = "You are not connected to the internet. Please check your connection"
    let containSpace = " "
    let AddCardIdentifier = "AddCardViewController"
    // VARIABLE'S
    var selectedPlan = OrdersModel()
    var dataDic = [String:Any]()
    var selectedZip = "33133"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        //self.addTabGuestureOnLocationTextField()
    }
    
    @IBAction func confirmOrderBtn(_ sender: Any) {
        
        if CommonHelper.getCachedUserData()?.user_detail.user_id != nil {
            if addressTf.text!.isEmpty || addressTf.text! == containSpace ,
               ZipCodeTF.text!.isEmpty || ZipCodeTF.text! == containSpace {
                PopupHelper.showAlertControllerWithError (
                    forErrorMessage: zipCodeMessage,
                    forViewController: self
                )
            } else {
                self.moveToStripeVC()
            }
        } else {
            if NameTF.text!.isEmpty || NameTF.text! == containSpace || EmailTF.text!.isEmpty || EmailTF.text! == containSpace || ZipCodeTF.text!.isEmpty || ZipCodeTF.text! == containSpace || StateTF.text!.isEmpty || StateTF.text! == containSpace || CityTF.text!.isEmpty || CityTF.text! == containSpace || addressTf.text!.isEmpty || addressTf.text! == containSpace {
                
                PopupHelper.showAlertControllerWithError (
                    forErrorMessage: fieldsRequiredMsg,
                    forViewController: self
                )
            }else{
                self.moveToStripeVC()
            }
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
    
}

//MARK:- HELPING METHOD'S
extension ConfirmOrderViewController{
    
    func setUpUI() {
        if let user = CommonHelper.getCachedUserData(){
            NameTF.text = user.user_detail.user_name
            EmailTF.text = user.user_detail.user_email
            ZipCodeTF.text = user.more_detail.address.zipcode
            StateTF.text = user.more_detail.address.state
            CityTF.text = user.more_detail.address.city
            addressTf.text = user.more_detail.address.address_main
        }
        self.zipCodeSetupOnDropDown()
    }
    
    func zipCodeSetupOnDropDown() {
        ZipCodeTF.optionArray = ["33133","33176","33157","33012","33156","33181","33140","33014","33166","33147","33158","33054","33132","33034","33172","33168","33056","33190","33178","33184","33154","33141","33018","33189","33174","33196","33016","33169","33175","33015","33134","33143","33187","33031","33129","33010","33130","33179","33033","33109","33167","33165","33162","33125","33039","33127","33149","33139","33186","33170","33136","33013","33182","33155","33055","33137","33150","33173","33138","33131","33193","33144","33142","33177","33146","33135","33035","33185","33194","33032","33128","33180","33160","33145","33030","33126","33183","33122","33076","33067","33073","33442","33441","33065","33071","33063","33066","33064","33069","33060","33062","33321","33068","33351","33319","33309","33334","33308","33323","33322","33313","33311","33306","33305","33304","33301","33327","33326","33325","33324","33317","33312","33315","33316","33332","33331","33330","33328","33314","33004","33029","33028","33027","33026","33025","33024","33023","33021","33020","33009","33019"
        ]
        ZipCodeTF.selectedIndex = 0
        ZipCodeTF.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ZipCodeTF.didSelect{(selectedText , index , id) in
            self.selectedZip = selectedText
        }
    }
    
    func booking() {
        self.AddPurchasedProduct()
    }
    
    func moveToStripeVC() {
        let payment = storyboard?.instantiateViewController(identifier: AddCardIdentifier) as! AddCardViewController
        payment.delegate = self
        selectedPlan.order_address = self.addressTf.text!
        payment.orderDetail = selectedPlan
        payment.orderDetail.user_id = 0
        self.navigationController?.pushViewController(payment, animated: true)
    }
    
    func getPriceOfProducts() -> String {
        var price = 0
        for i in 0..<cartArray.count {
            if let getPrice = Int(cartArray[i].price) {
                price = price + getPrice
            }
        }
        return String(price)
    }
    
    func passCurrentLocation(data: LocationModel) {
        self.addressTf.text = data.address
    }
    
    func setupLoginUserParameters(user:LoginModel) {
        self.dataDic[Constant.name] = user.user_detail.user_name
        self.dataDic[Constant.user_id] = user.user_detail.user_id
        self.dataDic[Constant.email] = user.user_detail.user_email
        self.dataDic[Constant.state] = user.more_detail.address.state
        self.dataDic[Constant.city] = user.more_detail.address.city
    }
    
    func setupFieldsParameter() {
        self.dataDic[Constant.name] = self.NameTF.text!
        self.dataDic[Constant.user_id] = "0"
        self.dataDic[Constant.email] = self.EmailTF.text!
        self.dataDic[Constant.state] = self.StateTF.text!
        self.dataDic[Constant.city] = self.CityTF.text!
    }
    
    func defaultParamerts() {
        self.dataDic[Constant.shipping_address] = self.addressTf.text!
        self.dataDic[Constant.shiping_month] = self.selectedPlan.order_date
        self.dataDic[Constant.total_product] = "\(cartArray.count)"
        self.dataDic[Constant.total_price] = "\(self.getPriceOfProducts())"
        self.dataDic[Constant.zipcode] = self.selectedZip
        for i in 0..<cartArray.count{
            self.dataDic["\(Constant.product_id)\(i)"] = cartArray[i].id
            self.dataDic["\(Constant.quantity)\(i)"] = cartArray[i].quantity
            self.dataDic["\(Constant.price)\(i)"] = cartArray[i].price
        }
    }
    
}

//MARK:- API CALLING METHOD'S
extension ConfirmOrderViewController {
    func AddPurchasedProduct() {
        showHUDView (
            hudIV: .indeterminate,
            text: .process
        ) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                self.dataDic = [String:Any]()
                if let user = CommonHelper.getCachedUserData() {
                    self.setupLoginUserParameters(user: user)
                } else {
                    self.setupFieldsParameter()
                }
                self.defaultParamerts()
                self.callWebService(.addpasteapurchyase, hud: hud)
            }else{
                hud.textLabel.text = self.internetConnectionMsg
                hud.dismiss()
            }
        }
    }
    
}

//MARK:- WEBSERVICES METHOD'S
extension ConfirmOrderViewController:WebServiceResponseDelegate{
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .addpasteapurchyase:
            if let data = dataDict as? NSDictionary{
                print(data)
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}
