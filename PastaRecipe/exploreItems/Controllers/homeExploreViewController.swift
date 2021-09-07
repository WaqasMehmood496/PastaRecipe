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

class homeExploreViewController: UIViewController {
    
    @IBOutlet weak var ProductsTableView: UITableView!
    
    // CONSTANT'S
    let toSubcribeTypeSegue = "toSubcribeType"
    let toProductsSegue = "toProducts"
    let internetConnectionMsg = "You are not connected to the internet. Please check your connection"
    let cellIdentifier = "cell"
    private let spacingIphone:CGFloat = 15.0
    private let spacingIpad:CGFloat = 30.0
    
    // VARIABLE'S
    var selectedIndex = 0
    var dataDic:[String:Any]!
    var productsArray = [ProductsModel]()
    var recentlyAddedArray = [ProductsModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.GetAllPlansApi()
    }
    
    //MARK: ACTION'S
    @IBAction func CartBtnAction(_ sender: Any) {
        let CardVC = storyboard?.instantiateViewController(withIdentifier: "AddToCartViewController") as! AddToCartViewController
        CardVC.isSubscription = false
        self.navigationController?.pushViewController(CardVC, animated: true)
    }
    
    
    // PREPARE FOR SEGUE COMPLETION METHOD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toProductsSegue {
            if let productVC = segue.destination as? ProductsViewController {
                productVC.productsArray = self.productsArray
            }
        }
    }
}



//MARK:- HELPING METHOD'S
extension homeExploreViewController {
    
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
    
    func find(value searchValue: String, in array: [CartModel]) -> Int? {
        for (index, value) in array.enumerated()
        {
            if value.id == searchValue {
                return index
            }
        }
        return nil
    }
}



//MARK:- UITABLEVIEW DELEGATE AND DATASOURCE METHOD'S
extension homeExploreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.recentlyAddedArray.count == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return productsArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "ProductsTableViewCell",
                for: indexPath
            ) as! ProductsTableViewCell
            
            if let url = self.productsArray[indexPath.row].recipe_data.media_file {
                cell.RecipeImage.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
            }
            cell.RecipeName.text = self.productsArray[indexPath.row].recipe_data.recipe_name
            cell.RecipeDetail.text = self.productsArray[indexPath.row].recipe_data.recipe_short_description
            cell.RecipePrice.text = "$ " + self.productsArray[indexPath.row].recipe_data.amount
            cell.AddToCartBtn.tag = indexPath.row
            cell.AddToCartBtn.addTarget(self, action: #selector(addToCartBtnAction(_:)), for: .touchUpInside)
            if self.productsArray[indexPath.row].isAddToCart == true{
                cell.AddToCartBtn.backgroundColor = UIColor(named: "Placeholder Color")
                cell.AddToCartBtn.setTitleColor(UIColor.white, for: .normal)
            } else {
                cell.AddToCartBtn.backgroundColor = UIColor.clear
                cell.AddToCartBtn.setTitleColor(UIColor.black, for: .normal)
            }
            
            let backView = UIView()
            backView.backgroundColor = .clear
            cell.selectedBackgroundView = backView
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "HeaderTableViewCell",
                for: indexPath
            ) as! HeaderTableViewCell
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "RecentlyViewTableViewCell",
                for: indexPath
            ) as! RecentlyViewTableViewCell
            cell.RecentlyViewCollectionVIew.delegate = self
            cell.RecentlyViewCollectionVIew.dataSource = self
            cell.RecentlyViewCollectionVIew.tag = indexPath.row
            cell.RecentlyViewCollectionVIew.reloadData()
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeDetail = storyboard?.instantiateViewController(withIdentifier: "ViewRecipeDetailViewController") as! ViewRecipeDetailViewController
        
        let res = recentlyAddedArray.contains(where: { (item) -> Bool in
            if item.recipe_data.recipe_id == self.productsArray[indexPath.row].recipe_data.recipe_id {
                return true
            } else {
                return false
            }
        })
        
        if res == false {
            self.recentlyAddedArray.append(self.productsArray[indexPath.row])
        }
        
        recipeDetail.selectedProduct = self.productsArray[indexPath.row]
        self.navigationController?.pushViewController(recipeDetail, animated: true)
        self.ProductsTableView.reloadData()
        
    }
    
    @objc func addToCartBtnAction(_ sender:UIButton) {
        if productsArray[sender.tag].isAddToCart == true{
            productsArray[sender.tag].isAddToCart = false
            //REMOVE FROM CART ARRAY
            let index = find(value: productsArray[sender.tag].recipe_data.recipe_id, in: cartArray)
            guard let indexValue = index else {
                return
            }
            cartArray.remove(at: indexValue)
        } else {
            productsArray[sender.tag].isAddToCart = true
            // ADD INTO CART ARRAY
            cartArray.append(CartModel(id: self.productsArray[sender.tag].recipe_data.recipe_id, image: self.productsArray[sender.tag].recipe_data.media_file, title: self.productsArray[sender.tag].recipe_data.recipe_name, coins: self.productsArray[sender.tag].recipe_data.amount, quantity: "1", price: self.productsArray[sender.tag].recipe_data.amount))
        }
        self.ProductsTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }
}


extension homeExploreViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recentlyAddedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentlyAddedCell", for: indexPath) as! recentlyAddedCell
        if let url = self.recentlyAddedArray[indexPath.row].recipe_data.media_file {
            cell.itemImage.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
        }
        cell.nameLabel.text = recentlyAddedArray[indexPath.row].recipe_data.recipe_name
        cell.priceLabel.text = recentlyAddedArray[indexPath.row].recipe_data.amount
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeDetail = storyboard?.instantiateViewController(withIdentifier: "ViewRecipeDetailViewController") as! ViewRecipeDetailViewController
        recipeDetail.selectedProduct = self.recentlyAddedArray[indexPath.row]
        for (_,value) in cartArray.enumerated() {
            if value.id == recentlyAddedArray[indexPath.row].recipe_data.recipe_id {
                recipeDetail.selectedProduct.isAddToCart = true
                break
            }
        }
        self.navigationController?.pushViewController(recipeDetail, animated: true)
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
                productsArray.forEach { (product) in
                    let _ = cartArray.contains(where: { (cartItem) -> Bool in
                        if cartItem.id == product.recipe_data.recipe_id {
                            product.isAddToCart = true
                            return true
                        } else {
                            return false
                        }
                    })
                }
                self.ProductsTableView.reloadData()
            }
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}
