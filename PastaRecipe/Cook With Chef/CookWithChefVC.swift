//
//  CookWithChefVC.swift
//  PastaRecipe
//
//  Created by Waqas on 08/01/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import JGProgressHUD

class CookWithChefVC: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var ProductsTableView: UITableView!
    
    //CONSTANT'S
    let internetMsg = "You are not connected to the internet. Please check your connection"
    let toCartSegue = "toCart"
    
    //MARK: VARIABLE'S
    var selectedIndex = 0
    var dataDic:[String:Any]!
    var productsArray = [ProductsModel]()
    private let spacingIphone:CGFloat = 15.0
    private let spacingIpad:CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartArray.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllPlansApi()
    }
    
    //MARK: ACTION'S
    @IBAction func CartBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: toCartSegue, sender: nil)
    }
    
    // PREPARE FOR SEGUE COMPLETION METHOD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toCartSegue {
            if let cartVC = segue.destination as? AddToCartViewController {
                cartVC.isSubscription = false
            }
        }
    }
}

//MARK:- HELPING METHOD'S
extension CookWithChefVC {
    
    func getAllPlansApi() {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork(){
                self.dataDic = [String:Any]()
                self.callWebService(.getPlans, hud: hud)
            }else{
                hud.textLabel.text = self.internetMsg
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.dismiss(afterDelay: 2, animated: true)
            }
        }
    }
    
    // This method find item which inserting is already exist or not if exsist then return the index number of cart array
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


//MARK:- WEBSERVICE HELPING METHOD'S
extension CookWithChefVC:WebServiceResponseDelegate{
    
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
                cartArray.removeAll()
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
extension CookWithChefVC: UITableViewDelegate, UITableViewDataSource {
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
        cell.AddToCartBtn.tag = indexPath.row
        cell.AddToCartBtn.addTarget(self, action: #selector(addToCartBtnAction(_:)), for: .touchUpInside)
        if self.productsArray[indexPath.row].isAddToCart == true{
            cell.AddToCartBtn.setImage(UIImage(named: "check"), for: .normal)
            cell.AddToCartBtn.backgroundColor = UIColor.green
        }else{
            cell.AddToCartBtn.setImage(UIImage(systemName: "plus"), for: .normal)
            cell.AddToCartBtn.backgroundColor = UIColor.white
        }
        let backView = UIView()
        backView.backgroundColor = .clear
        cell.selectedBackgroundView = backView
        
        return cell
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
        }else{
            productsArray[sender.tag].isAddToCart = true
            // ADD INTO CART ARRAY
            cartArray.append(CartModel(id: self.productsArray[sender.tag].recipe_data.recipe_id, image: self.productsArray[sender.tag].recipe_data.media_file, title: self.productsArray[sender.tag].recipe_data.recipe_name, coins: self.productsArray[sender.tag].recipe_data.amount, quantity: "1", price: self.productsArray[sender.tag].recipe_data.amount))
        }
        
        self.ProductsTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
    }
}


