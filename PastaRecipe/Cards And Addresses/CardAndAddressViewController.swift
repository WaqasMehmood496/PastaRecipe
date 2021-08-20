//
//  CardAndAddressViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 10/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD

class CardAndAddressViewController: UIViewController {
    
    //IBOUTLETS
    @IBOutlet weak var TypeSegment: UISegmentedControl!
    @IBOutlet weak var CardAndAddressTableView: UITableView!
    @IBOutlet weak var AddNewBtn: UIButton!
    
    //CONSTANTS
    
    //VARIABLES
    var selectedType = false
    var dataDic:[String:Any]!
    var myAddressArray = [MyAddressModel]()
    var myCardArray = [MyCardModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        getAllAddressApi()
    }
    
    @IBAction func TypeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedType = false
            self.AddNewBtn.setTitle("Add New Address", for: .normal)
        } else {
            selectedType = true
            self.AddNewBtn.setTitle("Add New Card", for: .normal)
        }
        self.CardAndAddressTableView.reloadData()
    }
    
    @IBAction func AddCardAndAddressBtnAction(_ sender: Any) {
        if selectedType{
            showAddNewCardViewController(isEdit: false, selectedCard: MyCardModel())
        } else {
            showAddNewAddressViewController(isEdit: false, myAddress: MyAddressModel())
        }
    }
}

//MARK:- HELPING METHOD'S
extension CardAndAddressViewController {
    
    func getViewController(identifier:String) -> UIViewController {
        return (storyboard?.instantiateViewController(withIdentifier: identifier))!
    }
    
    func showAddNewCardViewController(isEdit:Bool,selectedCard:MyCardModel) {
        let addCardViewController = getViewController(identifier: "AddNewCardViewController") as! AddNewCardViewController
        addCardViewController.delegate = self
        addCardViewController.isCardEdit = isEdit
        if isEdit {
            addCardViewController.userData = selectedCard
        }
        self.navigationController?.pushViewController(addCardViewController, animated: true)
    }
    
    func showAddNewAddressViewController(isEdit:Bool, myAddress:MyAddressModel) {
        let addAddressViewController = getViewController(identifier: "AddNewAddressViewController") as! AddNewAddressViewController
        addAddressViewController.delegate = self
        addAddressViewController.isEditAddress = isEdit
        if isEdit {
            addAddressViewController.myAddress = myAddress
        }
        self.navigationController?.pushViewController(addAddressViewController, animated: true)
    }
    
    func updateUserCacheAddress(address:MyAddressModel) {
        if let user = CommonHelper.getCachedUserData() {
            user.more_detail.address.address_main = address.address_main
            user.more_detail.address.adresss_id = address.adresss_id
            user.more_detail.address.bydefault = address.bydefault
            user.more_detail.address.city = address.city
            user.more_detail.address.country = address.country
            user.more_detail.address.state = address.state
            user.more_detail.address.lat = address.lat
            user.more_detail.address.lng = address.lng
            
            CommonHelper.saveCachedUserData(user)
        }
    }
    
    func updateUserCacheCard(card:MyCardModel) {
        if let user = CommonHelper.getCachedUserData() {
            user.more_detail.card.card_number = card.card_number
            user.more_detail.card.bydefault = card.bydefault
            user.more_detail.card.carddetail_id = card.carddetail_id
            user.more_detail.card.cvc = card.cvc
            user.more_detail.card.expired_date_c = card.expired_date_c
            
            CommonHelper.saveCachedUserData(user)
        }
    }
}


//MARK:- DELEGATE METHOD'S
extension CardAndAddressViewController {
    func upDateCard(cardData:MyCardModel,isDefault:Bool) {
        if isDefault {
            for (_,value) in self.myCardArray.enumerated() {
                value.bydefault = "0"
            }
        }
        updateUserCacheCard(card: cardData)
        myCardArray.append(cardData)
        CardAndAddressTableView.reloadData()
    }
    
    func upDateAddress(addressData:MyAddressModel,isDefault:Bool) {
        if isDefault {
            for (_,value) in self.myAddressArray.enumerated() {
                value.bydefault = "0"
            }
        }
        updateUserCacheAddress(address: addressData)
        myAddressArray.append(addressData)
        CardAndAddressTableView.reloadData()
    }
}


