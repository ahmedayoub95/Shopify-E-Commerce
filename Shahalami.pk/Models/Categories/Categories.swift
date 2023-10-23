//
//  Categories.swift
//  Shahalami.pk
//
//  Created by Ahmed on 29/12/2021.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let categories = try Categories(json)

import Foundation
import EVReflection
// MARK: - Categories
class Categories:EVObject {
    var data: [DataAttributes]?
}

// MARK: - Datum
class DataAttributes:EVObject {
    var id: String?
    var type: String?
    var title: String?
    var attributes: Attributes?
}

// MARK: - DatumAttributes
class Attributes:EVObject {
    var handle: String?
    var body_html: String?
    var published_at: Date?
    var sort_order: String?
    var template_suffix: String?
    var disjunctive: String?
    var published_scope: String?
    var images: [CategoryImage]?
    var child_categories: [ChildCategory]?
    var created_at: String?
    var updated_at: String?
}

// MARK: - ChildCategory
class ChildCategory:EVObject {
    var id: String?
    var type: String?
    var title: String?
    var attributes: ChildCategoryAttributes?

}

// MARK: - ChildCategoryAttributes
class ChildCategoryAttributes:EVObject {
    var handle: String?
    var body_html: String?
    var published_at: Date?
    var sort_order: String?
    var template_suffix: String?
    var disjunctive: String?
    var published_scope: String?
    var images: [CategoryImage]?
}

// MARK: - Image
class CategoryImage:EVObject {
    var alt: NSNull?
    var width: String?
    var height: String?
    var src: String?
    var admin_src: String?
}

