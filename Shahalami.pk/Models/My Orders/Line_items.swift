/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Line_items : Codable {
	let id : Int?
	let variant_id : Int?
	let title : String?
	let quantity : Int?
	let sku : String?
	let variant_title : String?
	let vendor : String?
	let fulfillment_service : String?
	let product_id : Int?
	let requires_shipping : Bool?
	let taxable : Bool?
	let gift_card : Bool?
	let name : String?
	let variant_inventory_management : String?
	let properties : [String]?
	let product_exists : Bool?
	let fulfillable_quantity : Int?
	let grams : Int?
	let price : String?
	let total_discount : String?
	let fulfillment_status : String?
	let price_set : Price_set?
	let total_discount_set : Total_discount_set?
	let discount_allocations : [Discount_allocations]?
	let duties : [String]?
	let admin_graphql_api_id : String?
	let tax_lines : [Tax_lines]?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case variant_id = "variant_id"
		case title = "title"
		case quantity = "quantity"
		case sku = "sku"
		case variant_title = "variant_title"
		case vendor = "vendor"
		case fulfillment_service = "fulfillment_service"
		case product_id = "product_id"
		case requires_shipping = "requires_shipping"
		case taxable = "taxable"
		case gift_card = "gift_card"
		case name = "name"
		case variant_inventory_management = "variant_inventory_management"
		case properties = "properties"
		case product_exists = "product_exists"
		case fulfillable_quantity = "fulfillable_quantity"
		case grams = "grams"
		case price = "price"
		case total_discount = "total_discount"
		case fulfillment_status = "fulfillment_status"
		case price_set = "price_set"
		case total_discount_set = "total_discount_set"
		case discount_allocations = "discount_allocations"
		case duties = "duties"
		case admin_graphql_api_id = "admin_graphql_api_id"
		case tax_lines = "tax_lines"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		variant_id = try values.decodeIfPresent(Int.self, forKey: .variant_id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
		sku = try values.decodeIfPresent(String.self, forKey: .sku)
		variant_title = try values.decodeIfPresent(String.self, forKey: .variant_title)
		vendor = try values.decodeIfPresent(String.self, forKey: .vendor)
		fulfillment_service = try values.decodeIfPresent(String.self, forKey: .fulfillment_service)
		product_id = try values.decodeIfPresent(Int.self, forKey: .product_id)
		requires_shipping = try values.decodeIfPresent(Bool.self, forKey: .requires_shipping)
		taxable = try values.decodeIfPresent(Bool.self, forKey: .taxable)
		gift_card = try values.decodeIfPresent(Bool.self, forKey: .gift_card)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		variant_inventory_management = try values.decodeIfPresent(String.self, forKey: .variant_inventory_management)
		properties = try values.decodeIfPresent([String].self, forKey: .properties)
		product_exists = try values.decodeIfPresent(Bool.self, forKey: .product_exists)
		fulfillable_quantity = try values.decodeIfPresent(Int.self, forKey: .fulfillable_quantity)
		grams = try values.decodeIfPresent(Int.self, forKey: .grams)
		price = try values.decodeIfPresent(String.self, forKey: .price)
		total_discount = try values.decodeIfPresent(String.self, forKey: .total_discount)
		fulfillment_status = try values.decodeIfPresent(String.self, forKey: .fulfillment_status)
		price_set = try values.decodeIfPresent(Price_set.self, forKey: .price_set)
		total_discount_set = try values.decodeIfPresent(Total_discount_set.self, forKey: .total_discount_set)
		discount_allocations = try values.decodeIfPresent([Discount_allocations].self, forKey: .discount_allocations)
		duties = try values.decodeIfPresent([String].self, forKey: .duties)
		admin_graphql_api_id = try values.decodeIfPresent(String.self, forKey: .admin_graphql_api_id)
		tax_lines = try values.decodeIfPresent([Tax_lines].self, forKey: .tax_lines)
	}

}
