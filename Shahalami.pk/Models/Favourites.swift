//
//  Favourites.swift
//  Shahalami.pk
//
//  Created by Ahmed on 07/01/2022.
//

import Foundation


struct Favourites: Codable{
    var isSuccessfull : Bool?
    let product_ids:String?
    
    
    enum CodingKeys: String, CodingKey {

        case isSuccessfull = "isSuccessfull"
        case product_ids = "product_ids"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccessfull = try values.decodeIfPresent(Bool.self, forKey: .isSuccessfull)
        product_ids = try values.decodeIfPresent(String.self, forKey: .product_ids)
    }

}
