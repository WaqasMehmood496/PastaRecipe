//
//  LoginModel.swift
//  TastyBox
//
//  Created by Adeel on 11/05/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit

class LoginModel: Codable {
    
    var user_id:String!
    var user_name:String!
    var user_email:String!
    var user_password:String!
    var token_id:String!
    var image_url:String!
    var coins:String!
    var plan_id:String!
    var expired_date:String!
    var user_type:String!
    var address_main:String!
    var state:String!
    var address_optional:String!
    var city:String!
    var zipcode:String!
    
    init(user_id: String,user_name:String,user_email:String,user_password:String,token_id:String,image_url:String,coins:String,plan_id:String,expired_date:String,user_type:String,address_main:String,state:String,address_optional:String,city:String,zipcode:String) {
        self.user_id = user_id
        self.user_name = user_name
        self.user_email = user_email
        self.user_password = user_password
        self.token_id = token_id
        self.image_url = image_url
        self.coins = coins
        self.plan_id = plan_id
        self.expired_date = expired_date
        self.user_type = user_type
        
        self.address_main = address_main
        self.state = state
        self.address_optional = address_optional
        self.city = city
        self.zipcode = zipcode
    }
    init?(dic:NSDictionary) {
        
        
        let user_id = (dic as AnyObject).value(forKey: Constant.user_id) as? String
        let user_name = (dic as AnyObject).value(forKey: Constant.user_name) as? String
        let user_email = (dic as AnyObject).value(forKey: Constant.user_email) as? String
        let user_password = (dic as AnyObject).value(forKey: Constant.user_password) as? String
        let token_id = (dic as AnyObject).value(forKey: Constant.token_id) as? String
        let image_url = (dic as AnyObject).value(forKey: Constant.image_url) as? String
        let coins = (dic as AnyObject).value(forKey: Constant.coins) as? String
        let plan_id = (dic as AnyObject).value(forKey: Constant.plan_id) as? String
        let expired_date = (dic as AnyObject).value(forKey: Constant.expired_date) as? String
        let user_type = (dic as AnyObject).value(forKey: Constant.user_type) as? String
        
        let address_main = (dic as AnyObject).value(forKey: Constant.address_main) as? String
        let state = (dic as AnyObject).value(forKey: Constant.state) as? String
        let address_optional = (dic as AnyObject).value(forKey: Constant.address_optional) as? String
        let city = (dic as AnyObject).value(forKey: Constant.city) as? String
        let zipcode = (dic as AnyObject).value(forKey: Constant.zipcode) as? String
        
        self.user_id = user_id
        self.user_name = user_name
        self.user_email = user_email
        self.user_password = user_password
        self.token_id = token_id
        self.image_url = image_url
        self.coins = coins
        self.plan_id = plan_id
        self.expired_date = expired_date
        self.user_type = user_type
        self.address_main = address_main
        self.state = state
        self.address_optional = address_optional
        self.city = city
        self.zipcode = zipcode
        
    }
}
