//
//  Address.swift
//  Demo
//
//  Created by MAC on 07/03/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation

struct Address : Codable {
    
    var address1 : String?
    var address2 : String?
    var addressId: Int?
    var city : String?
    var country : String?
    var first_name : String?
    var last_name : String?
    var phone : String?
    var province : String?
    var zip : String?
    var email : String?
    var shipping_rates : [Rate]?
    var latitude : String?
    var longitude : String?
    var isDefault : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case address1 = "address1"
        case address2 = "address2"
        case addressId = "id"
        case city = "city"
        case country = "country"
        case first_name = "first_name"
        case last_name = "last_name"
        case phone = "phone"
        case province = "province"
        case zip = "zip"
        case email = "email"
        case shipping_rates = "shipping_rates"
        case latitude = "latitude"
        case longitude = "longitude"
        case isDefault = "default"
    }
    
    init(){
        
        address1 = ""
        address2 = ""
        addressId = 0
        city = ""
        country = ""
        first_name = ""
        last_name = ""
        phone = ""
        province = ""
        zip = ""
        email = ""
        shipping_rates = [Rate()]
        latitude = ""
        longitude = ""
        isDefault = false
    }
}
