//
//  ProfileCell.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    // MARK: - IBOutlat
    @IBOutlet weak var lblUsername:UILabel!
    @IBOutlet weak var userimg:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
