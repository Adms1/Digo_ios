//
//  GoldCell.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit

class GoldCell: UITableViewCell {

    // MARK: - IBOutlat
    @IBOutlet weak var lblEMITitle:UILabel!
    @IBOutlet weak var lblEMIPrice:UILabel!
    @IBOutlet weak var imageOfGold:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
