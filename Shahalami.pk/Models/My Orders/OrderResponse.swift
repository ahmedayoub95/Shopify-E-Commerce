//
//  OrderResponse.swift
//  ezfresh.pk
//
//  Created by MAC on 22/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import Foundation
struct OrderResponse : Codable {
    let order : Orders?

    enum CodingKeys: String, CodingKey {

        case order = "order"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        order = try values.decodeIfPresent(Orders.self, forKey: .order)
    }

}