//MARK:- API CALLING METHOD'S
extension CardAndAddressViewController {
    func getAllAddressApi() {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                    self.dataDic = [String:Any]()
                    self.dataDic[Constant.user_id] = userId
                    self.callWebService(.myadress, hud: hud)
                } else {
                    hud.dismiss()
                }
            }
        }
    }
    
    func getAllCardApi(hud:JGProgressHUD) {
        if Connectivity.isConnectedToNetwork() {
            if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                self.dataDic = [String:Any]()
                self.dataDic[Constant.user_id] = userId
                self.callWebService(.mycard, hud: hud)
            } else {
                hud.dismiss()
            }
        }
    }
    
    func deleteCardApi(cardId:Int) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                    self.dataDic = [String:Any]()
                    self.dataDic[Constant.carddetail_id] = cardId
                    self.dataDic[Constant.user_id] = userId
                    self.callWebService(.detelecard, hud: hud)
                } else {
                    hud.dismiss()
                }
            }
        }
    }
    
    func deleteAddressApi(addressId:Int) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                    self.dataDic = [String:Any]()
                    self.dataDic[Constant.adresss_id] = addressId
                    self.dataDic[Constant.user_id] = userId
                    self.callWebService(.deteleadress, hud: hud)
                } else {
                    hud.dismiss()
                }
            }
        }
    }
    
    func setDefaultAddressApi(addressId:Int) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                    self.dataDic = [String:Any]()
                    self.dataDic[Constant.adresss_id] = addressId
                    self.dataDic[Constant.user_id] = userId
                    self.callWebService(.setasdefault, hud: hud)
                } else {
                    hud.dismiss()
                }
            }
        }
    }
    
    func setDefaultCardApi(cardId:Int) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork() {
                if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                    self.dataDic = [String:Any]()
                    self.dataDic[Constant.carddetail_id] = cardId
                    self.dataDic[Constant.user_id] = userId
                    self.callWebService(.setcardasdefault, hud: hud)
                } else {
                    hud.dismiss()
                }
            }
        }
    }
}






