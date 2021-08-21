//
//  profileVC.swift
//  PastaRecipe
//
//  Created by moin janjua on 28/09/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit
import SDWebImage
import AZTabBar

class profileVC: UIViewController {
    
//    @IBOutlet weak var monthLbl: UILabel!
//    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var UserProfileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var CoinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = CommonHelper.getCachedUserData() {
            self.usernameLbl.text = user.user_detail.user_name
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        if let coins = CommonHelper.getCachedUserData()?.user_detail.coins {
            self.CoinLabel.text = coins
        }
    }
    
    @IBAction func yourPlanBtn(_ sender: Any) {
    }
    
    @IBAction func yourpointsBTn(_ sender: Any) {
    }
    
    @IBAction func yourOrderBtn(_ sender: Any) {
    }
    @IBAction func LogoutBtnAction(_ sender: Any) {
        defaults.set(false, forKey: Constant.userLoginStatusKey)
        if let controller = self.parent?.parent as? AZTabBarController{
            let profileVC = UIStoryboard(name: Constant.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            controller.setViewController(profileVC, atIndex: 1)
        }
    }
    
    @IBAction func MyCardAndAddresBtnAction(_ sender: Any) {
        let mycardAndAddressVC = storyboard?.instantiateViewController(withIdentifier: "CardAndAddressViewController") as! CardAndAddressViewController
        self.navigationController?.pushViewController(mycardAndAddressVC, animated: true)
    }
}
