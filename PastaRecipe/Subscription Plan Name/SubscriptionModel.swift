//
//  SubscriptionModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 23/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation

class SubscriptionModel:Codable{
    
    var user_id:Int64!
    var SubscriptionId:Int64!
    var order_date:String!
    var order_time:String!
    var order_address:String!
    var order_lat:String!
    var order_lng:String!
    var purchasingcoins:String!
    
    
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
        self.purchasingcoins = purchasingcoins
        
    }
    
}
