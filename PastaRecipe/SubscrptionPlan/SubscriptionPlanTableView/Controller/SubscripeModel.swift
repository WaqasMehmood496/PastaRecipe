//
//  SubscripeModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 23/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation


class SubscripeModel:Codable {
    
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
