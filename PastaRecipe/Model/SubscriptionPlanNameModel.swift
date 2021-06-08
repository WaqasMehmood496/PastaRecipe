//
//  SubscriptionPlanNameModel.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 07/04/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation

class SubscriptionPlanNameModel:NSObject,NSCoding {
    
    var plan_name:String!
    var plan_description:String!
    
    override init()
    {
        plan_name             = ""
        plan_description                = ""
    }
    init(Data:SubscriptionPlanNameModel)
    {
        plan_name           = Data.plan_name
        plan_description              = Data.plan_description
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let obj         = SubscriptionPlanNameModel()
        obj.plan_name        = aDecoder.decodeObject(forKey: "plan_name") as? String ?? ""
        obj.plan_description           = aDecoder.decodeObject(forKey: "plan_description") as? String ?? ""

        self.init(Data:obj)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.plan_name, forKey: "plan_name")
        aCoder.encode(self.plan_description, forKey: "plan_description")
    }

}
