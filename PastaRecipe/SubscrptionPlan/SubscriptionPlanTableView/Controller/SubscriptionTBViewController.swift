//
//  SubscriptionTBViewController.swift
//  PastaRecipe
//
//  Created by Waqas on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD
import SDWebImage

class SubscriptionTBViewController: UIViewController {
    
    //MARK:IBOUTLET'S
    @IBOutlet weak var subscrptionplanTB: UITableView!
    //MARK: VARIABLE'S
    var dataDic:[String:Any]!
    var plansArray = [SubscripeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.GetAllPlansApi()
    }
    
}

//MARK:- FUNCTION'S
extension SubscriptionTBViewController{
    func GetAllPlansApi() {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork(){
                self.dataDic = [String:Any]()
                self.callWebService(.getPlans, hud: hud)
            }else{
                hud.textLabel.text = "You are not connected to the internet. Please check your connection"
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.dismiss(afterDelay: 2, animated: true)
            }
        }
    }
}

//MARK:- WEBSERVICE METHOD'S
extension SubscriptionTBViewController:WebServiceResponseDelegate{
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .getPlans:
            if let data = dataDict as? NSArray{
                self.plansArray.removeAll()
                for array in data{
                    self.plansArray.append(SubscripeModel(dic: array as! NSDictionary)!)
                }
                self.subscrptionplanTB.reloadData()
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}

//MARK:- UITABLEVIEW DELEGATE AND DATASOURCE
extension SubscriptionTBViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plansArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubsPlanTableViewCell") as! SubsPlanTableViewCell
        cell.planLbl.text = self.plansArray[indexPath.row].plan_name
        cell.TotalCostLbl.text =  "Total $" + self.plansArray[indexPath.row].amount
        cell.subscribeBTn.tag = indexPath.row
        cell.subscribeBTn.addTarget(self, action: #selector(SubscribeBtnAction), for: .touchUpInside)
        if let url = self.plansArray[indexPath.row].image_url{
            cell.PlanImage.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
        }
        return cell
    }
    
    @objc func SubscribeBtnAction(_ sender: UIButton) {
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let payment = storyboard?.instantiateViewController(identifier: "subscrpionplanViewController") as! subscrpionplanViewController
        guard let amount = self.plansArray[indexpath.row].amount else {
            return
        }
        let selectedPlan = OrdersModel(user_id: 1, SubscriptionId: Int64(self.plansArray[indexpath.row].plan_id), order_date: "", order_time: "", order_address: "", order_lat: "", purchasingcoins: amount, order_lng: "")
        payment.selectedSubs = selectedPlan
        self.navigationController?.pushViewController(payment, animated: true)
    }
}
