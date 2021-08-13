//
//  SubscriptionTypeVC.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 12/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import iOSDropDown

class SubscriptionTypeVC: UIViewController {
    
    //IBOUTLET'S
    @IBOutlet weak var OptionField: DropDown!
    @IBOutlet weak var TotalPriceLabel: UILabel!
    
    //VARIABLES
    var selectedSubs = OrdersModel()
    var selectedMonth = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //IBACTION'S
    @IBAction func SetupNowBtnAction(_ sender: Any) {
        let payment = storyboard?.instantiateViewController(identifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
        selectedSubs.order_date = selectedMonth
        payment.selectedPlan = selectedSubs
        self.navigationController?.pushViewController(payment, animated: true)
    }
    
    // HELPING METHOD'S
    func initialSetup() {
        if let price = selectedSubs.purchasingcoins{
            self.TotalPriceLabel.text = "$\(price)"
        }
        //DROPDOWN LIST SETUP
        OptionField.optionArray = [
            "Every Week",
            "Every Month",
            "Every 3 Month",
            "Every 6 Month"
        ]
        OptionField.selectedIndex = 0
        OptionField.didSelect { (selectedText, index, id) in
            self.selectedMonth = String(index + 1)
        }
    }
}
