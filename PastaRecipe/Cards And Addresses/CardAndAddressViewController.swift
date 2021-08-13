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
            let addCardViewController = getViewController(identifier: "AddNewCardViewController") as! AddNewCardViewController
            addCardViewController.delegate = self
            self.navigationController?.pushViewController(addCardViewController, animated: true)
        } else {
            let addAddressViewController = getViewController(identifier: "AddNewAddressViewController") as! AddNewAddressViewController
            addAddressViewController.delegate = self
            self.navigationController?.pushViewController(addAddressViewController, animated: true)
        }
    }
}

extension CardAndAddressViewController {
    func getViewController(identifier:String) -> UIViewController {
        return (storyboard?.instantiateViewController(withIdentifier: identifier))!
        
    }
}


//MARK:- DELEGATE METHOD'S
extension CardAndAddressViewController {
    func upDateCard(cardData:MyCardModel,isDefault:Bool) {
        if isDefault {
            self.myCardArray.last?.bydefault = "0"
        }
        self.myCardArray.append(cardData)
        self.CardAndAddressTableView.reloadData()
    }
    func upDateAddress(addressData:MyAddressModel,isDefault:Bool) {
        if isDefault {
            self.myAddressArray.last?.bydefault = "0"
        }
        self.myAddressArray.append(addressData)
        self.CardAndAddressTableView.reloadData()
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
            return cell
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
            
            ///objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
                if let addressList = data["address_list"] as? NSArray{
                    for address in addressList {
                        if let myaddress = address as? NSDictionary{
                            myAddressArray.append(MyAddressModel(dic: myaddress) ?? MyAddressModel())
                        }
                    }
                    //Call Cards api
                    getAllCardApi(hud: hud)
                    //self.CardAndAddressTableView.reloadData()
                } else {
                    hud.dismiss()
                }
            } else {
                hud.dismiss()
            }
        case .mycard:
            if let data = dataDict as? Dictionary<String, Any>{
                if let addressList = data["card_list"] as? NSArray{
                    for address in addressList {
                        if let myaddress = address as? NSDictionary{
                            myCardArray.append(MyCardModel(dic: myaddress) ?? MyCardModel())
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
        default:
            hud.dismiss()
        }
    }
}
