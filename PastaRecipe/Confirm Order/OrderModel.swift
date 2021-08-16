//
//  OrderModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 22/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation

class OrdersModel:Codable{
    
    var user_id:Int64!
    var SubscriptionId:Int64!
    var order_date:String!
    var order_time:String!
    var order_address:String!
    var order_lat:String!
    var order_lng:String!
    var purchasingcoins:String!
    
    
    // STORE AND SUBCATEGORY PENDING
    
    init(user_id: Int64? = nil,SubscriptionId: Int64? = nil,order_date: String? = nil,order_time: String? = nil,order_address: String? = nil,order_lat: String? = nil,purchasingcoins: String? = nil,order_lng: String? = nil) {
        
        self.user_id              = user_id
        self.SubscriptionId  = SubscriptionId
        self.order_date    = order_date
        self.order_time = order_time
        self.order_address = order_address
        self.order_lat  = order_lat
        self.order_lng = order_lng
        self.purchasingcoins = purchasingcoins
        
    }
    init?(dic:NSDictionary) {
        
        let user_id = (dic as AnyObject).value(forKey: Constant.user_id) as? Int64
        let SubscriptionId = (dic as AnyObject).value(forKey: Constant.SubscriptionId) as? Int64
        let order_date = (dic as AnyObject).value(forKey: Constant.order_date) as? String
        let order_time = (dic as AnyObject).value(forKey: Constant.order_time) as? String
        let order_address = (dic as AnyObject).value(forKey: Constant.order_address) as? String
        let order_lat = (dic as AnyObject).value(forKey: Constant.order_lat) as? String
        let order_lng = (dic as AnyObject).value(forKey: Constant.order_lng) as? String
        let purchasingcoins = (dic as AnyObject).value(forKey: Constant.purchasingcoins) as? String
        
        
        self.user_id = user_id
        self.SubscriptionId = SubscriptionId
        self.order_date = order_date
        self.order_time = order_time
        self.order_lat = order_lat
        self.order_lng = order_lng
        self.order_address = order_address
        self.purchasingcoins = purchasingcoins
        
    }
    
}

class RecipeModel:Codable{
    
    var recipe_id:Int64!
    var recipe_name:String!
    var store_id:String!
    var recipe_points:String!
    var recipe_description:String!
    var Date:String!
    var media_file:String!
    var inserted_date:String!
    var liked: Int64!
    var ingredients:IngredientsModel!
    var isAddToCart:Bool!
    
    // STORE AND SUBCATEGORY PENDING
    
    init(recipe_id: Int64? = nil,recipe_name: String? = nil,store_id: String? = nil,recipe_points: String? = nil,recipe_description: String? = nil,Date: String? = nil,inserted_date: String? = nil,media_file: String? = nil,liked: Int64? = nil,ingredients: IngredientsModel? = nil,isAddToCart: Bool? = false) {
        
        self.recipe_id              = recipe_id
        self.recipe_name  = recipe_name
        self.store_id    = store_id
        self.recipe_points = recipe_points
        self.recipe_description = recipe_description
        self.Date  = Date
        self.media_file = media_file
        self.inserted_date = inserted_date
        self.liked = liked
        self.ingredients = ingredients
        self.isAddToCart = isAddToCart
        
    }
    init?(dic:NSDictionary) {
        
        let recipe_id = (dic as AnyObject).value(forKey: Constant.recipe_id) as? Int64
        let recipe_name = (dic as AnyObject).value(forKey: Constant.recipe_name) as? String
        let store_id = (dic as AnyObject).value(forKey: Constant.store_id) as? String
        let recipe_points = (dic as AnyObject).value(forKey: Constant.recipe_points) as? String
        let recipe_description = (dic as AnyObject).value(forKey: Constant.recipe_description) as? String
        let Date = (dic as AnyObject).value(forKey: Constant.Date) as? String
        let media_file = (dic as AnyObject).value(forKey: Constant.media_file) as? String
        let inserted_date = (dic as AnyObject).value(forKey: Constant.inserted_date) as? String
        let liked = (dic as AnyObject).value(forKey: Constant.liked) as? Int64
        
        if let ingredients = (dic as AnyObject).value(forKey: Constant.ingredients) as? NSDictionary{
            self.ingredients = IngredientsModel(dic: ingredients)
        }
        let isAddToCart = (dic as AnyObject).value(forKey: Constant.isAddToCart) as? Bool
        
        self.recipe_id = recipe_id
        self.recipe_name = recipe_name
        self.store_id = store_id
        self.recipe_points = recipe_points
        self.recipe_description = recipe_description
        self.Date = Date
        self.media_file = media_file
        self.inserted_date = inserted_date
        self.liked = liked
        self.isAddToCart = isAddToCart
    }
    
}

class IngredientsModel:Codable{
    
    var name:String!
    var values:String!

    
    // STORE AND SUBCATEGORY PENDING
    
    init(name: String? = nil,values: String? = nil) {
        self.name    = name
        self.values  = values
    }
    
    init?(dic:NSDictionary) {
        
        let name = (dic as AnyObject).value(forKey: Constant.name) as? String
        let values = (dic as AnyObject).value(forKey: Constant.values) as? String

        self.name = name
        self.values = values
        
    }
    
}
