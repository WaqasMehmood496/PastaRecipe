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
    
    var orderDetail:OrdersModel!
    //var customerDetail:SCustomerModel?
    var delegate = ConfirmOrderViewController()
    //var totalPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        //CustomStyle.apply()
        self.tfcard()
        self.tfdate()
        self.tfcvc()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.layer.contents = #imageLiteral(resourceName: "dashbg").cgImage
        if let price = self.orderDetail.purchasingcoins{
            self.btnAddCard.setTitle("Pay $\(price)", for: .normal)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cardNumberChnaged(_ textField:UITextField){
        switch STPCardValidator.brand(forNumber: self.tfCardNumber.text!) {
        case .visa:
            if STPCardValidator.validationState(forNumber: self.tfCardNumber.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
            let arrow = UIImageView(image: #imageLiteral(resourceName: "Place Marker"))
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
    @IBAction func expiryDateChnaged(_ textField:UITextField){
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
    @IBAction func cvcNumberChnaged(_ textField:UITextField){
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
    func tfcard(){
        self.tfCardNumber.inputType = .integer
        self.tfCardNumber.formatter = CardNumberFormatter()
        self.tfCardNumber.placeholder = "Card Number"
        
        let arrow = UIImageView(image: #imageLiteral(resourceName: "Pin Location"))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        }
        arrow.contentMode = .scaleAspectFit
        self.tfCardNumber.leftView = arrow
        self.tfCardNumber.leftViewMode = .always
        
        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".count
        validation.minimumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        self.tfCardNumber.inputValidator = inputValidator
    }
    func tfdate(){
        self.tfExpiryDate.inputType = .integer
        self.tfExpiryDate.formatter = CardExpirationDateFormatter()
        self.tfExpiryDate.placeholder = "MM/YY"
        
        
        
        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        self.tfExpiryDate.inputValidator = inputValidator
    }
    func tfcvc(){
        self.tfcvcNumber.inputType = .integer
        self.tfcvcNumber.placeholder = "CVC"
        
        let arrow = UIImageView(image: #imageLiteral(resourceName: "Place Marker"))
        if let size = arrow.image?.size {
            arrow.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        }
        arrow.contentMode = .scaleAspectFit
        self.tfcvcNumber.leftView = arrow
        self.tfcvcNumber.leftViewMode = .always
        
        var validation = Validation()
        validation.maximumLength = "CVC".count
        validation.minimumLength = "CVC".count
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        self.tfcvcNumber.inputValidator = inputValidator
        
    }
    
    @IBAction func payCardBtnPressed(_ sender:Any){
        if self.tfCardNumber.textColor == UIColor.red || !self.tfCardNumber.isValid() || self.tfExpiryDate.textColor == UIColor.red || !self.tfExpiryDate.isValid() || self.tfcvcNumber.textColor == UIColor.red || !self.tfcvcNumber.isValid(){
            
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Please fill all field of valid column", forViewController: self)
        }
        else{
            self.addCard()
        }
        
    }
    
    func addCard(){
        PopupHelper.showAnimating(self)
        let cardParams = STPCardParams()
        let user = CommonHelper.getCachedUserData()
        if let fname = user?.user_name{
            cardParams.name = fname
        }
        
        cardParams.number = self.tfCardNumber.text
        if let date = self.tfExpiryDate.text?.components(separatedBy: "/"){
            let month = date[0]
            let year = date[1]
            cardParams.expMonth = UInt(month)!
            cardParams.expYear = UInt(year)!
            
        }
        
        cardParams.cvc = self.tfcvcNumber.text
        cardParams.address.country = "US"
        cardParams.address.postalCode = self.tfpostcode.text
        
        let paymentmethodcardparam = STPPaymentMethodCardParams(cardSourceParams: cardParams)
        
        
        let paymentMethodParams = STPPaymentMethodParams(card: paymentmethodcardparam, billingDetails: nil, metadata: nil)
        
        guard let price = self.orderDetail.purchasingcoins else{
            return
        }
        
        guard let periceValue = Int(price) else{
            return
        }
        let resultPrice = periceValue * 100
        let finalPrice = Int(resultPrice)
        InvoiceStripClient.shared.createPayment(with: finalPrice) { (result, key, id) in
            switch result{
            case .success:
                
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: key!)
                paymentIntentParams.paymentMethodParams = paymentMethodParams
                //paymentIntentParams.paymentMethodId = paymentMethodParams.card?.token
                paymentIntentParams.setupFutureUsage = STPPaymentIntentSetupFutureUsage(rawValue: Int(NSNumber(value: STPPaymentIntentSetupFutureUsage.onSession.rawValue)))
                //paymentIntentParams.setupFutureUsage = NSNumber(value: STPPaymentIntentSetupFutureUsage.offSession.rawValue)
                // Submit the payment
                let paymentHandler = STPPaymentHandler.shared()
                paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
                    switch (status){
                    case .failed:
                        
                        STPAPIClient.shared.retrievePaymentIntent(withClientSecret: key!) { (paymentIntent, error) in
                            guard error == nil, let lastPaymentError = paymentIntent?.lastPaymentError else {
                                // Handle error (e.g. allow your customer to retry)
                                self.stopAnimating()
                                self.dismiss(animated: true) {
                                    PopupHelper.showAlertControllerWithError(forErrorMessage: error?.localizedDescription, forViewController: self)
                                }
                                return
                            }
                            var failureReason = "Payment failed, try again." // Default to a generic error message
                            if lastPaymentError.type == .card {
                                failureReason = lastPaymentError.message!
                            }
                            else if lastPaymentError.type == .apiConnection{
                                failureReason = lastPaymentError.message!
                            }
                            else if lastPaymentError.type == .authentication{
                                failureReason = lastPaymentError.message!
                            }
                            else if lastPaymentError.type == .idempotency{
                                failureReason = lastPaymentError.message!
                            }
                            else if lastPaymentError.type == .invalidRequest{
                                failureReason = lastPaymentError.message!
                            }
                            else if lastPaymentError.type == .rateLimit{
                                failureReason = lastPaymentError.message!
                            }
                            else if lastPaymentError.type == .unknown{
                                failureReason = lastPaymentError.message!
                            }
                            PopupHelper.alertWithOk(title: "Oops!", message: failureReason, controler: self)
                            // Display the failure reason to your customer
                            // ...
                        }
                        
                        //self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                        break
                    case .canceled:
                        self.stopAnimating()
                        PopupHelper.alertWithOk(title: "Oops!", message: error!.localizedDescription , controler: self)
                        //self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                        break
                    case .succeeded:
                        //self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
                        self.stopAnimating()
                        
                        self.dismiss(animated: true) {
                            self.delegate.booking()
                        }
                        PopupHelper.showAlertControllerWithSuccessBacktoRoot(forErrorMessage: "Your payment process is successfully completed", forViewController: self)
                        break
                    @unknown default:
                        fatalError()
                        break
                    }
                }
            case .failure(let error):
                self.stopAnimating()
                PopupHelper.alertWithOk(title: "Oops!", message: error.localizedDescription, controler: self)
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if indexPath.row == 0{
        //            self.performSegue(withIdentifier: "toDetail", sender: nil)
        //        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension AddCardViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}
extension AddCardViewController:UITextFieldDelegate{
    
}
