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
    
//    // IBOUTLET'S
//    @IBOutlet weak var exploreCollectionView: UICollectionView!
//    @IBOutlet weak var thumbnailImage: UIImageView!
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
    var plansArray = [SubscripeModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        //self.collectionViewSetup()
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
                productVC.plansArray = self.plansArray
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
    
//    // Setup Collection View
//    func collectionViewSetup() {
//
//        let layout = UICollectionViewFlowLayout()
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            layout.sectionInset = UIEdgeInsets (
//                top: spacingIphone,
//                left: spacingIphone,
//                bottom: spacingIphone,
//                right: spacingIphone
//            )
//            layout.minimumLineSpacing = spacingIphone
//            layout.minimumInteritemSpacing = spacingIphone
//        } else {
//            layout.sectionInset = UIEdgeInsets (
//                top: spacingIpad,
//                left: spacingIpad,
//                bottom: spacingIpad,
//                right: spacingIpad
//            )
//            layout.minimumLineSpacing = spacingIpad
//            layout.minimumInteritemSpacing = spacingIpad
//        }
//        self.exploreCollectionView?.collectionViewLayout = layout
//    }
    
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
extension homeExploreViewController:WebServiceResponseDelegate{
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .getPlans:
            if let data = dataDict as? NSArray{
                plansArray.removeAll()
                for array in data{
                    plansArray.append(SubscripeModel(dic: array as! NSDictionary)!)
                }
                self.ProductsTableView.reloadData()
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}


//MARK:- UITABLEVIEW DELEGATE ANS DATASOURCE METHOD'S
extension homeExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plansArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (
            withIdentifier: "ProductsTableViewCell",
            for: indexPath
        ) as! ProductsTableViewCell
        if let url = self.plansArray[indexPath.row].image_url{
            cell.RecipeImage.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
        }
        //cell.VideIconImg.image = #imageLiteral(resourceName: "imageIcon")
        cell.RecipeName.text = self.plansArray[indexPath.row].plan_name
        cell.RecipeDetail.text = self.plansArray[indexPath.row].plan_description
        cell.RecipePrice.text = "$ " + self.plansArray[indexPath.row].amount
        
        let backView = UIView()
        backView.backgroundColor = .clear
        cell.selectedBackgroundView = backView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeDetail = storyboard?.instantiateViewController(withIdentifier: "ViewRecipeDetailViewController") as! ViewRecipeDetailViewController
        recipeDetail.name = self.plansArray[indexPath.row].plan_name
        recipeDetail.detail = self.plansArray[indexPath.row].plan_description
        recipeDetail.image = self.plansArray[indexPath.row].image_url
        self.navigationController?.pushViewController(recipeDetail, animated: true)
    }
}
