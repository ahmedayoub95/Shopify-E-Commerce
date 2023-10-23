//
//  Item.swift
//  Demo
//
//  Created by MAC on 07/03/2019.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation

struct Item : Codable {
    var id : Int?
    var variant_id : Int?
    var quantity : Int?
    var title : String?
    var price : Double?
    var size : String?
    var image : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case variant_id = "variant_id"
        case quantity = "quantity"
        case title = "title"
        case price = "price"
        case size = "size"
        case image = "image"
    }
    
    init(){
        id = 0
        variant_id = 0
        quantity = 0
        title = ""
        price = 0
        size = ""
        image = ""
    }
}
