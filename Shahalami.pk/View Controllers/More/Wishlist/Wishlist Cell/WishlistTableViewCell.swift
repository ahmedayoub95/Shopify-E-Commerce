//
//  WishlistTableViewCell.swift
//  Shahalami.pk
//
//  Created by Ahmed on 23/11/2021.
//

import UIKit

class WishlistTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
//    @IBOutlet weak var skuLbl: UILabel!
//    @IBOutlet weak var variantTitleLbl: UILabel!
    @IBOutlet weak var unFavouriteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
