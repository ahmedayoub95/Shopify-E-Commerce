//
//  OrderHistoryTableViewCell.swift
//  Shahalami.pk
//
//  Created by Ahmed on 29/10/2021.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var fullfillmentLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
