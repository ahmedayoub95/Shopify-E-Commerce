//
//  CartTableViewCell.swift
//  Easy Shopping
//
//  Created by Mazhar on 21/10/2021.
//

import UIKit


class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var btndelete: UIButton!
    //2. create delegate variable
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var minusQuantityBtn: UIButton!
    @IBOutlet weak var addQuantityBtn: UIButton!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        cellView.addShadow(opacity: 0.4, cornerRadius: 6, shadowRadius: 4.0)
        buttonsView.addShadow(opacity: 0, cornerRadius: 10, shadowRadius: 0, borderColor: #colorLiteral(red: 0.1133010462, green: 0.5391116142, blue: 0.7785669565, alpha: 0.8980392157), borderWith: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  
    
}
