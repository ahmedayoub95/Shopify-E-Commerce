//
//  NewArrivalsCollectionViewCell.swift
//  Easy Shopping
//
//  Created by Ahmed on 26/10/2021.
//

import UIKit

class NewArrivalsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var productImages: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var unfavouriteButton: UIButton!
}
