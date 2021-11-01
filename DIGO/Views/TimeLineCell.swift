//
//  TimeLineCell.swift
//  DIGO
//
//  Created by ADMS on 26/10/21.
//

import UIKit

class TimeLineCell: UITableViewCell {

    @IBOutlet weak var vwVertical:UIView!
    @IBOutlet weak var vwSquare:UIView!
    @IBOutlet weak var vwTriangle:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblEmiAmount:UILabel!
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var btnPayNow:UIButton!
    @IBOutlet weak var vwHideSHow:UIView!
    @IBOutlet weak var vwSub:UIView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
