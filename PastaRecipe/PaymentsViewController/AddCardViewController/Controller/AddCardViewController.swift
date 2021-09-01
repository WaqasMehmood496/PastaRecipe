//
//  AddCardViewController.swift
//  TastyBox
//
//  Created by Adeel on 26/06/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit
import Stripe
import JGProgressHUD
import FormTextField

class AddCardViewController: UITableViewController {
    
    @IBOutlet weak var tfCardNumber:FormTextField!
    @IBOutlet weak var tfExpiryDate:FormTextField!
    @IBOutlet weak var tfcvcNumber:FormTextField!
    @IBOutlet weak var tfpostcode:UITextField!
    @IBOutlet weak var btnAddCard:UIButton!
    
    //CONSTANT'S
    let internetConnectionMsg = "You are not connected to the internet. Please check your connection"
    let cvvImage = "credit-card-2"
    let cardNumberImage = "credit-card"
    
    //VARIABLE'S
    var email = String()
    var name = String()
    var orderDetail:OrdersModel!
    var delegate = ConfirmOrderViewController()
    var isSubscription = false
    var dataDic = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tfcard()
        self.tfdate()
        self.tfcvc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let price = self.orderDetail.purchasingcoins{
            self.btnAddCard.setTitle("Pay $\(price)", for: .normal)
        }
    }
    
    @IBAction func cardNumberChnaged(_ textField:UITextField) {
        switch STPCardValidator.brand(forNumber: self.tfCardNumber.text!) {
        case .visa:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: UIImage(named: cvvImage))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
            
        case .mastercard:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "Warehouse"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .amex:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "search"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .dinersClub:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "play"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .discover:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "play"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .JCB:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "Award"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .unionPay:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "play"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        case .unknown:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "FillFavorite"))
            if let size = arrow.image?.size {
                arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            }
            arrow.contentMode = .scaleAspectFit
            self.tfCardNumber.leftView = arrow
            self.tfCardNumber.leftViewMode = .always
        default:
            textField.textColor = .red
            break
        }
    }
    
    @IBAction func expiryDateChnaged(_ textField:UITextField) {
        if textField.text!.contains("/"){
            if let date = textField.text?.components(separatedBy: "/") as? [String]?{
                if let month = date?[0],let year = date?[1]{
                    if STPCardValidator.validationState(forExpirationMonth: month) == .valid && STPCardValidator.validationState(forExpirationYear: year, inMonth: month) == .valid{
                        textField.textColor = .green
                    }
                    else{
                        textField.textColor = .red
                    }
                }
                else{
                    if let month = date?[0]{
                        if STPCardValidator.validationState(forExpirationMonth: month) == .valid{
                            textField.textColor = .green
                        }
                        else{
                            textField.textColor = .red
                        }
                    }
                }
            }
            else{
                textField.textColor = .red
            }
        }
        else{
            if let month = textField.text{
                if STPCardValidator.validationState(forExpirationMonth: month) == .valid{
                    textField.textColor = .green
                }
                else{
                    textField.textColor = .red
                }
            }
        }
        
    }
    
    @IBAction func cvcNumberChnaged(_ textField:UITextField) {
        if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .visa) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .amex) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .dinersClub) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .discover) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .JCB) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .mastercard) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand: .unionPay) == .valid{
            textField.textColor = .green
        }
        else if STPCardValidator.validationState(forCVC: textField.text!, cardBrand:  .unknown) == .valid{
            textField.textColor = .green
        }
        else{
            textField.textColor = .red
        }
    }
    
    @IBAction func payCardBtnPressed(_ sender:Any) {
        if self.tfCardNumber.textColor == UIColor.red || !self.tfCardNumber.isValid() || self.tfExpiryDate.textColor == UIColor.red || !self.tfExpiryDate.isValid() || self.tfcvcNumber.textColor == UIColor.red || !self.tfcvcNumber.isValid(){
            
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill all field of valid column", forViewController: self)
        }
        else{
            //self.addCard()
            showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
                hud.show(in: self.view, animated: true)
                if self.isSubscription {
                    guard let price = self.orderDetail.purchasingcoins else{
                        return
                    }
                    let date = self.tfExpiryDate.text!.components(separatedBy: "/")
                    self.performStripePayment(hud: hud, cardNumber: self.tfCardNumber.text!, expMonth: UInt(date[0])!, expYear: UInt(date[1])!, cvc: self.tfcvcNumber.text!, postalCode: self.tfpostcode.text!, price: Int(price)!, name: self.name, email: self.email)
                }else {
                    // Perform one time purchasing
                    self.SimplePayment(hud: hud)
                }
            }
        }
    }
}


