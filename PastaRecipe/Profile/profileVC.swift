//
//  profileVC.swift
//  PastaRecipe
//
//  Created by moin janjua on 28/09/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class profileVC: UIViewController{
    
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var UserProfileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserProfileImage.layer.cornerRadius = UserProfileImage.frame.height/2
        if let user = CommonHelper.getCachedUserData() {
            self.usernameLbl.text = user.user_detail.user_name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func yourPlanBtn(_ sender: Any) {
    }
    
    @IBAction func yourpointsBTn(_ sender: Any) {
    }
    
    @IBAction func yourOrderBtn(_ sender: Any) {
    }
    
    @IBAction func MyCardAndAddresBtnAction(_ sender: Any) {
        let mycardAndAddressVC = storyboard?.instantiateViewController(withIdentifier: "CardAndAddressViewController") as! CardAndAddressViewController
        self.navigationController?.pushViewController(mycardAndAddressVC, animated: true)
    }
}
