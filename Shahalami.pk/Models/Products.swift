//
//  Products.swift
//  Shahalami.pk
//
//  Created by Ahmed on 16/11/2021.
//

import Foundation
import EVReflection
let PRODUCTS = "products"
// MARK: - Products
class Products :EVObject{
    var products: [Pro]?
}

// MARK: - Product
class Pro:EVObject {
    var id: String?
    var title, body_html, vendor, product_type: String?
    var created_at: Date?
    var handle: String?
    var updated_at, published_at: Date?
    var template_suffix, status, published_scope, tags: String?
    var admin_graphql_api_id: String?
    var variants: [Variant]?
    var options: [Option]?
    var images: [ProductImage]?
    var image: Image?
}

// MARK: - Image
class Image:EVObject {
    var id: Int?
    var product_id: String?
    var position: Int?
    var created_at: Date?
    var updated_at: Date?
    var alt: String?
    var width: String?
    var height: String?
    var src: String?
    var variant_ids: [Any?]?
    var admin_graphql_api_id: String?
}


//MARK: - ProductImage

class ProductImage:EVObject{
    var id: Int?
    var product_id: String?
    var position: String? = "0"
    var created_at: Date?
    var updated_at: Date?
    var alt: NSNull?
    var width, height: Int?
    var src: String?
    var variant_ids: [Any?]?
    var admin_graphql_api_id: String?
}

// MARK: - Option
class Option:EVObject {
    var id: String?
    var product_id: String?
    var name: String?
    var position: String?
    var values: [String]?
}

// MARK: - Variant
class Variant:EVObject {
    var id: String?
    var product_id: String?
    var title, price, sku: String?
    var position: String?
    var inventory_policy, compare_at_price, fulfillment_service, inventory_management: String?
    var option1, option2: String?
    var option3: String?
    var created_at, updated_at: Date?
    var taxable: Bool?
    var barcode: NSNull?
    var grams: String?
    var image_id: String?
    var weight: String?
    var weight_unit: String?
    var inventory_item_id, inventory_quantity, old_inventory_quantity: String?
    var requires_shipping: Bool?
    var admin_graphql_api_id: String?
}
