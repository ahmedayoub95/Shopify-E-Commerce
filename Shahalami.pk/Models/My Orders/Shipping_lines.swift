//
//  Shipping_lines.swift
//  ezfresh.pk
//
//  Created by MAC on 18/09/2020.
//  Copyright © 2020 ExdNow. All rights reserved.
//

import Foundation

struct Shipping_lines : Codable {
    let id : Int?
    let title : String?
    let price : String?
    let code : String?
    let source : String?
    let phone : String?
    let requested_fulfillment_service_id : String?
    let delivery_category : String?
    let discounted_price : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case price = "price"
        case code = "code"
        case source = "source"
        case phone = "phone"
        case requested_fulfillment_service_id = "requested_fulfillment_service_id"
        case delivery_category = "delivery_category"
        case discounted_price = "discounted_price"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        requested_fulfillment_service_id = try values.decodeIfPresent(String.self, forKey: .requested_fulfillment_service_id)
        delivery_category = try values.decodeIfPresent(String.self, forKey: .delivery_category)
        discounted_price = try values.decodeIfPresent(String.self, forKey: .discounted_price)
    }
}
