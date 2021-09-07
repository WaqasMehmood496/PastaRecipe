//
//  ViewRecipeDetailViewController.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 16/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import UIKit
import JGProgressHUD

class ViewRecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var ProductTableView: UITableView!
    
    //CONSTANT'S
    let internetConnectionMsg = "You are not connected to the internet. Please check your connection"
    //VARIABLE'S
    var selectedProduct = ProductsModel()
    var dataDic:[String:Any]!
    var review = String()
    var name = String()
    var email = String()
    var reviewtitle = String()
    var rating = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func AddReviewBtnAction(_ sender: Any) {
        if (CommonHelper.getCachedUserData() != nil) {
            self.performSegue(withIdentifier: "toReviewController", sender: nil)
        } else {
            PopupHelper.showAlertControllerWithError(forErrorMessage: "You are not login please login first for giving review on product", forViewController: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddReviewViewController {
            destination.delegate = self
        }
    }
}


//MARK:- HELPING METHOD'S
extension ViewRecipeDetailViewController {
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


//MARK:- DELEGATE METHOD'S
extension ViewRecipeDetailViewController {
    func myReview(review:String,title:String,name:String,email:String,rating:String) {
        self.AddCommentApi(review: review, title: title, name: name, email: email, rating: rating)
        self.review = review
        self.reviewtitle = title
        self.name = name
        self.email = email
        self.rating = rating
    }
}


//MARK:- WEBSERVICE METHOD'S
extension ViewRecipeDetailViewController {
    func AddCommentApi(review:String,title:String,name:String,email:String,rating:String) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            //hud.show(in: self.view, animated: true)
            if Connectivity.isConnectedToNetwork(){
                self.dataDic = [String:Any]()
                if let userId = CommonHelper.getCachedUserData()?.user_detail.user_id {
                    self.dataDic["user_id"] = userId
                } else {
                    self.dataDic["user_id"] = " "
                }
                if let recipeId = self.selectedProduct.recipe_data.recipe_id {
                    self.dataDic["recipe_id"] = recipeId
                } else {
                    self.dataDic["recipe_id"] = " "
                }
                
                self.dataDic["rrate"] = rating
                self.dataDic["rtitle"] = title
                self.dataDic["remail"] = email
                self.dataDic["rname"] = name
                self.dataDic["comments"] = review
                self.callWebService(.postreview, hud: hud)
            } else {
                hud.textLabel.text = self.internetConnectionMsg
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.dismiss(afterDelay: 2, animated: true)
            }
        }
    }
}


//MARK:- UITABLEVIEW DELEGATE AND DATASOURCE METHOD'S
extension ViewRecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "ProductDetail",
                for: indexPath
            ) as! SelectedProductTableViewCell
            if let url = self.selectedProduct.recipe_data.media_file{
                cell.MainImage.sd_setImage(with: URL(string: url), placeholderImage:  #imageLiteral(resourceName: "101"))
            }
            
            cell.TitleLabel.text = self.selectedProduct.recipe_data.recipe_name
            cell.DescriptionLabel.text = self.selectedProduct.recipe_data.recipe_short_description
            cell.PriceLabel.text = "$ " + self.selectedProduct.recipe_data.amount
            cell.AddCartBtn.addTarget(self, action: #selector(AddCartBtnAction(_:)), for: .touchUpInside)
            cell.AddCartBtn.tag = indexPath.row
            if let isAddCart = selectedProduct.isAddToCart {
                if isAddCart {
                    cell.AddCartBtn.backgroundColor = UIColor.black
                    cell.AddCartBtn.setTitleColor(UIColor.white, for: .normal)
                } else {
                    cell.AddCartBtn.backgroundColor = UIColor.clear
                    cell.AddCartBtn.setTitleColor(UIColor.black, for: .normal)
                }
            } else {
                cell.AddCartBtn.backgroundColor = UIColor.clear
                cell.AddCartBtn.setTitleColor(UIColor.black, for: .normal)
            }
            
            let backView = UIView()
            backView.backgroundColor = .clear
            cell.selectedBackgroundView = backView
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "Reviews",
                for: indexPath
            ) as! ReviewsTableViewCell
            cell.ReviewsCollection.delegate = self
            cell.ReviewsCollection.dataSource = self
            cell.ReviewsCollection.tag = indexPath.row
            cell.ReviewsCollection.reloadData()
            return cell
        }
    }
    
    @objc func AddCartBtnAction(_ sender: UIButton) {
        if let isAddCart = selectedProduct.isAddToCart {
            if isAddCart {
                selectedProduct.isAddToCart = false
                sender.backgroundColor = UIColor.clear
                sender.setTitleColor(UIColor.black, for: .normal)
                let index = find(value: selectedProduct.recipe_data.recipe_id, in: cartArray)
                guard let indexValue = index else {
                    return
                }
                cartArray.remove(at: indexValue)
            } else {
                selectedProduct.isAddToCart = true
                sender.backgroundColor = UIColor.black
                sender.setTitleColor(UIColor.white, for: .normal)
                cartArray.append(CartModel(id: self.selectedProduct.recipe_data.recipe_id, image: self.selectedProduct.recipe_data.media_file, title: self.selectedProduct.recipe_data.recipe_name, coins: self.selectedProduct.recipe_data.amount, quantity: "1", price: self.selectedProduct.recipe_data.amount))
            }
        } else {
            selectedProduct.isAddToCart = true
            sender.backgroundColor = UIColor.black
            sender.setTitleColor(UIColor.white, for: .normal)
            cartArray.append(CartModel(id: self.selectedProduct.recipe_data.recipe_id, image: self.selectedProduct.recipe_data.media_file, title: self.selectedProduct.recipe_data.recipe_name, coins: self.selectedProduct.recipe_data.amount, quantity: "1", price: self.selectedProduct.recipe_data.amount))
        }
    }
}



//MARK:- UICOLLECTION VIEW DELEGATE ANS DATASOURCE
extension ViewRecipeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedProduct.reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionCell", for: indexPath) as! ReviewCollectionViewCell
        cell.ReviewUser.text = self.selectedProduct.reviews[indexPath.row].user_name
        cell.ReviewDetail.text = self.selectedProduct.reviews[indexPath.row].comments
        cell.ReviewTitle.text = self.selectedProduct.reviews[indexPath.row].rtitle
        cell.ReviewRating.isUserInteractionEnabled = false
        if let rate = Double(self.selectedProduct.reviews[indexPath.row].rrate) {
            cell.ReviewRating.rating = rate
        } else {
            cell.ReviewRating.rating = 0.0
        }
        return cell
    }
}



//MARK:- WEBSERVICE'S METHOD'S
extension ViewRecipeDetailViewController: WebServiceResponseDelegate {
    
    func callWebService(_ url:webserviceUrl,hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: url, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        switch url {
        case .postreview:
            if let userName = CommonHelper.getCachedUserData()?.user_detail.user_name {
                self.selectedProduct.reviews.append(ReviewsModel(recipe_coments_id: " ", user_id: " ", recipe_id: " ", comments: self.review, inserted_date: " ", rname: self.name, remail: self.email, rtitle: self.reviewtitle, rrate: self.rating, user_name: userName, image_url: " "))
            }
            
            self.ProductTableView.reloadData()
            hud.dismiss()
        default:
            hud.dismiss()
        }
    }
}
