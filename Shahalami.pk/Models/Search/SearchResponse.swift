//
//  SearchResponse.swift
//  ezfresh.pk
//
//  Created by Mazhar on 02/08/2021.
//  Copyright © 2021 ExdNow. All rights reserved.
//

import Foundation
struct SearchResponse : Codable {

    var resources : Resource?
    enum CodingKeys: String, CodingKey {

        case resources = "resources"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resources = try values.decodeIfPresent(Resource.self, forKey: .resources)
    }


}
struct Resource : Codable {

    var results : Res?
    enum CodingKeys: String, CodingKey {

        case results = "results"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent(Res.self, forKey: .results)
    }
}
struct Res : Codable {

    var products : [SearchProducts]?
    enum CodingKeys: String, CodingKey {

        case  products = "products"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent([SearchProducts].self, forKey: .products)
    }


}
