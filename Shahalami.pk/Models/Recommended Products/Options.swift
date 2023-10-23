//  Shahalami.pk
//
//  Created by Ahmed on 16/11/2021.
//


import Foundation
struct Options : Codable {
	let name : String?
	let position : Int?
	let values : [String]?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case position = "position"
		case values = "values"
	}

	init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
		name = try value.decodeIfPresent(String.self, forKey: .name)
		position = try value.decodeIfPresent(Int.self, forKey: .position)
        values = try value.decodeIfPresent([String].self, forKey: .values)
	}

}
