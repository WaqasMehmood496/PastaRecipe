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
import JGProgressHUD

class ProductsViewController: UIViewController {
    
    // IBOUTLET'S
    @IBOutlet weak var ProductsTableView: UITableView!
    
    // Constant's
    let toAddCartSegue = "toAddCart"
    let internetConnectionMsg = "You are not connected to the internet. Please check your connection"
    
    // VARIABLE'S
    var selectedIndex = 0
    var isSubscription = false
    var dataDic:[String:Any]!
    var productsArray = [ProductsModel]()
    private let spacingIphone:CGFloat = 15.0
    private let spacingIpad:CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ProductsTableView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: ACTION'S
    @IBAction func CartBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: toAddCartSegue, sender: nil)
    }
    
    deinit {
        cartArray.removeAll()
    }
    
    
    // PREPARE FOR SEGUE COMPLETION METHOD
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toAddCartSegue {
            if let cartVC = segue.destination as? AddToCartViewController {
                cartVC.isSubscription = self.isSubscription
            }
        }
    }
}



//MARK:- HELPING METHOD'S
extension ProductsViewController{
    
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
    
    func find(value searchValue: String, in array: [CartModel]) -> Int? {
        for (index, value) in array.enumerated()
        {
            if value.title == searchValue {
                return index
            }
        }
        
        return nil
    }
}


//MARK:- UITABLEVIEW DELEGATE AND DATASOURCE METHOD'S
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
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
