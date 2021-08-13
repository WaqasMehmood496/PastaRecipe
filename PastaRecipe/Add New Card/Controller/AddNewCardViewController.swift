//
//  AddNewCardViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 11/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD
import FormTextField
import Stripe

class AddNewCardViewController: UIViewController {
    
    //IBOUTLET
    @IBOutlet weak var AddCardTableView: UITableView!
        
    //VARIABLE
    var userData = MyCardModel()
    var dataDic:[String:Any]!
    var delegate:CardAndAddressViewController?
    var myCardData = MyCardModel()
    var isDefailtCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

//MARK:- API CALLING METHOD'S
extension AddNewCardViewController{
    func AddCard() {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                self.dataDic = [String:Any]()
                if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                    self.dataDic[Constant.card_number] = self.userData.card_number
                    self.dataDic[Constant.expired_date_c] = self.userData.expired_date_c
                    self.dataDic[Constant.cvc] = self.userData.cvc
                    self.dataDic[Constant.user_id] = Int(userId)
                    if self.isDefailtCard {
                        self.dataDic[Constant.bydefault] = 1
                    } else {
                        self.dataDic[Constant.bydefault] = 0
                    }
                    self.callWebService(.addcard, hud: hud)
                    
                } else {
                    PopupHelper.showAlertControllerWithError(forErrorMessage: "User id not be found", forViewController: self)
                }
            }
        }
    }
}


//MARK:- UITABLEVIEW METHOD'S EXTENSION
extension AddNewCardViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.DoneBtn.tag = indexPath.row
        cell.DefaultCardBtn.addTarget(self, action: #selector(DefaultCard(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func DoneBtn(_ sender:UIButton) {
        AddCard()
    }
    
    @objc func DefaultCard(_ sender:UIButton) {
        let cell = self.AddCardTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AddMyNewCardTableViewCell
        if isDefailtCard {
            isDefailtCard = false
            cell.DefaultImage.image = UIImage(named: "")
        } else {
            isDefailtCard = true
            cell.DefaultImage.image = UIImage(named: "check")
        }
    }
}

extension AddNewCardViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

extension AddNewCardViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.userData.card_number = textField.text!
        case 1:
            self.userData.expired_date_c = textField.text!
        case 2:
            self.self.userData.cvc = textField.text!
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            self.userData.card_number = textField.text!
        case 1:
            self.userData.expired_date_c = textField.text!
        case 2:
            self.self.userData.cvc = textField.text!
        default:
            break
        }
    }
}


// MARK:-Api Methods Extension
extension AddNewCardViewController:WebServiceResponseDelegate{
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let service = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: dataDic, relatedViewController: self,hud: hud)
        service.delegateForWebServiceResponse = self
        service.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .addcard:
            if let data = dataDict as? Dictionary<String, Any>{
                if let cardList = data["default_card"] as? NSDictionary{
                    myCardData = MyCardModel(dic: cardList) ?? MyCardModel()
                    hud.dismiss()
                    self.delegate?.upDateCard(cardData: self.myCardData, isDefault: isDefailtCard)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    hud.dismiss()
                }
            } else {
                hud.dismiss()
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}
