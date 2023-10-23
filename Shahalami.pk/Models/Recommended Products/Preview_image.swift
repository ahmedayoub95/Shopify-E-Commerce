//  Shahalami.pk
//
//  Created by Ahmed on 16/11/2021.
//


import Foundation
struct Preview_image : Codable {
	let aspect_ratio : Double?
	let height : Int?
	let width : Int?
	let src : String?

	enum CodingKeys: String, CodingKey {

		case aspect_ratio = "aspect_ratio"
		case height = "height"
		case width = "width"
		case src = "src"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		aspect_ratio = try values.decodeIfPresent(Double.self, forKey: .aspect_ratio)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
		src = try values.decodeIfPresent(String.self, forKey: .src)
	}

}
