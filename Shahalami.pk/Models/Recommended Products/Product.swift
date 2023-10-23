//  Shahalami.pk
//
//  Created by Ahmed on 16/11/2021.
//


import Foundation
struct Product : Codable {
	let id : Int?
	let title : String?
	let handle : String?
	let description : String?
	let published_at : String?
	let created_at : String?
	let vendor : String?
	let type : String?
	let tags : [String]?
	let price : Int?
	let price_min : Int?
	let price_max : Int?
	let available : Bool?
	let price_varies : Bool?
	let compare_at_price : Int?
	let compare_at_price_min : Int?
	let compare_at_price_max : Int?
	let compare_at_price_varies : Bool?
	let variants : [Variants]?
	let images : [String]?
	//let featured_image : String?
	let options : [Options]?
	let url : String?
	let media : [Media]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case handle = "handle"
		case description = "description"
		case published_at = "published_at"
		case created_at = "created_at"
		case vendor = "vendor"
		case type = "type"
		case tags = "tags"
		case price = "price"
		case price_min = "price_min"
		case price_max = "price_max"
		case available = "available"
		case price_varies = "price_varies"
		case compare_at_price = "compare_at_price"
		case compare_at_price_min = "compare_at_price_min"
		case compare_at_price_max = "compare_at_price_max"
		case compare_at_price_varies = "compare_at_price_varies"
		case variants = "variants"
		case images = "images"
		//case featured_image = "featured_image"
		case options = "options"
		case url = "url"
		case media = "media"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		handle = try values.decodeIfPresent(String.self, forKey: .handle)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		published_at = try values.decodeIfPresent(String.self, forKey: .published_at)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		vendor = try values.decodeIfPresent(String.self, forKey: .vendor)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		tags = try values.decodeIfPresent([String].self, forKey: .tags)
		price = try values.decodeIfPresent(Int.self, forKey: .price)
		price_min = try values.decodeIfPresent(Int.self, forKey: .price_min)
		price_max = try values.decodeIfPresent(Int.self, forKey: .price_max)
		available = try values.decodeIfPresent(Bool.self, forKey: .available)
		price_varies = try values.decodeIfPresent(Bool.self, forKey: .price_varies)
		compare_at_price = try values.decodeIfPresent(Int.self, forKey: .compare_at_price)
		compare_at_price_min = try values.decodeIfPresent(Int.self, forKey: .compare_at_price_min)
		compare_at_price_max = try values.decodeIfPresent(Int.self, forKey: .compare_at_price_max)
		compare_at_price_varies = try values.decodeIfPresent(Bool.self, forKey: .compare_at_price_varies)
		variants = try values.decodeIfPresent([Variants].self, forKey: .variants)
		images = try values.decodeIfPresent([String].self, forKey: .images)
		//featured_image = try values.decodeIfPresent(String.self, forKey: .featured_image)
		options = try values.decodeIfPresent([Options].self, forKey: .options)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		media = try values.decodeIfPresent([Media].self, forKey: .media)
	}

}
