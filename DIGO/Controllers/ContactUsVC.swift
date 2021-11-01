//
//  ContactUsVC.swift
//  DIGO
//
//  Created by ADMS on 26/10/21.
//

import UIKit
import SwiftyJSON

class ContactUsVC: UIViewController {

    @IBOutlet weak var btnWhatsappCall:UIButton!
    @IBOutlet weak var btnCall:UIButton!
    @IBOutlet weak var btnEmail:UIButton!
    @IBOutlet weak var lblContactUs:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        lblContactUs.text = NSLocalizedString("Digo_Profile_Contact", comment: "")

        btnWhatsappCall.setTitle("\(NSLocalizedString("Digo_contact_whatsapp", comment: ""))", for: .normal)
        btnEmail.setTitle(NSLocalizedString("Digo_contact_email", comment: ""), for: .normal)
        btnCall.setTitle(NSLocalizedString("Digo_contact_Call", comment: ""), for: .normal)

        btnWhatsappCall.layer.cornerRadius = btnWhatsappCall.layer.frame.height/2.0
        btnWhatsappCall.layer.masksToBounds = true

        btnEmail.layer.cornerRadius = btnEmail.layer.frame.height/2.0
        btnEmail.layer.masksToBounds = true

        btnCall.layer.cornerRadius = btnCall.layer.frame.height/2.0
        btnCall.layer.masksToBounds = true


//        btnWhatsappCall.titleLabel?.lineBreakMode = .byWordWrapping
//        btnWhatsappCall.titleLabel?.textAlignment = .center
//
//        btnCall.titleLabel?.lineBreakMode = .byWordWrapping
//        btnCall.titleLabel?.textAlignment = .center
//
//        btnTextCall.titleLabel?.lineBreakMode = .byWordWrapping
//        btnTextCall.titleLabel?.textAlignment = .center

    }
    @IBAction func btnClick()
    {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func btnClickCall()
    {
//        if let result  = UserDefaults.standard.value(forKey: "isLogin"){
//            if (result as! String == "1")
//            {
//                if let result1  = UserDefaults.standard.value(forKey: "logindata"){
//                    let json = JSON(result1)
////                    params = ["CustomerID":json["CustomerID"].stringValue]
//                }
//            }
//        }

        dialNumber(number: "9639632883")


    }

    @IBAction func btnClickEmail()
    {
        let email = "info@digoshop.in"

        //email = json["Email"].stringValue

        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }

    @IBAction func btnClickWhatsApp()
    {
        let phoneNumber =  "9639632883" // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        }

    }

    func dialNumber(number : String) {

     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
                // add error message here
       }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
