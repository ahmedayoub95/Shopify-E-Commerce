/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Shipping_address : Codable {
	let first_name : String?
	let address1 : String?
	let phone : String?
	let city : String?
	let zip : String?
	let province : String?
	let country : String?
	let last_name : String?
	let address2 : String?
	let company : String?
	let latitude : Double?
	let longitude : Double?
	let name : String?
	let country_code : String?
	let province_code : String?

	enum CodingKeys: String, CodingKey {

		case first_name = "first_name"
		case address1 = "address1"
		case phone = "phone"
		case city = "city"
		case zip = "zip"
		case province = "province"
		case country = "country"
		case last_name = "last_name"
		case address2 = "address2"
		case company = "company"
		case latitude = "latitude"
		case longitude = "longitude"
		case name = "name"
		case country_code = "country_code"
		case province_code = "province_code"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		address1 = try values.decodeIfPresent(String.self, forKey: .address1)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		zip = try values.decodeIfPresent(String.self, forKey: .zip)
		province = try values.decodeIfPresent(String.self, forKey: .province)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		address2 = try values.decodeIfPresent(String.self, forKey: .address2)
		company = try values.decodeIfPresent(String.self, forKey: .company)
		latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		country_code = try values.decodeIfPresent(String.self, forKey: .country_code)
		province_code = try values.decodeIfPresent(String.self, forKey: .province_code)
	}

}