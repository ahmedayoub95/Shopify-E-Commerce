//
//  Search.swift
//  Shahalami.pk
//
//  Created by Ahmed on 20/12/2021.
//

import Foundation
import EVReflection
// MARK: - Search
class Search:EVObject{
    var resources: Resources?
}

// MARK: - Resources
class Resources:EVObject {
    var results: Results?
}

// MARK: - Results
class Results:EVObject {
    var products: [Poducts]?
}

// MARK: - Product
class Poducts:EVObject {
    var id: String?
    var available: Bool?
    var body: String?
    var compareAtPriceMax: String?
    var compareAtPriceMin: String?
    var handle: String?
    var image: String?
    var price: String?
    var priceMax: String?
    var priceMin: String?
    var tags: [String]?
    var title: String?
    var type: String?
    var url: String?
    var variants: [SearchedPoductsVariant]?
    var vendor: String?
    var featuredImage: FeaturedImage?
}

// MARK: - FeaturedImage
class FeaturedImage:EVObject{
    var alt: String?
    var aspectRatio: Double?
    var height: Int?
    var url: String?
    var width: Int?

}

// MARK: - Variant
class SearchedPoductsVariant:EVObject {
    
    var available: Bool?
    var compare_at_price: String?
    var id: Int?
    var image: String?
    var url: String?
    var title: String?
    var price: String?
    
}