//MARK:- TABLEVIEW DATASOURCE AND DELEGATE METHODS
extension CardAndAddressViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType{
            return myCardArray.count
        } else {
            return myAddressArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! MyCardsTableViewCell
            cell.CVCLabel.text = myCardArray[indexPath.row].cvc
            cell.CardNumberLabel.text = myCardArray[indexPath.row].card_number
            cell.DateLabel.text = myCardArray[indexPath.row].expired_date_c
            if myCardArray[indexPath.row].bydefault == "1"{
                cell.DefaultCardLabel.text = "Yes"
            }else{
                cell.DefaultCardLabel.text = "No"
            }
            cell.EditBtn.addTarget(self, action: #selector(editCardBtnAction(_:)), for: .touchUpInside)
            cell.SetDefaultCardBtn.addTarget(self, action: #selector(setDefaultCardBtnAction(_:)), for: .touchUpInside)
            cell.EditBtn.tag = indexPath.row
            cell.SetDefaultCardBtn.tag = indexPath.row
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! MyAddressTableViewCell
            cell.AddressLabel.text = myAddressArray[indexPath.row].address_main
            cell.CityLabel.text = myAddressArray[indexPath.row].city
            cell.CountryLabel.text = myAddressArray[indexPath.row].country
            cell.StateLabel.text = myAddressArray[indexPath.row].state
            cell.ZipCodeLabel.text = myAddressArray[indexPath.row].zipcode
            if myAddressArray[indexPath.row].bydefault == "1"{
                cell.DefaultAddressLabel.text = "Yes"
            }else{
                cell.DefaultAddressLabel.text = "No"
            }
            cell.EditBtn.addTarget(self, action: #selector(editAddressBtnAction(_:)), for: .touchUpInside)
            cell.SetDefaultAddressBtn.addTarget(self, action: #selector(setDefaultAddressBtnAction(_:)), for: .touchUpInside)
            cell.EditBtn.tag = indexPath.row
            cell.SetDefaultAddressBtn.tag = indexPath.row
            return cell
        }
    }
    
    // CARD BUTTONS TARGET'S
    @objc func editCardBtnAction( _ sender: UIButton) {
        print("Edit card")
        showAddNewCardViewController(isEdit: true, selectedCard: self.myCardArray[sender.tag])
        
        
    }
    @objc func setDefaultCardBtnAction( _ sender: UIButton) {
        if let cardId = Int(myCardArray[sender.tag].carddetail_id){
            setDefaultCardApi(cardId: cardId)
        }
    }
    
    // ADDRESS BUTTONS TARGET'S
    @objc func editAddressBtnAction( _ sender: UIButton) {
        showAddNewAddressViewController(isEdit: true, myAddress: self.myAddressArray[sender.tag])
        print("Edit Address")
    }
    @objc func setDefaultAddressBtnAction( _ sender: UIButton) {
        print("Default Address")
        if let addressId = Int(myAddressArray[sender.tag].adresss_id){
            setDefaultAddressApi(addressId: addressId)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if selectedType {
                //Delete Card
                self.deleteCardApi(cardId: Int(self.myCardArray[indexPath.row].carddetail_id)!)
            } else {
                //Delete Address
                self.deleteAddressApi(addressId: Int(self.myAddressArray[indexPath.row].adresss_id)!)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}







// MARK:- API RESPONSE HANDLING METHOD'S
extension CardAndAddressViewController:WebServiceResponseDelegate { 
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let service = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: dataDic, relatedViewController: self,hud: hud)
        service.delegateForWebServiceResponse = self
        service.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .myadress:
            if let data = dataDict as? Dictionary<String, Any>{
                self.myAddressArray.removeAll()
                self.myCardArray.removeAll()
                if let addressList = data["address_list"] as? NSArray{
                    for address in addressList {
                        if let myaddress = address as? NSDictionary {
                            if let isDefault = myaddress ["bydefault"] as? String {
                                if isDefault == "1" {
                                    let defaultAddress = MyAddressModel(dic: address as! NSDictionary)
                                    self.updateUserCacheAddress(address: defaultAddress!)
                                }
                            }
                            myAddressArray.append(MyAddressModel(dic: myaddress) ?? MyAddressModel())
                        }
                    }
                    //Call Cards api
                    getAllCardApi(hud: hud)
                } else {
                    hud.dismiss()
                }
            } else {
                hud.dismiss()
            }
        case .mycard:
            if let data = dataDict as? Dictionary<String, Any>{
                if let cardList = data["card_list"] as? NSArray{
                    for card in cardList {
                        if let myCard = card as? NSDictionary{
                            if let isDefault = myCard ["bydefault"] as? String {
                                if isDefault == "1" {
                                    let defaultCard = MyCardModel(dic: card as! NSDictionary)!
                                    self.updateUserCacheCard(card: defaultCard)
                                }
                            }
                            myCardArray.append(MyCardModel(dic: myCard) ?? MyCardModel())
                        }
                    }
                    hud.dismiss()
                    self.CardAndAddressTableView.reloadData()
                } else {
                    hud.dismiss()
                }
            } else {
                hud.dismiss()
            }
        case .detelecard:
            if let data = dataDict as? Dictionary<String, Any>{
                if let addressList = data["card_list"] as? NSArray{
                    self.myCardArray.removeAll()
                    for address in addressList {
                        if let myaddress = address as? NSDictionary{
                            myCardArray.append(MyCardModel(dic: myaddress) ?? MyCardModel())
                        }
                    }
                    hud.dismiss()
                } else {
                    hud.dismiss()
                }
            } else {
                hud.dismiss()
            }
        case .deteleadress:
            if let data = dataDict as? Dictionary<String, Any>{
                if let addressList = data["address_list"] as? NSArray{
                    self.myAddressArray.removeAll()
                    for address in addressList {
                        if let myaddress = address as? NSDictionary{
                            myAddressArray.append(MyAddressModel(dic: myaddress) ?? MyAddressModel())
                        }
                    }
                    hud.dismiss()
                } else {
                    hud.dismiss()
                }
            } else {
                hud.dismiss()
            }
        case .setasdefault:
            if dataDict is Dictionary<String, Any>{
                getAllAddressApi()
                hud.dismiss()
            } else {
                hud.dismiss()
            }
        case .setcardasdefault:
            if dataDict is Dictionary<String, Any>{
                
                getAllAddressApi()
                hud.dismiss()
            } else {
                hud.dismiss()
            }
        default:
            hud.dismiss()
        }
    }
}
