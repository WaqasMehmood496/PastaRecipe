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
import Stripe

class ConfirmOrderViewController: UIViewController, PassDataDelegate {
    
    // IBOUTLET'S
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var ZipCodeTF: DropDown!
    @IBOutlet weak var StateTF: UITextField!
    @IBOutlet weak var CityTF: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    @IBOutlet weak var detailstf: UITextField!
    @IBOutlet weak var DefaultCardBtn: UIButton!
    
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
    var isSubscription = false
    var isUserDefaultCard = true
    var location = LocationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        //self.addTabGuestureOnLocationTextField()
    }
    
    @IBAction func UserDefaultCardBtnAction(_ sender: Any) {
        if isUserDefaultCard {
            isUserDefaultCard = false
            DefaultCardBtn.setImage(UIImage(named: ""), for: .normal)
        } else {
            isUserDefaultCard = true
            DefaultCardBtn.setImage(UIImage(named: "checking-mark"), for: .normal)
        }
    }
    
    @IBAction func confirmOrderBtn(_ sender: Any) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if self.isSubscription {
                if self.isUserDefaultCard {
                    //MARK: Subscription payment of stripe here....
                    if let userData = CommonHelper.getCachedUserData() {
                        if let expDate = userData.more_detail.card.expired_date_c {
                            let expDateArray = expDate.components(separatedBy: "/")
                            self.performStripePayment(hud: hud, cardNumber: userData.more_detail.card.card_number, expMonth: UInt(expDateArray[0])!, expYear: UInt(expDateArray[1])!, cvc: userData.more_detail.card.cvc, postalCode: self.selectedZip, price: Int(self.selectedPlan.purchasingcoins)!, name: self.NameTF.text!, email: self.EmailTF.text!)
                            
                        } else {
                            PopupHelper.showAlertControllerWithError(forErrorMessage: "Expeire date is not valid", forViewController: self)
                        }
                    } else {
                        hud.dismiss()
                        self.moveToStripeViewController()
                    }
                    
                } else {
                    // Move To Stripe View Controller
                    hud.dismiss()
                    self.moveToStripeViewController()
                }
            } else {
                if self.isUserDefaultCard {
                    //MARK: Simple payment of stripe here....
                    if CommonHelper.getCachedUserData() != nil {
                        self.SimplePayment(hud: hud)
                    } else {
                        hud.dismiss()
                        self.moveToStripeViewController()
                    }
                    
                } else {
                    hud.dismiss()
                    self.moveToStripeViewController()
                }
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
extension ConfirmOrderViewController {
    
    func setUpUI() {
        if let user = CommonHelper.getCachedUserData(){
            NameTF.text = user.user_detail.user_name
            EmailTF.text = user.user_detail.user_email
            ZipCodeTF.text = user.more_detail.address.zipcode
            StateTF.text = user.more_detail.address.state
            CityTF.text = user.more_detail.address.city
            addressTf.text = user.more_detail.address.address_main
        }
        setupPaddingOnFields()
        self.zipCodeSetupOnDropDown()
    }
    
    func setupPaddingOnFields() {
        NameTF.setLeftPaddingPoints(4)
        NameTF.setRightPaddingPoints(4)
        EmailTF.setLeftPaddingPoints(4)
        EmailTF.setRightPaddingPoints(4)
        StateTF.setLeftPaddingPoints(4)
        StateTF.setRightPaddingPoints(4)
        CityTF.setLeftPaddingPoints(4)
        CityTF.setRightPaddingPoints(4)
        addressTf.setLeftPaddingPoints(4)
        addressTf.setRightPaddingPoints(4)
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
    
    func getPriceOfProducts() -> String {
        var price = 0
        for i in 0..<cartArray.count {
            if let getPrice = Int(cartArray[i].price) {
                price = price + getPrice
            }
        }
        return String(price)
    }
    
    
    func setupLoginUserParameters(user:LoginModel) {
        self.dataDic[Constant.user_id] = UInt(user.user_detail.user_id)!
        if let zipCode = UInt(user.more_detail.address.zipcode) {
            self.dataDic[Constant.zipcode] = zipCode
        } else {
            self.dataDic[Constant.zipcode] = UInt(self.ZipCodeTF.text!)!
        }
        self.dataDic[Constant.country] = user.more_detail.address.country
        self.dataDic[Constant.state] = user.more_detail.address.state
        self.dataDic[Constant.city] = user.more_detail.address.city
        self.dataDic[Constant.order_lat] = user.more_detail.address.lat
        self.dataDic[Constant.order_lng] = user.more_detail.address.lng
        self.dataDic[Constant.order_address] = user.more_detail.address.address_main
        if isSubscription {
            self.dataDic[Constant.type] = "onetime"
            // MARK: Error on forever keyword
        } else {
            self.dataDic[Constant.type] = "onetime"
        }
    }
    
    func setupFieldsParameter() {
        self.dataDic[Constant.user_id] = 0
        self.dataDic[Constant.zipcode] = UInt(self.ZipCodeTF.text!)!
        self.dataDic[Constant.country] = "US"
        if let state = self.StateTF.text {
            self.dataDic[Constant.state] = state
        } else {
            self.dataDic[Constant.state] = "usa"
        }
        if let city = self.CityTF.text {
            self.dataDic[Constant.city] = city
        } else {
            self.dataDic[Constant.city] = ""
        }
        if let address = self.addressTf.text {
            self.dataDic[Constant.order_address] = address
        } else {
            self.dataDic[Constant.order_address] = ""
        }
        self.dataDic[Constant.order_lat] = ""
        self.dataDic[Constant.order_lng] = ""
        if isSubscription {
            self.dataDic[Constant.type] = "onetime"
        } else {
            self.dataDic[Constant.type] = "onetime"
        }
    }
    
    func defaultParamerts(cusID:String) {
        self.dataDic[Constant.amout] = UInt(selectedPlan.purchasingcoins)! * 100
        self.dataDic[Constant.account_id] = cusID
        self.dataDic[Constant.order_date] = Date().formattedWith("yyyy-MM-dd")
        self.dataDic[Constant.order_time] = Date().formattedWith("HH:mm")
        self.dataDic[Constant.total_product] = "\(cartArray.count)"
        for i in 0..<cartArray.count {
            self.dataDic["\(Constant.product_id)\(i)"] = cartArray[i].id
            self.dataDic["\(Constant.quantity)\(i)"] = cartArray[i].quantity
            self.dataDic["\(Constant.price)\(i)"] = cartArray[i].price
        }
    }
    
    func moveToStripeViewController() {
        if CommonHelper.getCachedUserData()?.user_detail.user_id != nil {
            if addressTf.text!.isEmpty || addressTf.text! == containSpace ,
               ZipCodeTF.text!.isEmpty || ZipCodeTF.text! == containSpace {
                PopupHelper.showAlertControllerWithError (
                    forErrorMessage: zipCodeMessage,
                    forViewController: self
                )
            } else {
                self.nevigateToNextVC()
            }
        } else {
            if NameTF.text!.isEmpty || NameTF.text! == containSpace || EmailTF.text!.isEmpty || EmailTF.text! == containSpace || ZipCodeTF.text!.isEmpty || ZipCodeTF.text! == containSpace || StateTF.text!.isEmpty || StateTF.text! == containSpace || CityTF.text!.isEmpty || CityTF.text! == containSpace || addressTf.text!.isEmpty || addressTf.text! == containSpace {
                
                PopupHelper.showAlertControllerWithError (
                    forErrorMessage: fieldsRequiredMsg,
                    forViewController: self
                )
            } else {
                if self.EmailTF.isValidEmail(self.EmailTF.text!){
                    self.nevigateToNextVC()
                } else {
                    PopupHelper.alertWithOk(title: "Fail", message: "Please enter a valid email", controler: self)
                }
            }
        }
    }
    
    func nevigateToNextVC() {
        let payment = storyboard?.instantiateViewController(identifier: AddCardIdentifier) as! AddCardViewController
        payment.delegate = self
        selectedPlan.order_address = self.addressTf.text!
        payment.orderDetail = selectedPlan
        payment.orderDetail.user_id = 0
        payment.email = self.EmailTF.text!
        payment.name = self.NameTF.text!
        payment.isSubscription = isSubscription
        self.navigationController?.pushViewController(payment, animated: true)
    }
    
}


//MARK:- DELEGATE METHOD'S
extension ConfirmOrderViewController {
    
    // Delegate Methods
    func booking(cusId:String, hud:JGProgressHUD) {
        self.AddPurchasedProduct(cusId: cusId, hud: hud)
    }
    
    // Get Current location using mapview
    func passCurrentLocation(data: LocationModel) {
        self.addressTf.text = data.address
        self.location = data
    }
}


//MARK:- API CALLING METHOD'S
extension ConfirmOrderViewController {
    
    func AddPurchasedProduct(cusId:String, hud:JGProgressHUD) {
        if Connectivity.isConnectedToNetwork() {
            self.dataDic = [String:Any]()
            if let user = CommonHelper.getCachedUserData() {
                self.setupLoginUserParameters(user: user)
            } else {
                self.setupFieldsParameter()
            }
            self.defaultParamerts(cusID: cusId)
            print(dataDic)
            self.callWebService(.addpasteapurchyase, hud: hud)
        }else{
            hud.textLabel.text = self.internetConnectionMsg
            hud.dismiss()
        }
    }
    
    func SimplePayment(hud:JGProgressHUD) {
        if Connectivity.isConnectedToNetwork() {
            self.dataDic = [String:Any]()
            if let price = self.selectedPlan.purchasingcoins {
                if let user = CommonHelper.getCachedUserData() {
                    self.dataDic[Constant.email] = user.user_detail.user_email
                    self.dataDic[Constant.name] = user.user_detail.user_name
                    self.dataDic[Constant.amount] = Int(self.selectedPlan.purchasingcoins)! * 100
                } else {
                    self.dataDic[Constant.email] = self.EmailTF.text!
                    self.dataDic[Constant.name] = self.NameTF.text!
                    self.dataDic[Constant.amount] = Int(price)! * 100
                }
                self.callWebService(.stripe_payment, hud: hud)
            } else {
                hud.dismiss()
                PopupHelper.showAlertControllerWithError(forErrorMessage: "Your transection is fail", forViewController: self)
            }
        }else {
            hud.textLabel.text = self.internetConnectionMsg
            hud.dismiss(afterDelay: 2.5)
        }
    }
    
}

//MARK:- WEBSERVICES METHOD'S
extension ConfirmOrderViewController:WebServiceResponseDelegate {
    
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
                if isSubscription {
                    PopupHelper.alertWithOk(title: "Success", message: "Your subscription is completed", controler: self)
                } else {
                    PopupHelper.alertWithOk(title: "Success", message: "Order has been successfully added", controler: self)
                }
                
            }
            hud.dismiss()
        case .stripe_payment:
            if let data = dataDict as? Dictionary<String, Any>{
                if let key = data["key"] as? String {
                    
                    guard let cusId = data["cus_id"] as? String else {
                        hud.dismiss()
                        return
                    }
                    
                    if let user = CommonHelper.getCachedUserData(){
                        let expDateArray = user.more_detail.card.expired_date_c.components(separatedBy: "/")
                        stipeSimplePayment(paymentIntentClientSecret: key, cardNumber: user.more_detail.card.card_number, name: user.user_detail.user_name, expMonth: UInt(expDateArray[0])!, expYear: UInt(expDateArray[1])!, cvc: user.more_detail.card.cvc, postalCode: user.more_detail.address.zipcode, cusId: cusId, hud: hud)
                    }
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


//MARK: - STRIPE SIMPLE PAYMENT METHOD
extension ConfirmOrderViewController {
    func stipeSimplePayment(paymentIntentClientSecret:String, cardNumber:String, name:String, expMonth:UInt, expYear:UInt, cvc:String, postalCode:String, cusId:String, hud:JGProgressHUD) {
        
        let cardParams = STPCardParams()
        cardParams.name = name
        cardParams.number = cardNumber
        cardParams.expMonth = expMonth
        cardParams.expYear = expYear
        cardParams.cvc = cvc
        cardParams.address.country = "US"
        cardParams.address.postalCode = postalCode
        
        let cardParameters = STPPaymentMethodCardParams(cardSourceParams: cardParams)
        let paymentMethodParams = STPPaymentMethodParams(card: cardParameters, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        paymentIntentParams.setupFutureUsage = .offSession
        
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            
            switch (status) {
            case .failed:
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                hud.dismiss()
            case .canceled:
                PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                hud.dismiss()
            case .succeeded:
                print(paymentIntent?.paymentMethodId)
                self.AddPurchasedProduct(cusId: cusId, hud: hud)
            @unknown default:
                fatalError()
                break
            }
        }
    }
}


//MARK: - STRIPE SUBSCRIPTION PAYMENT METHOD'S
extension ConfirmOrderViewController {
    
    func performStripePayment(hud:JGProgressHUD,cardNumber:String, expMonth:UInt, expYear:UInt, cvc:String, postalCode:String, price:Int , name:String, email:String) {
        //PopupHelper.showAnimating(self)
        let cardParams = STPCardParams()
        cardParams.name = name
        cardParams.number = cardNumber
        cardParams.expMonth = expMonth
        cardParams.expYear = expYear
        cardParams.cvc = cvc
        cardParams.address.country = "US"
        cardParams.address.postalCode = postalCode
        
        let paymentmethodcardparam = STPPaymentMethodCardParams(cardSourceParams: cardParams)
        let paymentMethodParams = STPPaymentMethodParams(card: paymentmethodcardparam, billingDetails: nil, metadata: nil)
        let periceValue = price * 100
        
        let clientName = name
        let clientemail = email
        createSubscription(hud: hud, name: clientName, email: clientemail, paymentMethodParams: paymentMethodParams, periceValue: periceValue)
    }
    
    func createSubscription(hud:JGProgressHUD,name:String, email:String, paymentMethodParams:STPPaymentMethodParams, periceValue:Int) {
        InvoiceStripClient.shared.createPayment(with: name,email: email) { (result, key, id) in
            switch result {
            case .success:
                guard let Subkey = key else { return }
                guard let cusId = id else { return }
                
                let paymentIntentParams = STPSetupIntentConfirmParams(clientSecret: Subkey)
                paymentIntentParams.paymentMethodParams = paymentMethodParams
                self.conformSetupIntent(hud: hud, paymentIntentParams: paymentIntentParams, periceValue: periceValue, id: cusId, type: "week")
                break
            case .failure(let error):
                hud.dismiss()
                PopupHelper.alertWithOk(title: "Oops!", message: error.localizedDescription, controler: self)
            }
        }
    }
    
    func conformSetupIntent(hud:JGProgressHUD,paymentIntentParams:STPSetupIntentConfirmParams,periceValue:Int, id:String, type:String) {
        STPPaymentHandler.shared().confirmSetupIntent(paymentIntentParams, with: self) { (status, paymentIntent, error) in
            switch (status){
            case .failed:
                hud.dismiss()
                PopupHelper.alertWithOk(title: "Oops!", message: error?.localizedDescription ?? "", controler: self)
                break
            case .canceled:
                hud.dismiss()
                PopupHelper.alertWithOk(title: "Oops!", message: error!.localizedDescription , controler: self)
                break
            case .succeeded:
                self.confirmPayment1(hud: hud, periceValue: periceValue, cusid: id, type: type, paymentIntent: paymentIntent!)
                break
            }
        }
    }
    
    func confirmPayment1(hud:JGProgressHUD,periceValue:Int,cusid:String,type:String,paymentIntent:STPSetupIntent) {
        InvoiceStripClient.shared.createPayment1( with: periceValue,id: cusid,type: type) { (result, key, id) in
            switch result {
            case .success:
                self.confirmPayment2(hud: hud, paymentIntent: paymentIntent, key: key!, cusid: cusid)
                break
            case .failure(let error):
                hud.dismiss()
                PopupHelper.alertWithOk(title: "Oops!", message: error.localizedDescription, controler: self)
            }
        }
    }
    
    func confirmPayment2(hud:JGProgressHUD,paymentIntent:STPSetupIntent,key:String,cusid:String) {
        InvoiceStripClient.shared.createPayment2(with: paymentIntent.paymentMethodID!,sub_id: key) { (result, key, id) in
            switch result {
            case .success:
                self.AddPurchasedProduct(cusId: cusid, hud: hud)
            //PopupHelper.alertWithOk(title: "Success", message: "Your subscription is completed", controler: self)
            case .failure(let error):
                hud.dismiss()
                PopupHelper.alertWithOk(title: "Oops!", message: error.localizedDescription, controler: self)
            }
        }
    }
    
    //    func performStripePayment(hud:JGProgressHUD,cardNumber:String, expMonth:UInt, expYear:UInt, cvc:String, postalCode:String, price:Int , name:String, email:String) {
    //        //PopupHelper.showAnimating(self)
    //        let cardParams = STPCardParams()
    //        cardParams.name = name
    //        cardParams.number = cardNumber
    //        cardParams.expMonth = expMonth
    //        cardParams.expYear = expYear
    //        cardParams.cvc = cvc
    //        cardParams.address.country = "US"
    //        cardParams.address.postalCode = postalCode
    //
    //        let paymentmethodcardparam = STPPaymentMethodCardParams(cardSourceParams: cardParams)
    //        let paymentMethodParams = STPPaymentMethodParams(card: paymentmethodcardparam, billingDetails: nil, metadata: nil)
    //        let periceValue = price * 100
    //
    //        let clientName = name
    //        let clientemail = email
    //        createSubscription(hud: hud, name: clientName, email: clientemail, paymentMethodParams: paymentMethodParams, periceValue: periceValue)
    //    }
    //
    //    func createSubscription(hud:JGProgressHUD,name:String, email:String, paymentMethodParams:STPPaymentMethodParams, periceValue:Int) {
    //        InvoiceStripClient.shared.createPayment(with: name,email: email) { (result, key, id) in
    //            switch result {
    //            case .success:
    //                guard let Subkey = key else { return }
    //                guard let cusId = id else { return }
    //
    //                let paymentIntentParams = STPSetupIntentConfirmParams(clientSecret: Subkey)
    //                paymentIntentParams.paymentMethodParams = paymentMethodParams
    //                self.conformSetupIntent(hud: hud, paymentIntentParams: paymentIntentParams, periceValue: periceValue, id: cusId, type: "week")
    //                break
    //            case .failure(let error):
    //                hud.dismiss()
    //                PopupHelper.alertWithOk(title: "Oops!", message: error.localizedDescription, controler: self)
    //            }
    //        }
    //    }
    //
    //    func conformSetupIntent(hud:JGProgressHUD,paymentIntentParams:STPSetupIntentConfirmParams,periceValue:Int, id:String, type:String) {
    //        STPPaymentHandler.shared().confirmSetupIntent(paymentIntentParams, with: self) { (status, paymentIntent, error) in
    //            switch (status){
    //            case .failed:
    //                hud.dismiss()
    //                PopupHelper.alertWithOk(title: "Oops!", message: error?.localizedDescription ?? "", controler: self)
    //                break
    //            case .canceled:
    //                hud.dismiss()
    //                PopupHelper.alertWithOk(title: "Oops!", message: error!.localizedDescription , controler: self)
    //                break
    //            case .succeeded:
    //                self.confirmPayment1(hud: hud, periceValue: periceValue, id: id, type: type, paymentIntent: paymentIntent!)
    //                break
    //            }
    //        }
    //    }
    //
    //    func confirmPayment1(hud:JGProgressHUD,periceValue:Int,id:String,type:String,paymentIntent:STPSetupIntent) {
    //        InvoiceStripClient.shared.createPayment1( with: periceValue,id: id,type: type) { (result, key, id) in
    //            switch result {
    //            case .success:
    //                self.confirmPayment2(hud: hud, paymentIntent: paymentIntent, key: key!)
    //                break
    //            case .failure(let error):
    //                hud.dismiss()
    //                PopupHelper.alertWithOk(title: "Oops!", message: error.localizedDescription, controler: self)
    //            }
    //        }
    //    }
    //
    //    func confirmPayment2(hud:JGProgressHUD,paymentIntent:STPSetupIntent,key:String) {
    //        InvoiceStripClient.shared.createPayment2(with: paymentIntent.paymentMethodID!,sub_id: key) { (result, key, id) in
    //            switch result {
    //            case .success:
    //                self.booking(cusId:id,hud: hud)
    //                PopupHelper.alertWithOk(title: "Success", message: "Your subscription is completed", controler: self)
    //            case .failure(let error):
    //                hud.dismiss()
    //                PopupHelper.alertWithOk(title: "Oops!", message: error.localizedDescription, controler: self)
    //            }
    //        }
    //    }
}


extension ConfirmOrderViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
