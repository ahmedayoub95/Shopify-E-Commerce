//
//  Discount_codes.swift
//  shahalami.pk
//
//  Created by MAC on 18/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import Foundation

struct Discount_codes : Codable {
    let code : String?
    let amount : String?
    let type : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case amount = "amount"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
}
