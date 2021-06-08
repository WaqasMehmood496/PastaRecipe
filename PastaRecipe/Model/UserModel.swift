//
//  UserModel.swift
//  PastaRecipe
//
//  Created by Waqas on 14/12/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import Foundation

class UserModel:NSObject,NSCoding{
    
    var image_url = String()
    var user_password = String()
    var user_id = String()
    var status = String()
    var token_id = String()
    var user_name = String()
    var coins = String()
    var user_email = String()
    
    var plan_id = String()
    var expired_date = String()
    var user_type = String()
    
    override init()
    {
        image_url             = ""
        user_password         = ""
        user_id               = ""
        status                = ""
        token_id              = ""
        user_name             = ""
        coins                 = ""
        user_email            = ""
        plan_id               = ""
        expired_date          = ""
        user_type             = ""
    }
    init(Data:UserModel)
    {
        image_url        = Data.image_url
        user_password    = Data.user_password
        user_id          = Data.user_id
        status           = Data.status
        token_id         = Data.token_id
        user_name        = Data.user_name
        coins            = Data.coins
        user_email       = Data.user_email
        plan_id          = Data.plan_id
        expired_date     = Data.expired_date
        user_type        = Data.user_type
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let obj         = UserModel()
        obj.image_url       = aDecoder.decodeObject(forKey: "image_url") as? String ?? ""
        obj.user_password         = aDecoder.decodeObject(forKey: "user_password") as? String ?? ""
        obj.user_id   = aDecoder.decodeObject(forKey: "user_id") as? String ?? ""
        obj.status        = aDecoder.decodeObject(forKey: "status") as? String ?? ""
        obj.token_id     = aDecoder.decodeObject(forKey: "token_id") as? String ?? ""
        obj.user_name        = aDecoder.decodeObject(forKey: "user_name") as? String ?? ""
        obj.coins        = aDecoder.decodeObject(forKey: "coins") as? String ?? ""
        obj.user_email        = aDecoder.decodeObject(forKey: "user_email") as? String ?? ""
        obj.plan_id        = aDecoder.decodeObject(forKey: "plan_id") as? String ?? ""
        obj.expired_date        = aDecoder.decodeObject(forKey: "expired_date") as? String ?? ""
        obj.user_type        = aDecoder.decodeObject(forKey: "user_type") as? String ?? ""

        self.init(Data:obj)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.image_url, forKey: "image_url")
        aCoder.encode(self.user_password, forKey: "user_password")
        aCoder.encode(self.user_id, forKey: "user_id")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.token_id, forKey: "token_id")
        aCoder.encode(self.user_name, forKey: "user_name")
        aCoder.encode(self.coins, forKey: "coins")
        aCoder.encode(self.user_email, forKey: "user_email")
        aCoder.encode(self.plan_id, forKey: "plan_id")
        aCoder.encode(self.expired_date, forKey: "expired_date")
        aCoder.encode(self.user_type, forKey: "user_type")
    }
    
    //MARK: Private Methods
    static func LoadData(key:String) -> UserModel
    {
        if let DataFromCache = UserDefaults.standard.object(forKey: "\(key)_List") as? Data
        {
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: DataFromCache) as! UserModel
            return decodedTeams
        }
        else
        {
            return UserModel()
        }
    }
    static func SaveData(Data:UserModel,key:String)
    {
        // load data for not network time
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: Data)
        userDefaults.set(encodedData, forKey: "\(key)_List")
        userDefaults.synchronize()
    }
}
