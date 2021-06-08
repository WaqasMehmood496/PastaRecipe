//
//  SubscriptionPlanModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 07/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation
class SubscriptionPlanModel:NSObject,NSCoding {
    
    var plan_id:String!
    var plan_name:String!
    var no_of_coins:String!
    var amount:String!
    var plan_description:String!
    var created_at:String!
    var updated_at:String!
    var days:String!

    
    override init()
    {
        plan_id             = ""
        plan_name                = ""
        no_of_coins                    = ""
        amount      = ""
        plan_description           = ""
        created_at           = ""
        updated_at               = ""
        days              = ""

    }
    init(Data:SubscriptionPlanModel)
    {
        plan_id           = Data.plan_id
        plan_name              = Data.plan_name
        no_of_coins                  = Data.no_of_coins
        amount    = Data.amount
        plan_description         = Data.plan_description
        created_at         = Data.created_at
        days             = Data.days
        updated_at           = Data.updated_at
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let obj         = SubscriptionPlanModel()
        obj.plan_id        = aDecoder.decodeObject(forKey: "plan_id") as? String ?? ""
        obj.plan_name           = aDecoder.decodeObject(forKey: "plan_name") as? String ?? ""
        obj.no_of_coins               = aDecoder.decodeObject(forKey: "no_of_coins") as? String ?? ""
        obj.amount = aDecoder.decodeObject(forKey: "amount") as? String ?? ""
        obj.plan_description      = aDecoder.decodeObject(forKey: "plan_description") as? String ?? ""
        obj.created_at      = aDecoder.decodeObject(forKey: "created_at") as? String ?? ""
        obj.updated_at          = aDecoder.decodeObject(forKey: "updated_at") as? String ?? ""
        obj.days         = aDecoder.decodeObject(forKey: "days") as? String ?? ""
        self.init(Data:obj)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.plan_id, forKey: "plan_id")
        aCoder.encode(self.plan_name, forKey: "plan_name")
        aCoder.encode(self.no_of_coins, forKey: "no_of_coins")
        aCoder.encode(self.amount, forKey: "amount")
        aCoder.encode(self.plan_description, forKey: "plan_description")
        aCoder.encode(self.created_at, forKey: "created_at")
        aCoder.encode(self.updated_at, forKey: "updated_at")
        aCoder.encode(self.days, forKey: "days")

    }
    //MARK: Private Methods
    static func LoadData(key:String) -> [SubscriptionPlanModel]
    {
        if let DataFromCache = UserDefaults.standard.object(forKey: "\(key)_List") as? Data
        {
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: DataFromCache) as! [SubscriptionPlanModel]
            return decodedTeams
        }
        else
        {
            return []
        }
    }
    static func SaveData(Data:[SubscriptionPlanModel],key:String)
    {
        // load data for not network time
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: Data)
        userDefaults.set(encodedData, forKey: "\(key)_List")
        userDefaults.synchronize()
    }
}
