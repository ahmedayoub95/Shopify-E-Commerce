//
//  Image.swift
//  Shahalami.pk
//
//  Created by Ahmed on 26/11/2021.
//

import Foundation
import EVReflection
// MARK: - Image
class Banners :EVObject {
    var images: [ImageElement]?

}

// MARK: - ImageElement
class ImageElement : EVObject {
    var id, productID, position: String?
    var createdAt, updatedAt: Date?
    var alt: NSNull?
    var width, height: String?
    var src: String?
    var variantIDS: [Any?]?
    var adminGraphqlAPIID: Int?

}
