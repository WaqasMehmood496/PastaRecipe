//
//  MyCardModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 11/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation

class MyCardModel: Codable {
    
    var carddetail_id:String!
    var card_number:String!
    var expired_date_c:String!
    var cvc:String!
    var bydefault:String!
    var user_id:String!
    
    
    init(carddetail_id: String? = nil,card_number:String? = nil,expired_date_c:String? = nil,cvc:String? = nil,bydefault:String? = nil,user_id:String? = nil) {
        
        self.carddetail_id = carddetail_id
        self.card_number = card_number
        self.expired_date_c = expired_date_c
        self.cvc = cvc
        self.bydefault = bydefault
        self.user_id = user_id
        
        
    }
    init?(dic:NSDictionary) {
        
        let carddetail_id = (dic as AnyObject).value(forKey: Constant.carddetail_id) as? String
        let card_number = (dic as AnyObject).value(forKey: Constant.card_number) as! String
        let expired_date_c = (dic as AnyObject).value(forKey: Constant.expired_date_c) as! String
        let cvc = (dic as AnyObject).value(forKey: Constant.cvc) as! String
        let bydefault = (dic as AnyObject).value(forKey: Constant.bydefault) as! String
        let user_id = (dic as AnyObject).value(forKey: Constant.user_id) as? String
        
        self.carddetail_id = carddetail_id
        self.card_number = card_number
        self.expired_date_c = expired_date_c
        self.cvc = cvc
        self.bydefault = bydefault
        self.user_id = user_id
        
    }
}
