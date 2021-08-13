//
//  MyAddressModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 10/08/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation

class MyAddressModel: Codable {
    
    var adresss_id:String!
    var zipcode:String!
    var address_main:String!
    var country:String!
    var state:String!
    var city:String!
    var lat:String!
    var lng:String!
    var bydefault:String!
    var user_id:String!
    
    
    init(adresss_id: String? = nil,zipcode:String? = nil,address_main:String? = nil,country:String? = nil,state:String? = nil,city:String? = nil,lat: String? = nil,lng:String? = nil,bydefault:String? = nil,expired_date:String? = nil) {
        
        self.adresss_id = adresss_id
        self.zipcode = zipcode
        self.address_main = address_main
        self.country = country
        self.state = state
        self.city = city
        self.lat = lat
        self.lng = lng
        self.bydefault = bydefault
        
    }
    init?(dic:NSDictionary) {
        
        let adresss_id = (dic as AnyObject).value(forKey: Constant.adresss_id) as? String
        let zipcode = (dic as AnyObject).value(forKey: Constant.zipcode) as! String
        let address_main = (dic as AnyObject).value(forKey: Constant.address_main) as! String
        let country = (dic as AnyObject).value(forKey: Constant.country) as! String
        let state = (dic as AnyObject).value(forKey: Constant.state) as! String
        let city = (dic as AnyObject).value(forKey: Constant.city) as? String
        let lat = (dic as AnyObject).value(forKey: Constant.lat) as? String
        let lng = (dic as AnyObject).value(forKey: Constant.lng) as? String
        let bydefault = (dic as AnyObject).value(forKey: Constant.bydefault) as? String
        
        self.adresss_id = adresss_id
        self.zipcode = zipcode
        self.address_main = address_main
        self.country = country
        self.state = state
        self.city = city
        self.lat = lat
        self.lng = lng
        self.bydefault = bydefault
        
    }
}
