//
//  DateDalegate.swift
//  OnSaloon
//
//  Created by Buzzware Tech on 20/04/2021.
//

import Foundation

protocol DateDelegate {
    func orderDateDelegate(date:String)
}

//MARK:- Protocal user when user press subscription button and pop up show which subscription is selected
protocol SubscriptioPopDelegate {
    func subsctiptionChoiceDelegate(type:String)
}
