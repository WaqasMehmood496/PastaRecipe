//
//  SubscripeModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 23/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation


class SubscripeModel:Codable{

    var plan_id:String!
    var plan_name:String!
    var no_of_coins:String!
    var amount:String!
    var plan_description:String!
    var created_at:String!
    var updated_at:String!
    var days:String!
    var image_url:String!
    var isAddToCart:Bool!

    init(plan_id: String? = nil,plan_name: String? = nil,no_of_coins: String? = nil,amount: String? = nil,plan_description: String? = nil,created_at: String? = nil,days: String? = nil,updated_at: String? = nil,image_url:String? = nil,isAddToCart: Bool? = false) {

        self.plan_id              = plan_id
        self.plan_name  = plan_name
        self.no_of_coins    = no_of_coins
        self.amount = amount
        self.plan_description = plan_description
        self.created_at  = created_at
        self.updated_at = updated_at
        self.days = days
        self.image_url = image_url
        self.isAddToCart = isAddToCart

    }
    init?(dic:NSDictionary) {

        let plan_id = (dic as AnyObject).value(forKey: Constant.plan_id) as? String
        let plan_name = (dic as AnyObject).value(forKey: Constant.plan_name) as? String
        let no_of_coins = (dic as AnyObject).value(forKey: Constant.no_of_coins) as? String
        let amount = (dic as AnyObject).value(forKey: Constant.amount) as? String
        let plan_description = (dic as AnyObject).value(forKey: Constant.plan_description) as? String
        let created_at = (dic as AnyObject).value(forKey: Constant.created_at) as? String
        let updated_at = (dic as AnyObject).value(forKey: Constant.updated_at) as? String
        let days = (dic as AnyObject).value(forKey: Constant.days) as? String
        let image_url = (dic as AnyObject).value(forKey:Constant.image_url) as? String
        let isAddToCart = (dic as AnyObject).value(forKey: Constant.isAddToCart) as? Bool


        self.plan_id = plan_id
        self.plan_name = plan_name
        self.no_of_coins = no_of_coins
        self.amount = amount
        self.plan_description = plan_description
        self.created_at = created_at
        self.updated_at = updated_at
        self.days = days
        self.image_url = image_url
        self.isAddToCart = isAddToCart

    }

}


class ProductsModel:Codable{
    
    var recipe_data:ProductsDetailModel!
    var images:[ProductsImagesModel]!
    var isAddToCart:Bool!
    
    init(recipe_data: ProductsDetailModel? = nil,images: [ProductsImagesModel]? = nil,isAddToCart: Bool? = false) {
        
        self.recipe_data = recipe_data
        self.images  = images
        self.isAddToCart = isAddToCart
        
    }
    init?(dic:NSDictionary) {
        
        if let recipe_data = (dic as AnyObject).value(forKey: Constant.recipe_data) as? NSDictionary {
            self.recipe_data = ProductsDetailModel(dic: recipe_data)
        }
        
        if let images = (dic as AnyObject).value(forKey: Constant.plan_name) as? [ProductsImagesModel] {
            for image in images{
                self.images.append(image)
            }
        }
        
        let isAddToCart = (dic as AnyObject).value(forKey: Constant.isAddToCart) as? Bool
        
        self.isAddToCart = isAddToCart
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
