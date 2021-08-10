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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        getAllAddress()
    }
    
    @IBAction func TypeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedType = false
            self.CardAndAddressTableView.reloadData()
            self.AddNewBtn.setTitle("Add New Address", for: .normal)
        } else {
            selectedType = true
            self.CardAndAddressTableView.reloadData()
            self.AddNewBtn.setTitle("Add New Card", for: .normal)
        }
    }
}

//MARK:- Calling Api Mehtods
extension CardAndAddressViewController {
    func getAllAddress(){
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
}

extension CardAndAddressViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType{
            return 1
        } else {
            return self.myAddressArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedType {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! MyCardsTableViewCell
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
}


// MARK:-Api Methods Extension
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
                    hud.dismiss()
                    self.CardAndAddressTableView.reloadData()
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
