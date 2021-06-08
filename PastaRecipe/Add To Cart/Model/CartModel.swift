//
//  CartModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 04/06/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation


class CartModel: Codable {
    
    var image:String!
    var title:String!
    var coins:String!
    var quantity:String!
    var price:String!
    
    init(image: String,title:String,coins:String,quantity:String,price:String) {
        self.image = image
        self.title = title
        self.coins = coins
        self.quantity = quantity
        self.price = price
    }
    
    init?(dic:NSDictionary) {
        let image = (dic as AnyObject).value(forKey: Constant.image) as? String
        let title = (dic as AnyObject).value(forKey: Constant.title) as? String
        let coins = (dic as AnyObject).value(forKey: Constant.coins) as? String
        let quantity = (dic as AnyObject).value(forKey: Constant.quantity) as? String
        let price = (dic as AnyObject).value(forKey: Constant.price) as? String
        
        self.image = image
        self.title = title
        self.coins = coins
        self.quantity = quantity
        self.price = price
    }
}
