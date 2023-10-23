//  Shahalami.pk
//
//  Created by Ahmed on 16/11/2021.
//


import Foundation
struct Variants : Codable {
	let id : Int?
	let title : String?
	let option1 : String?
	let option2 : String?
	let option3 : String?
	let sku : String?
	let requires_shipping : Bool?
	let taxable : Bool?
	//let featured_image : String?
	let available : Bool?
	let name : String?
	let public_title : String?
	let options : [String]?
	let price : Int?
	let weight : Int?
	let compare_at_price : Int?
	let inventory_management : String?
	let barcode : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case option1 = "option1"
		case option2 = "option2"
		case option3 = "option3"
		case sku = "sku"
		case requires_shipping = "requires_shipping"
		case taxable = "taxable"
		//case featured_image = "featured_image"
		case available = "available"
		case name = "name"
		case public_title = "public_title"
		case options = "options"
		case price = "price"
		case weight = "weight"
		case compare_at_price = "compare_at_price"
		case inventory_management = "inventory_management"
		case barcode = "barcode"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		option1 = try values.decodeIfPresent(String.self, forKey: .option1)
		option2 = try values.decodeIfPresent(String.self, forKey: .option2)
		option3 = try values.decodeIfPresent(String.self, forKey: .option3)
		sku = try values.decodeIfPresent(String.self, forKey: .sku)
		requires_shipping = try values.decodeIfPresent(Bool.self, forKey: .requires_shipping)
		taxable = try values.decodeIfPresent(Bool.self, forKey: .taxable)
	//	featured_image = try values.decodeIfPresent(String.self, forKey: .featured_image)
		available = try values.decodeIfPresent(Bool.self, forKey: .available)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		public_title = try values.decodeIfPresent(String.self, forKey: .public_title)
		options = try values.decodeIfPresent([String].self, forKey: .options)
		price = try values.decodeIfPresent(Int.self, forKey: .price)
		weight = try values.decodeIfPresent(Int.self, forKey: .weight)
		compare_at_price = try values.decodeIfPresent(Int.self, forKey: .compare_at_price)
		inventory_management = try values.decodeIfPresent(String.self, forKey: .inventory_management)
		barcode = try values.decodeIfPresent(String.self, forKey: .barcode)
	}

}
