//
//  ListVCCell.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit

class ListVCCell: UITableViewCell {

    // MARK: - IBOutlat
    @IBOutlet weak var lblViewControllName:UILabel!
    @IBOutlet weak var vwLine:UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
