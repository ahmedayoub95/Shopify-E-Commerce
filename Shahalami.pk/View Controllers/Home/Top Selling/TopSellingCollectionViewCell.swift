//
//  TopSellingCollectionViewCell.swift
//  Easy Shopping
//
//  Created by Ahmed on 26/10/2021.
//

import UIKit
import UIView_Shimmer


class TopSellingCollectionViewCell: UICollectionViewCell,ShimmeringViewProtocol {
    
    
    static let identifier = "topSellingCell"
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var productImages: UIImageView!
    
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var unFavButton: UIButton!

    
    var shimmeringAnimatedItems: [UIView] {
           [
            productImages,
            productNameLbl,
            productPriceLbl
           ]
       }

    
}

