//
//  subscrpionplanViewController.swift
//  PastaRecipe
//
//  Created by Waqas on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import iOSDropDown

class subscrpionplanViewController: UIViewController {
    
    @IBOutlet weak var easyDropdown: DropDown!
    @IBOutlet weak var priceLbl: UILabel!
    
    var selectedMonth = "1"
    var selectedSubs = OrdersModel()
    //var totalPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        easyDropdown.optionArray = ["Every Week","Every Month", "Every 3 Month", "Every 6 Month"]
        easyDropdown.selectedIndex = 0
        easyDropdown.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        easyDropdown.didSelect{(selectedText , index , id) in
            self.selectedMonth = String(index + 1)
        }
        if let price = selectedSubs.purchasingcoins{
            self.priceLbl.text = "$\(price)"
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setupBtn(_ sender: Any) {
        
        let payment = storyboard?.instantiateViewController(identifier: "ConfirmOrderViewController") as! ConfirmOrderViewController
        selectedSubs.order_date = selectedMonth
        payment.selectedPlan = selectedSubs
        self.navigationController?.pushViewController(payment, animated: true)
    }
}
