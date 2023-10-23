//
//  Discount_allocations.swift
//  ezfresh.pk
//
//  Created by MAC on 18/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import Foundation

struct Discount_allocations : Codable {
    let amount : String?
    let discount_application_index : Int?
    let amount_set : Amount_set?

    enum CodingKeys: String, CodingKey {

        case amount = "amount"
        case discount_application_index = "discount_application_index"
        case amount_set = "amount_set"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        discount_application_index = try values.decodeIfPresent(Int.self, forKey: .discount_application_index)
        amount_set = try values.decodeIfPresent(Amount_set.self, forKey: .amount_set)
    }
}
