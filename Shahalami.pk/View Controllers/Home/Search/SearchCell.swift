//
//  SearchCell.swift
//  Shahalami.pk
//
//  Created by Ahmed on 20/12/2021.
//

import UIKit

class SearchCell: UITableViewCell {

    
    @IBOutlet weak var lblWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
