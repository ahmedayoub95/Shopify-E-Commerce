//
//  AddFavourites.swift
//  Shahalami.pk
//
//  Created by Ahmed on 27/06/2022.
//

import Foundation

//
//{
//    "isSuccessfull": false,
//    "message": "product already exists in wishlist"
//}
struct AddFavourites: Codable{
    var isSuccessfull : Bool?
    let message:String?
    
    
    enum CodingKeys: String, CodingKey {

        case isSuccessfull = "isSuccessfull"
        case message = "product_ids"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccessfull = try values.decodeIfPresent(Bool.self, forKey: .isSuccessfull)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
