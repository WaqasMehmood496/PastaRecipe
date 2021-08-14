//
//  AddToCartViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 04/06/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class AddToCartViewController: UIViewController {
    
    // IBOUTLET'S
    @IBOutlet weak var ItemsTableView: UITableView!
    @IBOutlet weak var SubTotalLabel: UILabel!
    @IBOutlet weak var DeliveryChargesLabel: UILabel!
    @IBOutlet weak var TotalLabel: UILabel!
    
    // CONSTANT'S
    let toConfirmOrdeSegue = "toConfirmOrde"
    let messageTitle = "Message"
    let itemsCellIdentifier = "ItemsCell"
    
    // VARIABLE'S
    var SubTotal = 0
    var isSubscription = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calculateValue()
    }
    
    //MARK: IBACTIONS'S
    @IBAction func CheckOutBtnAction(_ sender: Any) {
        let price = Int(self.TotalLabel.text!)
        if let totalPrice = price {
            if totalPrice > 6 {
                if isSubscription {
                    let payment = storyboard?.instantiateViewController(identifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
                    payment.isSubscription = isSubscription
                    if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                        payment.selectedPlan = OrdersModel (
                            user_id:  Int64(userId),
                            SubscriptionId: 0,
                            order_date: "every week",
                            order_time: "",
                            order_address: "",
                            order_lat: "",
                            purchasingcoins: "\(SubTotal+1)",
                            order_lng: ""
                        )
                    }
                    
                    self.navigationController?.pushViewController(payment, animated: true)
                } else {
                    self.performSegue(withIdentifier: toConfirmOrdeSegue, sender: nil)
                }
                
            } else {
                PopupHelper.alertWithOk(
                    title: messageTitle,
                    message: "Purchases must be greater then $6",
                    controler: self
                )
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SubscriptionTypeVC {
            if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                destination.selectedSubs = OrdersModel (
                    user_id:  Int64(userId),
                    SubscriptionId: 0,
                    order_date: "every week",
                    order_time: "",
                    order_address: "",
                    order_lat: "",
                    purchasingcoins: "\(SubTotal+1)",
                    order_lng: ""
                )
            } else {
                destination.selectedSubs = OrdersModel (
                    user_id: 0 ,
                    SubscriptionId: 0,
                    order_date: "every week",
                    order_time: "",
                    order_address: "",
                    order_lat: "",
                    purchasingcoins: "\(SubTotal+1)",
                    order_lng: ""
                )
            }
            destination.isSubscription = isSubscription
        }
    }
}

//MARK:- FUNCTION'S/METHOD'S EXTENSION
extension AddToCartViewController {
    
    func calculateValue() {
        self.SubTotal = 0
        for data in cartArray {
            let converIntoInt = Int(data.price)
            if let price = converIntoInt{
                SubTotal = SubTotal + price
            }
        }
        self.SubTotalLabel.text = "\(SubTotal)"
        self.TotalLabel.text = "\(SubTotal+1)"
    }
    
    func IncrementValue(price:String) {
        let priceInInt = Int(price)
        if let productPrice = priceInInt{
            SubTotal = SubTotal + productPrice
            self.SubTotalLabel.text = String(SubTotal)
            self.TotalLabel.text = "\(SubTotal+1)"
        }
    }
    
    func DecrementValue(price:String) {
        let priceInInt = Int(price)
        if let productPrice = priceInInt {
            SubTotal = SubTotal - productPrice
            self.SubTotalLabel.text = String(SubTotal)
            self.TotalLabel.text = "\(SubTotal+1)"
        }
    }
}


//MARK:- UITBALEVIEW DELEGATE AND DATASOURCE METHODS
extension AddToCartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemsCellIdentifier, for: indexPath) as! CartItemsTableViewCell
        cell.Coins.text = cartArray[indexPath.row].price
        cell.ItemImage.sd_setImage (
            with: URL (
                string: cartArray[indexPath.row].image
            ),placeholderImage: #imageLiteral(resourceName: "101")
        )
        cell.ItemQuantity.text = cartArray[indexPath.row].quantity
        cell.ItemTilte.text = cartArray[indexPath.row].title
        
        //ASSIGNING BUTTON TARGET'S
        cell.IncrementBtn.addTarget(self, action: #selector(IncrementBtnAction(_:)), for: .touchUpInside)
        cell.IncrementBtn.tag = indexPath.row
        cell.DecrementBtn.addTarget(self, action: #selector(DecrementBtnAction(_:)), for: .touchUpInside)
        cell.DecrementBtn.tag = indexPath.row
        return cell
    }
    
    //MARK: Cell Increment and Decrement Actions
    // This method will increment the product quantity
    @objc func IncrementBtnAction(_ sender: UIButton){
        let initalValue = Int64(cartArray[sender.tag].quantity)
        if let value = initalValue{
            let incrementValue = value + 1
            cartArray[sender.tag].quantity = String(incrementValue)
        }
        self.IncrementValue(price: cartArray[sender.tag].price)
        self.ItemsTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: UITableView.RowAnimation.none)
        
    }
    // This method will decrement the product quantity
    @objc func DecrementBtnAction(_ sender: UIButton){
        let initalValue = Int64(cartArray[sender.tag].quantity)
        if let value = initalValue{
            if value > 0{
                let decrementValue = value - 1
                cartArray[sender.tag].quantity = String(decrementValue)
            }
        }
        self.DecrementValue(price: cartArray[sender.tag].price)
        self.ItemsTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: UITableView.RowAnimation.none)
    }
    
}
