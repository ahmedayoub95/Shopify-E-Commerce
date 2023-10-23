//
//  RelatedProductsCollectionViewCell.swift
//  Easy Shopping
//
//  Created by Ahmed on 22/10/2021.
//

import UIKit

class RelatedProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var favouriteBtn: UIButton!
}
