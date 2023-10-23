//
//  Tax_lines.swift
//  Shahalami.pk
//
//  Created by Ahmed on 31/01/2022.
//

import Foundation

struct Tax_lines : Codable {
    
    let channel_liable : Bool?
    let price : String?
    let rate : Double?
    let price_set : Price_set?
    let title : String?


    enum CodingKeys: String, CodingKey {

        case channel_liable = "channel_liable"
        case price = "price"
        case rate = "rate"
        case price_set = "price_set"
        case title = "title"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        channel_liable = try values.decodeIfPresent(Bool.self, forKey: .channel_liable)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        rate = try values.decodeIfPresent(Double.self, forKey: .rate)
        price_set = try values.decodeIfPresent(Price_set.self, forKey: .price_set)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    
      
    }

}

