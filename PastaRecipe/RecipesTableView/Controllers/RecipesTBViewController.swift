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
        self.navigationController?.navigationBar.isHidden = true
        
       
        self.callrewardListApi()
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
            cell.subtitleLbl.text = dataArray[indexPath.row].descriptin!
            cell.redeemBtn.tag = indexPath.row
            cell.redeemBtn.addTarget(self, action:#selector(redeemBtn(sender:)), for: .touchUpInside)
            return cell

        }
        else{
            return cell

        }
        
    }
    
    
    @objc func redeemBtn(sender: UIButton){
        
        
        var rewardId = self.dataArray[sender.tag].user_rewards_id!
        
        print(rewardId)
        
        self.callredeemApi(rewardId: rewardId)
    }
    
}

extension RecipesTBViewController{

    
    func callrewardListApi() {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork(){
                
                let v = 42

                self.dataDic = [String:Any]()
                self.dataDic[Constant.user_id] = "\(v)"
                self.callWebService(.myrewardlist, hud: hud)
            }else{
                hud.textLabel.text = "You are not connected to the internet. Please check your connection"
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.dismiss(afterDelay: 2, animated: true)
            }
        }
    }
    
    func callredeemApi(rewardId:String) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork(){
                
                self.dataDic = [String:Any]()
                self.dataDic[Constant.user_rewards_id] = "\(rewardId)"
                self.callWebService(.redeemecoins, hud: hud)
            }else{
                hud.textLabel.text = "You are not connected to the internet. Please check your connection"
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.dismiss(afterDelay: 2, animated: true)
            }
        }
    }

       
            
        
    
    
    
}

extension RecipesTBViewController:WebServiceResponseDelegate{
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callrewardWebService()
    }
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        
        
        case .myrewardlist:
                
                if let dic = dataDict as? NSDictionary{
                    if let data = dic[Constant.return_data] as? NSArray{
                        self.dataArray.removeAll()
                        for i in data{
                            
                            self.dataArray.append(rewardListModel(dic: i as! NSDictionary)!)
                            
                        }
                        
                        self.recipeTableView.reloadData()
                        
                        hud.dismiss()
                    print("Success")
                    }
                }
                hud.dismiss()
            
           
            
        case .redeemecoins:
                
                if let dic = dataDict as? NSDictionary{
                    if let data = dic[Constant.return_data] as? NSArray{
                        //self.dataArray.removeAll()
                        for i in data{
                            
                           // self.dataArray.append(rewardListModel(dic: i as! NSDictionary)!)
                            //self.callrewardListApi()
                            
                        }
                        //self.recipeTableView.reloadData()

                        
                        
                        hud.dismiss()
                    print("Success")
                    }
                    if let msg = dic[Constant.msg] as? String{
                        
                     
                        CommonHelper.sharedInstance.ShowAlert(view: self, message: msg, Title: "Reward")
                                
                                hud.dismiss()
                            }

                    
                }
                hud.dismiss()
            
           
            
        default:
            hud.dismiss()
        }
    }
}
