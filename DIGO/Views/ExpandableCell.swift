//
//  ExpandableCell.swift
//  DIGO
//
//  Created by ADMS on 27/10/21.
//

import UIKit

class ExpandableCell: UITableViewCell {

    @IBOutlet weak var btnExpand:UIButton!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imageExpand:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
