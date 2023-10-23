//
//  Amount_set.swift
//  ezfresh.pk
//
//  Created by MAC on 18/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import Foundation

struct Amount_set : Codable {
    let shop_money : Shop_money?
    let presentment_money : Presentment_money?

    enum CodingKeys: String, CodingKey {

        case shop_money = "shop_money"
        case presentment_money = "presentment_money"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shop_money = try values.decodeIfPresent(Shop_money.self, forKey: .shop_money)
        presentment_money = try values.decodeIfPresent(Presentment_money.self, forKey: .presentment_money)
    }
}
