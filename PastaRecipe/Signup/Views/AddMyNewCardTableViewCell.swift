//
//  AddMyNewCardTableViewCell.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 05/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import Stripe
import JGProgressHUD
import FormTextField
import iOSDropDown

class AddMyNewCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DoneBtn: UIButton!
    @IBOutlet weak var CardNumberTextfield: FormTextField!
    @IBOutlet weak var ExpireDateTextfield: FormTextField!
    @IBOutlet weak var CVCTextfield: FormTextField!
    @IBOutlet weak var DefaultCardBtn: UIButton!
    @IBOutlet weak var BillingAddressBtn: UIButton!
    @IBOutlet weak var OpenMapBtn: UIButton!
    @IBOutlet weak var DefaultImage: UIImageView!
    @IBOutlet weak var CheckMarkImage: UIImageView!
    @IBOutlet weak var ZipCodeField: DropDown!
    @IBOutlet weak var BillingAddressField: UITextField!
    @IBOutlet weak var CountryField: UITextField!
    @IBOutlet weak var StateField: UITextField!
    @IBOutlet weak var CityField: UITextField!
    
    //VARIABLE'S
    let cvvImage = "credit-card-2"
    let cardNumberImage = "credit-card"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tfcard()
        tfdate()
        tfcvc()
    }
    
    @IBAction func cardNumberChnaged(_ textField:UITextField) {
        switch STPCardValidator.brand(forNumber: self.CardNumberTextfield.text!) {
        case .visa:
            if STPCardValidator.validationState(forNumber: self.CardNumberTextfield.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
        case .mastercard:
            if STPCardValidator.validationState(forNumber: self.CardNumberTextfield.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
        case .amex:
            if STPCardValidator.validationState(forNumber: self.CardNumberTextfield.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
        case .dinersClub:
            if STPCardValidator.validationState(forNumber: self.CardNumberTextfield.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
        case .discover:
            if STPCardValidator.validationState(forNumber: self.CardNumberTextfield.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
        case .JCB:
            if STPCardValidator.validationState(forNumber: self.CardNumberTextfield.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
        case .unionPay:
            if STPCardValidator.validationState(forNumber: self.CardNumberTextfield.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
        case .unknown:
            if STPCardValidator.validationState(forNumber: self.CardNumberTextfield.text!, validatingCardBrand: true) == .valid{
                textField.textColor = .green
            }
            else{
                textField.textColor = .red
            }
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
    func tfcard() {
        self.CardNumberTextfield.inputType = .integer
        self.CardNumberTextfield.backgroundColor = UIColor(named: "Theam 2")!
        self.CardNumberTextfield.formatter = CardNumberFormatter()
        self.CardNumberTextfield.placeholder = "Card Number"
        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".count
        validation.minimumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        self.CardNumberTextfield.inputValidator = inputValidator
    }
    
    func tfdate() {
        self.ExpireDateTextfield.inputType = .integer
        self.ExpireDateTextfield.backgroundColor = UIColor(named: "Theam 2")!
        self.ExpireDateTextfield.formatter = CardExpirationDateFormatter()
        self.ExpireDateTextfield.placeholder = "MM/YY"
        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        self.ExpireDateTextfield.inputValidator = inputValidator
    }
    
    func tfcvc() {
        self.CVCTextfield.inputType = .integer
        self.CVCTextfield.backgroundColor = UIColor(named: "Theam 2")!
        self.CVCTextfield.placeholder = "CVC"
        var validation = Validation()
        validation.maximumLength = "CVC".count
        validation.minimumLength = "CVC".count
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        self.CVCTextfield.inputValidator = inputValidator
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
