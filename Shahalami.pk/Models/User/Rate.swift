//
//  Rate.swift
//  ezfresh.pk
//
//  Created by MAC on 04/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import Foundation

struct Rate : Codable {
    
    var name : String?
    var price : String?
    var min_order_subtotal : String?
    var max_order_subtotal : String?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case price = "price"
        case min_order_subtotal = "min_order_subtotal"
        case max_order_subtotal = "max_order_subtotal"
    }
    
    init(){
        
        name = ""
        price = ""
        min_order_subtotal = ""
        max_order_subtotal = ""
    }
}
