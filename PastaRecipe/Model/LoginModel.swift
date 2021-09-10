//
//  LoginModel.swift
//  TastyBox
//
//  Created by Adeel on 11/05/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit

class LoginModel: Codable {
    
    var user_detail:UserDetailModel!
    var more_detail:MoreDetailModel!
    
    init(user_detail: UserDetailModel? = nil,more_detail:MoreDetailModel? = nil) {
        
        self.user_detail = user_detail
        self.more_detail = more_detail
        
    }
    init?(dic:NSDictionary) {
        
        
        if let user_detail = (dic as AnyObject).value(forKey: Constant.user_detail) as? NSDictionary{
            self.user_detail = UserDetailModel(dic: user_detail)
        }
        
        if let more_detail = (dic as AnyObject).value(forKey: Constant.more_detail) as? NSDictionary{
            self.more_detail = MoreDetailModel(dic: more_detail)
        }
    }
}

class UserDetailModel: Codable {
    
    var user_id:String!
    var user_name:String!
    var user_email:String!
    var user_password:String!
    var token_id:String!
    var status:String!
    var image_url:String!
    var coins:String!
    var plan_id:String!
    var expired_date:String!
    var user_type:String!
    var verified_status:String!
    var phone_number:String!
    
    init(user_id: String? = nil,user_name:String? = nil,user_email:String? = nil,user_password:String? = nil,token_id:String? = nil,status:String? = nil,image_url: String? = nil,coins:String? = nil,plan_id:String? = nil,expired_date:String? = nil,user_type:String? = nil,verified_status:String? = nil,phone_number:String? = nil,billing_address:String? = nil) {
        
        self.user_id = user_id
        self.user_name = user_name
        self.user_email = user_email
        self.user_password = user_password
        self.token_id = token_id
        self.status = status
        self.image_url = image_url
        self.coins = coins
        self.plan_id = plan_id
        self.user_type = user_type
        self.verified_status = verified_status
        self.phone_number = phone_number
        
    }
    init?(dic:NSDictionary) {
        
        
        let user_id = (dic as AnyObject).value(forKey: Constant.user_id) as? String
        let user_name = (dic as AnyObject).value(forKey: Constant.user_name) as! String
        let user_email = (dic as AnyObject).value(forKey: Constant.user_email) as! String
        let user_password = (dic as AnyObject).value(forKey: Constant.user_password) as! String
        let token_id = (dic as AnyObject).value(forKey: Constant.token_id) as! String
        let status = (dic as AnyObject).value(forKey: Constant.status) as? String
        let image_url = (dic as AnyObject).value(forKey: Constant.image_url) as? String
        let coins = (dic as AnyObject).value(forKey: Constant.coins) as? String
        let plan_id = (dic as AnyObject).value(forKey: Constant.plan_id) as? String
        let user_type = (dic as AnyObject).value(forKey: Constant.user_type) as? String
        let verified_status = (dic as AnyObject).value(forKey: Constant.verified_status) as? String
        let phone_number = (dic as AnyObject).value(forKey: Constant.phone_number) as? String
        
        self.user_id = user_id
        self.user_name = user_name
        self.user_email = user_email
        self.user_password = user_password
        self.token_id = token_id
        self.status = status
        self.image_url = image_url
        self.coins = coins
        self.plan_id = plan_id
        self.user_type = user_type
        self.verified_status = verified_status
        self.phone_number = phone_number
        
    }
}

class MoreDetailModel: Codable {
    
    var address:AddressModel!
    var card:CardModel!
    
    init(address: AddressModel? = nil,billingAddress: AddressModel? = nil,card:CardModel? = nil) {
        self.address = address
        self.card = card
    }
    
    init?(dic:NSDictionary) {
        
        if let address = (dic as AnyObject).value(forKey: Constant.address) as? NSDictionary{
            self.address = AddressModel(dic: address)
        }
        if let card = (dic as AnyObject).value(forKey: Constant.card) as? NSDictionary{
            self.card = CardModel(dic: card)
        }
    }
}

class AddressModel: Codable {
    
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
    var type:String!
    var bzipcode:String!
    var baddress_main:String!
    var bcountry:String!
    var bstate:String!
    var bcity:String!
    var blat:String!
    var blng:String!
    
    init(adresss_id: String? = nil,zipcode:String? = nil,address_main:String? = nil,country:String? = nil,state:String? = nil,city:String? = nil,lat: String? = nil,lng:String? = nil,bydefault:String? = nil,user_id:String? = nil,type:String? = nil,bzipcode:String? = nil,baddress_main:String? = nil,bcountry:String? = nil,bstate: String? = nil,bcity:String? = nil,blat:String? = nil,blng:String? = nil) {
        
        self.adresss_id = adresss_id
        self.zipcode = zipcode
        self.address_main = address_main
        self.country = country
        self.state = state
        self.city = city
        self.lat = lat
        self.lng = lng
        self.bydefault = bydefault
        self.user_id = user_id
        self.type = type
        self.bzipcode = bzipcode
        self.baddress_main = baddress_main
        self.bcountry = bcountry
        self.bstate = bstate
        self.bcity = bcity
        self.blat = blat
        self.blng = blng
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
        let user_id = (dic as AnyObject).value(forKey: Constant.user_id) as? String
        let type = (dic as AnyObject).value(forKey: Constant.type) as! String
        let bzipcode = (dic as AnyObject).value(forKey: Constant.bzipcode) as! String
        let baddress_main = (dic as AnyObject).value(forKey: Constant.baddress_main) as! String
        let bcountry = (dic as AnyObject).value(forKey: Constant.bcountry) as? String
        let bstate = (dic as AnyObject).value(forKey: Constant.bstate) as? String
        let bcity = (dic as AnyObject).value(forKey: Constant.bcity) as? String
        let blat = (dic as AnyObject).value(forKey: Constant.blat) as? String
        let blng = (dic as AnyObject).value(forKey: Constant.blng) as? String
        
        self.adresss_id = adresss_id
        self.zipcode = zipcode
        self.address_main = address_main
        self.country = country
        self.state = state
        self.city = city
        self.lat = lat
        self.lng = lng
        self.bydefault = bydefault
        self.user_id = user_id
        self.type = type
        self.bzipcode = bzipcode
        self.baddress_main = baddress_main
        self.bcountry = bcountry
        self.bstate = bstate
        self.bcity = bcity
        self.blat = blat
        self.blng = blng
        
        
    }
}

class CardModel: Codable {
    
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
