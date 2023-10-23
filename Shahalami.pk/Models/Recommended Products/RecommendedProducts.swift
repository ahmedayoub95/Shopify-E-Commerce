//  Shahalami.pk
//
//  Created by Ahmed on 16/11/2021.
//


import Foundation
struct RecommendedProducts : Decodable {
	let products : [Product]?

	enum CodingKeys: String, CodingKey {

		case products = "products"
	}

	init(from decoder: Decoder) throws {
		let value = try decoder.container(keyedBy: CodingKeys.self)
		products = try value.decodeIfPresent([Product].self, forKey: .products)
	}

}
