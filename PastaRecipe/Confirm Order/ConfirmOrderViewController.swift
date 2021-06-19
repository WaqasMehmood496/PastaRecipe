//
//  ConfirmOrderViewController.swift
//  PastaRecipe
//
//  Created by Waqas on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD

class ConfirmOrderViewController: UIViewController {
    
    @IBOutlet weak var detailstf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    
    var selectedPlan = OrdersModel()
    //var totalPrice = 0
    var dataDic = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTf.attributedPlaceholder = NSAttributedString(string: "Address here", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Profile Label Color")!])
        detailstf.attributedPlaceholder = NSAttributedString(string: "Payment delivery Instruction", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Profile Label Color")!])
    }
    
    @IBAction func confirmOrderBtn(_ sender: Any) {
        let payment = storyboard?.instantiateViewController(identifier: "AddCardViewController") as! AddCardViewController
        payment.delegate = self
        //payment.orderDetail = selectedPlan
        selectedPlan.order_address = self.addressTf.text!
        payment.orderDetail = selectedPlan
        self.navigationController?.pushViewController(payment, animated: true)
    }
    func booking() {
        if addressTf.text! == "" || addressTf.text! == " "{
            PopupHelper.alertWithOk(title: "Address field empty", message: "Address is required, please type your address in field", controler: self)
        }else{
            self.GetAllPlansApi()
        }
    }
    
    func GetAllPlansApi() {
        
            showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
                hud.show(in: self.view, animated: true)
                if Connectivity.isConnectedToNetwork(){
                    
                    self.dataDic = [String:Any]()
                    guard let user = CommonHelper.getCachedUserData() else {return}
                    self.dataDic[Constant.user_id] = user.user_id
                    self.dataDic[Constant.shipping_address] = self.addressTf.text!
                    self.dataDic[Constant.shiping_month] = self.selectedPlan.order_date
                    self.dataDic[Constant.total_product] = "\(cartArray.count)"
                    self.dataDic[Constant.total_price] = "\(self.getPriceOfProducts())"
                    for i in 0..<cartArray.count{
                        self.dataDic["\(Constant.product_id)\(i)"] = cartArray[i].id
                        self.dataDic["\(Constant.quantity)\(i)"] = cartArray[i].quantity
                        self.dataDic["\(Constant.price)\(i)"] = cartArray[i].price
                    }
                    self.callWebService(.addpasteapurchyase, hud: hud)
                }else{
                    hud.textLabel.text = "You are not connected to the internet. Please check your connection"
                    hud.dismiss()
                }
            }
    }
    
    func getPriceOfProducts() -> String{
        var price = 0
        for i in 0..<cartArray.count{
            if let getPrice = Int(cartArray[i].price){
                price = price + getPrice
            }
        }
        return String(price)
    }
    
}

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
