//
//  RecipesTBViewController.swift
//  PastaRecipe
//
//  Created by Waqas on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD


class RecipesTBViewController: UIViewController {
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    var dataArray = [rewardListModel]()
    var dataDic:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.callrewardListApi()
        self.dataArray = [
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "500", descriptin: "Card UBER", title: "Gift #1", image: "1", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "500", descriptin: "Card UBER EATS", title: "Gift #2", image: "2", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "500", descriptin: "Card LYFT", title: "Gift #3", image: "3", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "500", descriptin: "Container Small", title: "Gift #4", image: "4", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "625", descriptin: "Container Medium", title: "Gift #5", image: "5", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "750", descriptin: "Container Large", title: "Gift #6", image: "6", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "800", descriptin: "Black Hat", title: "Gift #7", image: "7", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "800", descriptin: "Grey Hat", title: "Gift #8", image: "8", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "800", descriptin: "Grey/Black Hat", title: "Gift #9", image: "9", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "1300", descriptin: "Black Hoodie", title: "Gift #10", image: "10", inserted_date: ""),
            rewardListModel(user_id: "", user_rewards_id: "", no_of_coins: "1300", descriptin: "White Hoodie", title: "Gift #11", image: "11", inserted_date: "")
        ]
        self.recipeTableView.reloadData()
    }
}

extension RecipesTBViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeNewTableViewCell") as! RecipeNewTableViewCell
        if dataArray.count > 0{
            
            cell.giftLbl.text = "Gift # \(indexPath.row)"
            cell.coinLbl.text = dataArray[indexPath.row].no_of_coins!
            cell.giftImage.image = UIImage(named: self.dataArray[indexPath.row].image)
            cell.subtitleLbl.text = dataArray[indexPath.row].descriptin!
            cell.redeemBtn.tag = indexPath.row
            cell.redeemBtn.addTarget(self, action:#selector(redeemBtn(sender:)), for: .touchUpInside)
            return cell
        } else {
            return cell
        }
    }
    
    @objc func redeemBtn(sender: UIButton) {
        guard let giftCoins = self.dataArray[sender.tag].no_of_coins else { return }
        if let user = CommonHelper.getCachedUserData() {
            if user.user_detail.coins >= self.dataArray[sender.tag].no_of_coins {
                
                if var userCoins = Int(user.user_detail.coins) {
                    if let giftCoinInInt = Int(giftCoins) {
                        userCoins = userCoins - giftCoinInInt
                        user.user_detail.coins = String(userCoins)
                        CommonHelper.saveCachedUserData(user)
                    }
                }
                
                PopupHelper.alertWithOk(title: "Success", message: "Your redeem is successfully completed", controler: self)
            } else {
                PopupHelper.alertWithOk(title: "Fail", message: "Your coins are not enough to purchase this gift", controler: self)
            }
        }
    }
}
//
//extension RecipesTBViewController {
//
//    func callrewardListApi() {
//        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
//            hud.show(in: self.view, animated: true)
//            if Connectivity.isConnectedToNetwork(){
//
//                let v = 42
//
//                self.dataDic = [String:Any]()
//                self.dataDic[Constant.user_id] = "\(v)"
//                self.callWebService(.myrewardlist, hud: hud)
//            }else{
//                hud.textLabel.text = "You are not connected to the internet. Please check your connection"
//                hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                hud.dismiss(afterDelay: 2, animated: true)
//            }
//        }
//    }
//
//    func callredeemApi(rewardId:String) {
//        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
//            hud.show(in: self.view, animated: true)
//            if Connectivity.isConnectedToNetwork(){
//
//                self.dataDic = [String:Any]()
//                self.dataDic[Constant.user_rewards_id] = "\(rewardId)"
//                self.callWebService(.redeemecoins, hud: hud)
//            }else{
//                hud.textLabel.text = "You are not connected to the internet. Please check your connection"
//                hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                hud.dismiss(afterDelay: 2, animated: true)
//            }
//        }
//    }
//}
//
//extension RecipesTBViewController:WebServiceResponseDelegate {
//
//    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
//        let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
//        helper.delegateForWebServiceResponse = self
//        helper.callrewardWebService()
//    }
//    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
//        switch url {
//        case .myrewardlist:
//
//                if let dic = dataDict as? NSDictionary{
//                    if let data = dic[Constant.return_data] as? NSArray{
//                        self.dataArray.removeAll()
//                        for i in data{
//
//                            self.dataArray.append(rewardListModel(dic: i as! NSDictionary)!)
//                        }
//                        self.recipeTableView.reloadData()
//
//                        hud.dismiss()
//                    print("Success")
//                    }
//                }
//                hud.dismiss()
//        case .redeemecoins:
//
//                if let dic = dataDict as? NSDictionary{
//                    if let data = dic[Constant.return_data] as? NSArray{
//                        hud.dismiss()
//                    print("Success")
//                    }
//                    if let msg = dic[Constant.msg] as? String{
//                        CommonHelper.sharedInstance.ShowAlert(view: self, message: msg, Title: "Reward")
//
//                                hud.dismiss()
//                            }
//                }
//                hud.dismiss()
//        default:
//            hud.dismiss()
//        }
//    }
//}
