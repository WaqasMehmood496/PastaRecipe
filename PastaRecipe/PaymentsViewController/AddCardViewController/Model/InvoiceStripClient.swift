//
//  InvoiceStripClient.swift
//  TastyBox
//
//  Created by Adeel on 22/06/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import SwiftyJSON
enum Result {
  case success
  case failure(Error)
}
class InvoiceStripClient {
    
    static let shared = InvoiceStripClient()
     
    private init() {
       // private
     }
     
     private lazy var baseURL: URL = {
        guard let url = URL(string: webserviceUrl.stripe_payment.url()) else {
         fatalError("Invalid URL")
       }
       return url
     }()
    func createPayment(with amount: Int, completion: @escaping (Result,String?,String?) -> Void) {
        
        let url = URL(string: webserviceUrl.stripe_payment.url())!
        print(url)
        var params = [String: Any]()
        params = [
            "email":"",
            "name":"",
            "cus_id":"",
            "pm_id":"",
            "amount":amount
        ]
                
        AF.request(url, method: .post, parameters: params)
        .validate(statusCode: 200..<300)
        .responseJSON{ response in
          switch response.result {
          case .success:
            if((response.value) != nil)
            {
                let swiftyJsonVar = JSON(response.value!)
                
                if let jsonDict:Dictionary<String, Any> = swiftyJsonVar.dictionaryObject
                {
                    let key = jsonDict["key"] as? String
                    let id = jsonDict["cus_id"] as? String
                    completion(Result.success,key,id)
                }
                
            }
            
          case .failure(let error):
            completion(Result.failure(error),nil,nil)
          }
      }
    }
}
