//  Shahalami.pk
//
//  Created by Ahmed on 16/11/2021.
//

import Foundation
struct Media : Codable {
	let alt : String?
	let id : Int?
	let position : Int?
	let preview_image : Preview_image?
	let aspect_ratio : Double?
	let height : Int?
	let media_type : String?
	let src : String?
	let width : Int?

	enum CodingKeys: String, CodingKey {

		case alt = "alt"
		case id = "id"
		case position = "position"
		case preview_image = "preview_image"
		case aspect_ratio = "aspect_ratio"
		case height = "height"
		case media_type = "media_type"
		case src = "src"
		case width = "width"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		alt = try values.decodeIfPresent(String.self, forKey: .alt)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		position = try values.decodeIfPresent(Int.self, forKey: .position)
		preview_image = try values.decodeIfPresent(Preview_image.self, forKey: .preview_image)
		aspect_ratio = try values.decodeIfPresent(Double.self, forKey: .aspect_ratio)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		media_type = try values.decodeIfPresent(String.self, forKey: .media_type)
		src = try values.decodeIfPresent(String.self, forKey: .src)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
	}

}
