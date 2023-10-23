/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SearchProducts : Codable {
	let available : Bool?
	let body : String?
	let compare_at_price_max : String?
	let compare_at_price_min : String?
	let handle : String?
	let id : Int?
	let image : String?
	let price : String?
	let price_max : String?
	let price_min : String?
	let tags : [String]?
	let title : String?
	let type : String?
	let url : String?
	let variants : [SearchVariants]?
	let vendor : String?
	let featured_image : SearchFeatured_image?

	enum CodingKeys: String, CodingKey {

		case available = "available"
		case body = "body"
		case compare_at_price_max = "compare_at_price_max"
		case compare_at_price_min = "compare_at_price_min"
		case handle = "handle"
		case id = "id"
		case image = "image"
		case price = "price"
		case price_max = "price_max"
		case price_min = "price_min"
		case tags = "tags"
		case title = "title"
		case type = "type"
		case url = "url"
		case variants = "variants"
		case vendor = "vendor"
		case featured_image = "featured_image"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		available = try values.decodeIfPresent(Bool.self, forKey: .available)
		body = try values.decodeIfPresent(String.self, forKey: .body)
		compare_at_price_max = try values.decodeIfPresent(String.self, forKey: .compare_at_price_max)
		compare_at_price_min = try values.decodeIfPresent(String.self, forKey: .compare_at_price_min)
		handle = try values.decodeIfPresent(String.self, forKey: .handle)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		price = try values.decodeIfPresent(String.self, forKey: .price)
		price_max = try values.decodeIfPresent(String.self, forKey: .price_max)
		price_min = try values.decodeIfPresent(String.self, forKey: .price_min)
		tags = try values.decodeIfPresent([String].self, forKey: .tags)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		variants = try values.decodeIfPresent([SearchVariants].self, forKey: .variants)
		vendor = try values.decodeIfPresent(String.self, forKey: .vendor)
		featured_image = try values.decodeIfPresent(SearchFeatured_image.self, forKey: .featured_image)
	}

}
