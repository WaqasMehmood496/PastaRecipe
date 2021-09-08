//
//  ProductModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 06/09/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation


class ProductsModel:Codable {
    
    var recipe_data:ProductsDetailModel!
    var images:[ProductsImagesModel]!
    var isAddToCart:Bool!
    var reviews:[ReviewsModel]!
    var review_status:Bool!
    
    init(recipe_data: ProductsDetailModel? = nil,images: [ProductsImagesModel]? = nil,isAddToCart: Bool? = false,reviews: [ReviewsModel]? = nil) {
        
        self.recipe_data = recipe_data
        self.images  = images
        self.isAddToCart = isAddToCart
        self.reviews = reviews
        
    }
    init?(dic:NSDictionary) {
        
        if let recipe_data = (dic as AnyObject).value(forKey: Constant.recipe_data) as? NSDictionary {
            self.recipe_data = ProductsDetailModel(dic: recipe_data)
        }
        
        if let images = (dic as AnyObject).value(forKey: Constant.images) as? NSArray {
            var array = [ProductsImagesModel]()
            for image in images{
                let tempObj = ProductsImagesModel(dic: image as! NSDictionary)
                if let fetchedImage = tempObj {
                    array.append(fetchedImage)
                }
            }
            self.images = array
        }
        
        if let reviews = (dic as AnyObject).value(forKey: Constant.reviews) as? NSArray {
            var tempreviews = [ReviewsModel]()
            for review in reviews{
                let reviewObj = ReviewsModel(dic: review as! NSDictionary)
                if let fetchedReview = reviewObj {
                    tempreviews.append(fetchedReview)
                }
            }
            self.reviews = tempreviews
        }
        
        let isAddToCart = (dic as AnyObject).value(forKey: Constant.isAddToCart) as? Bool
        let review_status = (dic as AnyObject).value(forKey: Constant.review_status) as? Bool
        
        self.isAddToCart = isAddToCart
        self.review_status = review_status
    }
}

class ProductsDetailModel:Codable {
    
    var recipe_id:String!
    var recipe_name:String!
    var store_id:String!
    var recipe_points:String!
    var recipe_description:String!
    var media_file:String!
    var Date:String!
    var inserted_date:String!
    var status:String!
    var amount:String!
    var recipe_short_description:String!
    
    init(recipe_id: String? = nil,recipe_name: String? = nil,store_id: String? = nil,amount: String? = nil,recipe_points: String? = nil,recipe_description: String? = nil,Date: String? = nil,media_file: String? = nil,inserted_date:String? = nil,status: String? = nil,recipe_short_description: String? = nil) {
        
        self.recipe_id              = recipe_id
        self.recipe_name  = recipe_name
        self.store_id    = store_id
        self.recipe_points = recipe_points
        self.recipe_description  = recipe_description
        self.media_file = media_file
        self.Date = Date
        self.inserted_date = inserted_date
        self.status = status
        self.amount = amount
        self.recipe_short_description = recipe_short_description
        
    }
    init?(dic:NSDictionary) {
        
        let recipe_id = (dic as AnyObject).value(forKey: Constant.recipe_id) as? String
        let recipe_name = (dic as AnyObject).value(forKey: Constant.recipe_name) as? String
        let store_id = (dic as AnyObject).value(forKey: Constant.store_id) as? String
        let recipe_points = (dic as AnyObject).value(forKey: Constant.recipe_points) as? String
        let recipe_description = (dic as AnyObject).value(forKey: Constant.recipe_description) as? String
        let media_file = (dic as AnyObject).value(forKey: Constant.media_file) as? String
        let Date = (dic as AnyObject).value(forKey: Constant.Date) as? String
        let inserted_date = (dic as AnyObject).value(forKey: Constant.inserted_date) as? String
        let status = (dic as AnyObject).value(forKey:Constant.status) as? String
        let amount = (dic as AnyObject).value(forKey:Constant.amount) as? String
        let recipe_short_description = (dic as AnyObject).value(forKey:Constant.recipe_short_description) as? String
        
        
        self.recipe_id = recipe_id
        self.recipe_name = recipe_name
        self.store_id = store_id
        self.recipe_points = recipe_points
        self.recipe_description = recipe_description
        self.media_file = media_file
        self.Date = Date
        self.inserted_date = inserted_date
        self.status = status
        self.amount = amount
        self.recipe_short_description = recipe_short_description
        
    }
    
}

class ProductsImagesModel:Codable {
    
    var uploadimages_id:String!
    var media_file:String!
    var recipe_id:String!
    
    init(uploadimages_id: String? = nil,media_file: String? = nil,recipe_id: String? = nil) {
        
        self.uploadimages_id = uploadimages_id
        self.media_file = media_file
        self.recipe_id = recipe_id
        
    }
    init?(dic:NSDictionary) {
        
        let uploadimages_id = (dic as AnyObject).value(forKey: Constant.uploadimages_id) as? String
        let media_file = (dic as AnyObject).value(forKey: Constant.media_file) as? String
        let recipe_id = (dic as AnyObject).value(forKey: Constant.recipe_id) as? String
        
        self.uploadimages_id = uploadimages_id
        self.media_file = media_file
        self.recipe_id = recipe_id
    }
}

class ReviewsModel:Codable {
    
    var recipe_coments_id:String!
    var user_id:String!
    var recipe_id:String!
    var comments:String!
    var inserted_date:String!
    var rname:String!
    var remail:String!
    var rtitle:String!
    var rrate:String!
    var user_name:String!
    var image_url:String!
    
    init(recipe_coments_id: String? = nil,user_id: String? = nil,recipe_id: String? = nil,comments: String? = nil,inserted_date: String? = nil,rname: String? = nil,remail: String? = nil,rtitle: String? = nil,rrate: String? = nil,user_name: String? = nil,image_url: String? = nil) {
        
        self.recipe_coments_id = recipe_coments_id
        self.user_id = user_id
        self.recipe_id = recipe_id
        self.comments = comments
        self.inserted_date = inserted_date
        self.rname = rname
        self.remail = remail
        self.rtitle = rtitle
        self.rrate = rrate
        self.user_name = user_name
        self.image_url = image_url
        
    }
    init?(dic:NSDictionary) {
        
        let recipe_coments_id = (dic as AnyObject).value(forKey: Constant.recipe_coments_id) as? String
        let user_id = (dic as AnyObject).value(forKey: Constant.user_id) as? String
        let recipe_id = (dic as AnyObject).value(forKey: Constant.recipe_id) as? String
        let comments = (dic as AnyObject).value(forKey: Constant.comments) as? String
        let inserted_date = (dic as AnyObject).value(forKey: Constant.inserted_date) as? String
        let rname = (dic as AnyObject).value(forKey: Constant.rname) as? String
        let remail = (dic as AnyObject).value(forKey: Constant.remail) as? String
        let rtitle = (dic as AnyObject).value(forKey: Constant.rtitle) as? String
        let rrate = (dic as AnyObject).value(forKey: Constant.rrate) as? String
        let user_name = (dic as AnyObject).value(forKey: Constant.user_name) as? String
        let image_url = (dic as AnyObject).value(forKey: Constant.image_url) as? String
        
        self.recipe_coments_id = recipe_coments_id
        self.user_id = user_id
        self.recipe_id = recipe_id
        self.comments = comments
        self.inserted_date = inserted_date
        self.rname = rname
        self.remail = remail
        self.rtitle = rtitle
        self.rrate = rrate
        self.user_name = user_name
        self.image_url = image_url
        
    }
}
