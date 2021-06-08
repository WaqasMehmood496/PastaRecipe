//
//  SubscriptionPlanNameVC.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 07/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class SubscriptionPlanNameVC: UIViewController {

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserCoins: UILabel!
    @IBOutlet weak var CurrentPlanName: UILabel!
    @IBOutlet weak var NextDeliveryDate: UILabel!
    @IBOutlet weak var ActivityIndicatorView: NVActivityIndicatorView!
    
    var SubscriptionData = SubscriptionPlanNameModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeData()
        //CallApi()
    }
    
    func initializeData() {
        let userData = UserModel.LoadData(key: userDataKey)
        UserImage.sd_setImage(with: URL(string: userData.image_url), placeholderImage: #imageLiteral(resourceName: "Placeholder"))
        UserName.text = userData.user_name
        UserCoins.text = userData.coins + " Coins"
        CurrentPlanName.text = ""
        NextDeliveryDate.text = userData.coins + ""
    }

//    func CallApi() {
//        if Connectivity.isConnectedToNetwork(){
//            self.ActivityIndicatorView.startAnimating()
//            let userData = UserModel.LoadData(key: userDataKey)
//            let parameter = ["user_id":"\(userData.user_id)"]
//
//            AlamoHelper.PostRequest(Url: baseUrl+"myplan", Parm: parameter, Header: [:]) { (JSON) in
//                print(JSON)
//                if JSON["success"].stringValue == "1"{
//                    let tempObj = SubscriptionPlanNameModel()
//                    tempObj.plan_name = JSON["return_data"]["plan"]["plan_name"].stringValue
//                    tempObj.plan_description = JSON["return_data"]["plan"]["plan_description"].stringValue
//                    self.SubscriptionData = tempObj
//                    self.AssignData()
//                }
//                self.ActivityIndicatorView.stopAnimating()
//            }
//        }else{
//            print("Network not found")
//            ShowAlert(view: self, message: "You are not connected to the internet. Please check your connection", Title: "Network Connection Error")
//        }
//    }
    
    func AssignData() {
        CurrentPlanName.text = SubscriptionData.plan_name
        NextDeliveryDate.text = SubscriptionData.plan_description
    }
}
