//
//  ProdoctsNewCollectionViewCell.swift
//  Shahalami.pk
//
//  Created by Ahmed on 03/11/2021.
//

import UIKit

class ProdoctsNewCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var cellView: UIView!
       @IBOutlet weak var productIamgeView: UIImageView!
       @IBOutlet weak var productNameLbl: UILabel!
       @IBOutlet weak var productPriceLbl: UILabel!
       @IBOutlet weak var addToCartBtn: UIButton!
    
    @IBOutlet weak var favouriteBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
