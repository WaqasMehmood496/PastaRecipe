//
//  homeExploreViewController.swift
//  PastaRecipe
//
//  Created by Waqas on 21/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD
import Kingfisher
import AVFoundation
import AZTabBar

class homeExploreViewController: UIViewController,SubscriptioPopDelegate {
    
    @IBOutlet weak var ProductsTableView: UITableView!
    @IBOutlet weak var btnSubcrib: UIButton!
    
    // CONSTANT'S
    let toSubcribeTypeSegue = "toSubcribeType"
    let toProductsSegue = "toProducts"
    let internetConnectionMsg = "You are not connected to the internet. Please check your connection"
    let cellIdentifier = "cell"
    private let spacingIphone:CGFloat = 15.0
    private let spacingIpad:CGFloat = 30.0
    
    // VARIABLE'S
    var selectedIndex = 0
    var isSubscription = false
    var dataDic:[String:Any]!
    var productsArray = [ProductsModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetAllPlansApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.GetAllPlansApi()
    }
    
    @IBAction func playVideoBtn(_ sender: Any) {
        
    }
    
    @IBAction func subcribeBtnPressed(_ sender:Any){
        if CommonHelper.getCachedUserData() != nil {
            self.isSubscription = true
            self.performSegue(withIdentifier: toProductsSegue, sender: nil)
        } else {
            self.performSegue(withIdentifier: "toLoginMessage", sender: nil)
        }
        
    }
    @IBAction func OneTumePurchasing(_ sender: Any) {
        if CommonHelper.getCachedUserData() != nil {
            self.isSubscription = false
            self.performSegue(withIdentifier: toProductsSegue, sender: nil)
        } else {
            self.performSegue(withIdentifier: "toLoginMessage", sender: nil)
        }
    }
    
    // PREPARE FOR SEGUE COMPLETION METHOD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toSubcribeTypeSegue {
            if let popUp = segue.destination as? SubscriptionPopupViewController {
                popUp.delegate = self
            }
        } else if segue.identifier == toProductsSegue {
            if let productVC = segue.destination as? ProductsViewController {
                productVC.productsArray = self.productsArray
                productVC.isSubscription = self.isSubscription
            }
        }
    }
}

//MARK:- HELPING METHOD'S
extension homeExploreViewController {
    
    func checkUrlExtension(url:String) -> String {
        let splitImageExtension = url.split(separator: ".")
        let imageExtendion = splitImageExtension.last!
        return String(imageExtendion)
    }
    
    // Getting thambnail from url
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    // SUBSCRIPTION PLAN POPUP SELECTION DELEGATE METHOD
    func subsctiptionChoiceDelegate(type: String) {
        if type == Constant.custom_Pack{
            isSubscription = false
        } else {
            isSubscription = true
        }
        self.performSegue(withIdentifier: toProductsSegue, sender: nil)
    }
    
    func GetAllPlansApi() {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork(){
                self.dataDic = [String:Any]()
                self.callWebService(.getPlans, hud: hud)
            }else{
                hud.textLabel.text = self.internetConnectionMsg
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.dismiss(afterDelay: 2, animated: true)
            }
        }
    }
}

//MARK:- WEBSERVICE'S METHOD'S
extension homeExploreViewController:WebServiceResponseDelegate {
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .getPlans:
            if let dataArray = dataDict as? NSArray{
                productsArray.removeAll()
                for data in dataArray {
                    productsArray.append(ProductsModel(dic: data as! NSDictionary)!)
                }
                self.ProductsTableView.reloadData()
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}


//MARK:- UITABLEVIEW DELEGATE AND DATASOURCE METHOD'S
extension homeExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (
            withIdentifier: "ProductsTableViewCell",
            for: indexPath
        ) as! ProductsTableViewCell
        if let url = self.productsArray[indexPath.row].recipe_data.media_file{
            cell.RecipeImage.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
        }
        cell.RecipeName.text = self.productsArray[indexPath.row].recipe_data.recipe_name
        cell.RecipeDetail.text = self.productsArray[indexPath.row].recipe_data.recipe_short_description
        cell.RecipePrice.text = "$ " + self.productsArray[indexPath.row].recipe_data.amount
        
        let backView = UIView()
        backView.backgroundColor = .clear
        cell.selectedBackgroundView = backView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeDetail = storyboard?.instantiateViewController(withIdentifier: "ViewRecipeDetailViewController") as! ViewRecipeDetailViewController
        recipeDetail.name = self.productsArray[indexPath.row].recipe_data.recipe_name
        recipeDetail.detail = self.productsArray[indexPath.row].recipe_data.recipe_description
        recipeDetail.image = "$ " + self.productsArray[indexPath.row].recipe_data.amount
        self.navigationController?.pushViewController(recipeDetail, animated: true)
    }
}
