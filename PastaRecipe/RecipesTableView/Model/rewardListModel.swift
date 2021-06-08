//
//  LoginModel.swift
//  TastyBox
//
//  Created by Adeel on 11/05/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit

class rewardListModel: Codable {
    
    var user_rewards_id:String!
    var user_id:String!
    var no_of_coins:String!
    var descriptin:String!
    var r_status:String!
    var inserted_date:String!
 
    
    
    
    init(user_id: String,user_rewards_id:String,no_of_coins:String,descriptin:String,r_status:String,inserted_date:String) {
        self.user_rewards_id = user_rewards_id
        self.user_id = user_id
        self.no_of_coins = no_of_coins
        self.descriptin = descriptin
        self.r_status = r_status
        self.inserted_date = inserted_date
      

        
    }
    init?(dic:NSDictionary) {
        
        
        let user_id = (dic as AnyObject).value(forKey: Constant.user_id) as? String

        
        let user_rewards_id = (dic as AnyObject).value(forKey: Constant.user_rewards_id) as? String
        let no_of_coins = (dic as AnyObject).value(forKey: Constant.no_of_coins) as? String
        let descriptin = (dic as AnyObject).value(forKey: Constant.descriptin) as? String
        let r_status = (dic as AnyObject).value(forKey: Constant.r_status) as? String
        let inserted_date = (dic as AnyObject).value(forKey: Constant.inserted_date) as? String
   
        
        
        self.user_id = user_id
        self.user_rewards_id = user_rewards_id
        self.no_of_coins = no_of_coins
        self.descriptin = descriptin
        self.r_status = r_status
   
 

     
    }
    
    
}
