//
//  ConfirmOrderViewController.swift
//  PastaRecipe
//
//  Created by Waqas on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController {
    
    @IBOutlet weak var detailstf: UITextField!
    @IBOutlet weak var addressTf: UITextField!
    
    var selectedPlan = OrdersModel()
    //var totalPrice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTf.attributedPlaceholder = NSAttributedString(string: "Address here", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Profile Label Color")])
        detailstf.attributedPlaceholder = NSAttributedString(string: "Payment delivery Instruction", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Profile Label Color")])
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeIntoOrderModel() {
        
    }
    
}
