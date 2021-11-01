//
//  ProductDetailCell.swift
//  DIGO
//
//  Created by ADMS on 25/10/21.
//

import UIKit

class ProductDetailCell: UITableViewCell {

    @IBOutlet weak var lblInstallmentTitle:UILabel!
    @IBOutlet weak var lblInstallmentPrice:UILabel!
    @IBOutlet weak var btnSelectDeselect:UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
