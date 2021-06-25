//
//  LoginDelegate.swift
//  PastaRecipe
//
//  Created by Buzzware Tech on 21/05/2021.
//  Copyright © 2021 Buzzware. All rights reserved.
//

import Foundation

protocol LoginDelegate {
    func loginSuccessDelegate()
}

protocol PassDataDelegate {
    func passCurrentLocation(data:LocationModel)
}
