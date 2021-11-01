//
//  SuccessVC.swift
//  DIGO
//
//  Created by ADMS on 28/10/21.
//

import UIKit

class SuccessVC: UIViewController {

    @IBOutlet weak var btnClickHome:UIButton!
    @IBOutlet weak var lblText:UILabel!
    @IBOutlet weak var imgSuccess:UIImageView!

    var strSuccess:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        btnClickHome.layer.cornerRadius = btnClickHome.layer.frame.height / 2.0
        btnClickHome.layer.masksToBounds = true

        btnClickHome.setTitle(NSLocalizedString("Digo_home", comment: ""), for: .normal)

        if strSuccess == "failed"
        {
            imgSuccess.image = UIImage(named: "payment_fail_icn.png")
            lblText.text = NSLocalizedString("Digo_Error_Msg", comment: "")
        }else{
            imgSuccess.image = UIImage(named: "payment_success_icn.png")
            lblText.text = NSLocalizedString("Digo_Success_Msg", comment: "")
        }
    }
    @IBAction func btnClickHome(_ sender:UIButton)
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: CoinsVC.self) || controller.isKind(of: BarsVC.self) || controller.isKind(of: ProfileVC.self){
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
