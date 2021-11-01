//
//  ProductCell.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit

class ProductCell: UITableViewCell {

    // MARK: - IBOutlat
    @IBOutlet weak var lblHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var vwHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var lblEMITitle:UILabel!
    @IBOutlet weak var lblEMIPrice:UILabel!
    @IBOutlet weak var imageOfGold:UIImageView!
    @IBOutlet weak var lblProductTitle:UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