//MARK: API CALLING METHOD'S
extension AddCardViewController {
    func SimplePayment(hud:JGProgressHUD) {
        if Connectivity.isConnectedToNetwork() {
            self.dataDic = [String:Any]()
            self.dataDic[Constant.email] = email
            self.dataDic[Constant.name] = name
            self.dataDic[Constant.amount] = Int(self.orderDetail.purchasingcoins)! * 100
            self.callWebService(.stripe_payment, hud: hud)
        } else {
            hud.textLabel.text = self.internetConnectionMsg
            hud.dismiss()
        }
    }
}


//MARK:- WEBSERVICES METHOD'S
extension AddCardViewController:WebServiceResponseDelegate {
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        
        case .stripe_payment:
            
            print(dataDict)
            if let data = dataDict as? Dictionary<String, Any>{
                if let key = data["key"] as? String {
                    
                    guard let cusId = data["cus_id"] as? String else {
                        return
                    }
                    let expDateArray = tfExpiryDate.text!.components(separatedBy: "/")
                    stipeSimplePayment(paymentIntentClientSecret: key, cardNumber: self.tfCardNumber.text!, name: name, expMonth: UInt(expDateArray[0])!, expYear: UInt(expDateArray[1])!, cvc: self.tfcvcNumber.text!, postalCode: "123", cusId: cusId, hud: hud)
                    
                } else {
                    hud.dismiss()
                    PopupHelper.showAlertControllerWithError(forErrorMessage: "Transection fail", forViewController: self)
                }
            } else {
                hud.dismiss()
                PopupHelper.showAlertControllerWithError(forErrorMessage: "Transection fail", forViewController: self)
            }
        default:
            hud.dismiss()
        }
    }
}


//MARK: - STRIPE SIMPLE PAYMENT METHOD
extension AddCardViewController {
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
                self.dismiss(animated: true) {
                    self.delegate.booking(cusId:cusId,hud: hud)
                }
                
            @unknown default:
                fatalError()
                break
            }
        }
    }
}


//MARK:- HELPING METHOD'S
extension AddCardViewController {
    func tfcard() {
        self.tfCardNumber.inputType = .integer
        self.tfCardNumber.formatter = CardNumberFormatter()
        self.tfCardNumber.placeholder = "Card Number"
        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".count
        validation.minimumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        self.tfCardNumber.inputValidator = inputValidator
    }
    func tfdate() {
        self.tfExpiryDate.inputType = .integer
        self.tfExpiryDate.formatter = CardExpirationDateFormatter()
        self.tfExpiryDate.placeholder = "MM/YY"
        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        self.tfExpiryDate.inputValidator = inputValidator
    }
    func tfcvc() {
        self.tfcvcNumber.inputType = .integer
        self.tfcvcNumber.placeholder = "CVC"
        var validation = Validation()
        validation.maximumLength = "CVC".count
        validation.minimumLength = "CVC".count
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        self.tfcvcNumber.inputValidator = inputValidator
        
    }
}


//MARK:- TABLEVIEW DELEGATES AND DATASOURCE METHOD'S
extension AddCardViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: - STRIPE PAYMENT METHOD'S
extension AddCardViewController {
    
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
                self.dismiss(animated: true) {
                    self.delegate.booking(cusId:cusid,hud: hud)
                }
            case .failure(let error):
                hud.dismiss()
                PopupHelper.alertWithOk(title: "Oops!", message: error.localizedDescription, controler: self)
            }
        }
    }
}


extension AddCardViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension AddCardViewController:UITextFieldDelegate{
    
}
