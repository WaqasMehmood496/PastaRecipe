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
        self.navigationController?.navigationBar.isHidden = true
        UserProfileImage.layer.cornerRadius = UserProfileImage.frame.height/2
        guard let user = CommonHelper.getCachedUserData() else {
            return
        }
       // usernameLbl.text = name
        print(user.user_id)
        
    }
    
    @IBAction func yourPlanBtn(_ sender: Any) {
    }
    
    @IBAction func yourpointsBTn(_ sender: Any) {
    }
    
    @IBAction func yourOrderBtn(_ sender: Any) {
    }
    
}
