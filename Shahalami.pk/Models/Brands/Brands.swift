//
//  Brands.swift
//  Shahalami.pk
//
//  Created by Ahmed on 10/01/2022.
//

import Foundation

// MARK: - Brands
struct Brands:Codable {
    var data: [BrandsData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([BrandsData].self, forKey: .data)
    }
}

// MARK: - Datum
struct BrandsData:Codable {
    var title: String?
    var image: String?
    
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case image = "image"
       
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        
    }
}
