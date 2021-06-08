//
//  ProductsViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 04/06/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import NVActivityIndicatorView
import JGProgressHUD

class ProductsViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var ActivityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var ChefRecipeCV: UICollectionView!
    
    //MARK: VARIABLE'S
    var selectedIndex = 0
    var dataDic:[String:Any]!
    var plansArray = [SubscripeModel]()
    private let spacingIphone:CGFloat = 15.0
    private let spacingIpad:CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewSetup()
        cartArray.removeAll()
        self.GetAllPlansApi()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: ACTION'S
    @IBAction func CartBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddCart", sender: nil)
    }
    
    deinit {
        cartArray.removeAll()
    }
}

extension ProductsViewController{
    
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
    
    func find(value searchValue: String, in array: [CartModel]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value.title == searchValue {
                return index
            }
        }
        
        return nil
    }
    
    // Setup Collection View
    func collectionViewSetup() {
        
        let layout = UICollectionViewFlowLayout()
        if UIDevice.current.userInterfaceIdiom == .phone{
            layout.sectionInset = UIEdgeInsets(top: spacingIphone, left: spacingIphone, bottom: spacingIphone, right: spacingIphone)
            layout.minimumLineSpacing = spacingIphone
            layout.minimumInteritemSpacing = spacingIphone
        }
        else{
            layout.sectionInset = UIEdgeInsets(top: spacingIpad, left: spacingIpad, bottom: spacingIpad, right: spacingIpad)
            layout.minimumLineSpacing = spacingIpad
            layout.minimumInteritemSpacing = spacingIpad
        }
        
        self.ChefRecipeCV?.collectionViewLayout = layout
    }
}
extension ProductsViewController:WebServiceResponseDelegate{
    
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
                self.ChefRecipeCV.reloadData()
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}


// MARK:-Collection View Delegate
extension ProductsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return plansArray.count //recipeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! recipeViewcell
        
        if let url = self.plansArray[indexPath.row].image_url{
            cell.recipeImages.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
        }
        cell.recipeName.text = self.plansArray[indexPath.row].plan_name
        cell.recipedetails.text = self.plansArray[indexPath.row].plan_description
        cell.recipePrice.text = self.plansArray[indexPath.row].amount
        cell.AddToCartBtn.addTarget(self, action: #selector(addToCartBtnAction(_:)), for: .touchUpInside)
        cell.AddToCartBtn.tag = indexPath.row
        if self.plansArray[indexPath.row].isAddToCart == true{
            cell.AddToCartBtn.setTitle("ADDED", for: .normal)
        }else{
            cell.AddToCartBtn.setTitle("ADD TO CART", for: .normal)
        }
        
        
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
            let totalSpacing = (2 * self.spacingIphone) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIphone) //Amount of total spacing in a row
            
            if let collection = self.ChefRecipeCV{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width , height: width + spacingBetweenCellsIphone * 2)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else{
            let totalSpacing = (2 * self.spacingIpad) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIpad) //Amount of total spacing in a row
            
            if let collection = self.ChefRecipeCV{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width , height: width + spacingBetweenCellsIpad * 2)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
    @objc func addToCartBtnAction(_ sender:UIButton){
        if self.plansArray[sender.tag].isAddToCart == true{
            
            self.plansArray[sender.tag].isAddToCart = false
            //REMOVE FROM CART ARRAY
            let index = find(value: self.plansArray[sender.tag].plan_name, in: cartArray)
            guard let indexValue = index else {
                return
            }
            cartArray.remove(at: indexValue)
        }else{
            self.plansArray[sender.tag].isAddToCart = true
            // ADD INTO CART ARRAY
            cartArray.append(CartModel(image: self.plansArray[sender.tag].image_url, title: self.plansArray[sender.tag].plan_name, coins: self.plansArray[sender.tag].no_of_coins, quantity: "1", price: self.plansArray[sender.tag].amount))
        }
        self.ChefRecipeCV.reloadItems(at: [IndexPath(row: sender.tag, section: 0)])
    }
}
