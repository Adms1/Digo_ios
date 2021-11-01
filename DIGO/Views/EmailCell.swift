//
//  EmailCell.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit

class EmailCell: UITableViewCell {

    // MARK: - IBOutlat
    @IBOutlet weak var lblEmail:UILabel!
    @IBOutlet weak var imgEmi:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
