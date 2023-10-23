//
//  UserModel.swift
//  Demo
//
//  Created by MAC on 07/03/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation
let USER_MODEL = "userModel"

struct UserModel : Codable {
    
    var lineItems : [Item]?
    var billingAddress : Address?
    var email : String?
    var userID : Int?
    var checkoutID : String?
    var device : String?
    var prodName : String?
    var currencyCode : String?
    var name : String?
    var last_name:String?
    var phoneNumber : String?
    var state : String?
    var password : String?
    
    enum CodingKeys: String, CodingKey {
        
        case lineItems = "lineItems"
        case billingAddress = "billingAddress"
        case email = "email"
        case userID = "userID"
        case checkoutID = "checkoutID"
        case device = "device"
        case prodName = "prodName"
        case currencyCode = "currencyCode"
        case name = "name"
        case last_name = "last_names"
        case phoneNumber = "phoneNumber"
        case state = "state"
        case password = "password"
    }
    
    init() {
        
        lineItems = [Item()]
        billingAddress = Address()
        email = nil
        userID = nil
        checkoutID = nil
        device = nil
        prodName = nil
        currencyCode = nil
        name = nil
        last_name = nil
        phoneNumber = nil
        state = nil
        password = nil
    }
    
    func saveCurrentSession(forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}
