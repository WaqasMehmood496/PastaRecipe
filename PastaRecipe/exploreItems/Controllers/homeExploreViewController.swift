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
import NVActivityIndicatorView

class homeExploreViewController: UIViewController,SubscriptioPopDelegate {
    
    // IBOUTLET'S
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var btnSubcrib: UIButton!
    
    // CONSTANT'S
    let toSubcribeTypeSegue = "toSubcribeType"
    let toProductsSegue = "toProducts"
    let internetConnectionMsg = "You are not connected to the internet. Please check your connection"
    let cellIdentifier = "cell"
    
    // VARIABLE'S
    var selectedIndex = 0
    var dataDic:[String:Any]!
    var plansArray = [SubscripeModel]()
    private let spacingIphone:CGFloat = 15.0
    private let spacingIpad:CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.collectionViewSetup()
        self.GetAllPlansApi()
    }
    
    @IBAction func playVideoBtn(_ sender: Any) {
        
    }
    
    @IBAction func subcribeBtnPressed(_ sender:Any){
        self.performSegue(withIdentifier: toSubcribeTypeSegue, sender: nil)
    }
    
    // PREPARE FOR SEGUE COMPLETION METHOD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toSubcribeTypeSegue {
            if let popUp = segue.destination as? SubscriptionPopupViewController {
                popUp.delegate = self
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
    
    // Setup Collection View
    func collectionViewSetup() {
        
        let layout = UICollectionViewFlowLayout()
        if UIDevice.current.userInterfaceIdiom == .phone {
            layout.sectionInset = UIEdgeInsets (
                top: spacingIphone,
                left: spacingIphone,
                bottom: spacingIphone,
                right: spacingIphone
            )
            layout.minimumLineSpacing = spacingIphone
            layout.minimumInteritemSpacing = spacingIphone
        } else {
            layout.sectionInset = UIEdgeInsets (
                top: spacingIpad,
                left: spacingIpad,
                bottom: spacingIpad,
                right: spacingIpad
            )
            layout.minimumLineSpacing = spacingIpad
            layout.minimumInteritemSpacing = spacingIpad
        }
        self.exploreCollectionView?.collectionViewLayout = layout
    }
    
    // SUBSCRIPTION PLAN POPUP SELECTION DELEGATE METHOD
    func subsctiptionChoiceDelegate(type: String) {
        if type == Constant.custom_Pack{
            self.performSegue(withIdentifier: toProductsSegue, sender: nil)
        }else{
            
        }
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
                self.exploreCollectionView.reloadData()
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}

extension homeExploreViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return plansArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell (
            withReuseIdentifier: "cellIdentifier",
            for: indexPath
        ) as! recipeViewcell
        if let url = self.plansArray[indexPath.row].image_url{
            cell.recipeImages.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
        }
        cell.VideIconImg.image = #imageLiteral(resourceName: "imageIcon")
        cell.recipeName.text = self.plansArray[indexPath.row].plan_name
        cell.recipedetails.text = self.plansArray[indexPath.row].plan_description
        cell.recipePrice.text = self.plansArray[indexPath.row].amount
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        selectedIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCellsIphone:CGFloat = 15
        let spacingBetweenCellsIpad:CGFloat = 30
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            let totalSpacing = (2 * self.spacingIphone) + (
                (numberOfItemsPerRow - 1) * spacingBetweenCellsIphone
            ) //Amount of total spacing in a row
            
            if let collection = self.exploreCollectionView {
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width , height: width + spacingBetweenCellsIphone * 2)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else{
            let totalSpacing = (2 * self.spacingIpad) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIpad) //Amount of total spacing in a row
            
            if let collection = self.exploreCollectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width , height: width + spacingBetweenCellsIpad * 2)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
}
