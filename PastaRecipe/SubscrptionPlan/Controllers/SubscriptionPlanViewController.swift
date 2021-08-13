//
//  SubscriptionPlanViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 11/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import iOSDropDown

class SubscriptionPlanViewController: UIViewController {
    // IBOUTLET'S
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var SubscriptionTypeDropDown: DropDown!
    
    // VARIABLE'S
    var typeArray = [
        "Every Week",
        "Every Month"
    ]
    var selectedMonth = "1"
    var selectedSubs = OrdersModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func setupBtn(_ sender: Any) {
        
        let payment = storyboard?.instantiateViewController(identifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
        selectedSubs.order_date = selectedMonth
        payment.selectedPlan = selectedSubs
        self.navigationController?.pushViewController(payment, animated: true)
    }
}

//MARK:- HELPING METHOD'S
extension SubscriptionPlanViewController{
    
    func setupUI() {
        initializeDropDown()
        if let price = selectedSubs.purchasingcoins{
            self.priceLbl.text = "$\(price)"
        }
    }
    
    func initializeDropDown() {
        //        SubscriptionTypeDropDown.optionArray = [
        //            "Every Week",
        //            "Every Month",
        //            "Every 3 Month",
        //            "Every 6 Month"
        //        ]
        //        SubscriptionTypeDropDown.selectedIndex = 0
        //        SubscriptionTypeDropDown.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        //        SubscriptionTypeDropDown.didSelect{(selectedText , index , id) in
        //            self.selectedMonth = String(index + 1)
        //        }
        
        SubscriptionTypeDropDown.optionArray = self.typeArray
        SubscriptionTypeDropDown.selectedIndex = 0
        SubscriptionTypeDropDown.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        SubscriptionTypeDropDown.text = self.typeArray[0]
        SubscriptionTypeDropDown.didSelect{(selectedText , index , id) in
            self.selectedMonth = String(index + 1)
        }
    }
}
