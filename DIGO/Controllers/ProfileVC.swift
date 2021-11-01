//
//  ProfileVC.swift
//  DIGO
//
//  Created by ADMS on 21/10/21.
//

import UIKit
import SwiftyJSON

class ProfileVC: UIViewController {

    // MARK: - IBOutlat
    @IBOutlet weak var tblProfile:UITableView!

    let arrVCList = ["1","2",NSLocalizedString("Digo_Profile_Change_Language", comment: ""),NSLocalizedString("Digo_order", comment: ""),NSLocalizedString("Digo_Profile_Contact", comment: ""),NSLocalizedString("Digo_Profile_Sign", comment: ""),NSLocalizedString("Digo_Profile_Refer", comment: "")]

    //NSLocalizedString("Digo_Profile_Cancel_EMI", comment: "")

//,NSLocalizedString("Digo_Profile_Pay_EMI", comment: ""),NSLocalizedString("Digo_Profile_Switch_Account", comment: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        tblProfile.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tblProfile.register(UINib(nibName: "EmailCell", bundle: nil), forCellReuseIdentifier: "EmailCell")
        tblProfile.register(UINib(nibName: "ListVCCell", bundle: nil), forCellReuseIdentifier: "ListVCCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
}
// MARK: - extension

extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVCList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.userimg.layer.cornerRadius = cell.userimg.layer.frame.height/2.0
            cell.userimg.layer.masksToBounds = true
            if let result  = UserDefaults.standard.value(forKey: "isLogin"){
                if (result as! String == "1")
                {
                    if let result1  = UserDefaults.standard.value(forKey: "logindata"){
                        let json = JSON(result1)
                        cell.lblUsername.text = "\(json["FirstName"].stringValue)"
                        if let userPic = UserDefaults.standard.value(forKey: "ProfilePhoto") {
                            cell.userimg.sd_setImage(with: URL(string:userPic as! String), placeholderImage: UIImage(named: "placeholder"))
                        }

                    }
                }
            }
            return cell
        }else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath) as! EmailCell
            cell.lblEmail.text = "\(NSLocalizedString("Digo_Plan", comment: ""))"
            cell.imgEmi.layer.cornerRadius = cell.imgEmi.layer.frame.height/2.0
            cell.imgEmi.layer.masksToBounds = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListVCCell", for: indexPath) as! ListVCCell
            cell.lblViewControllName.text = arrVCList[indexPath.row]

            if indexPath.row == arrVCList.count-1
            {
                cell.vwLine.isHidden = true
            }else{
                cell.vwLine.isHidden = false
            }

            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrVCList[indexPath.row] == NSLocalizedString("Digo_Profile_Sign", comment: "")
        {
            let alert = UIAlertController(title: NSLocalizedString("Digo_Sign_Up", comment: ""), message: NSLocalizedString("Digo_alet_meg", comment: ""), preferredStyle: .alert)
            // create the alert

            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Digo_Ok", comment: ""), style: .default, handler: {_ in

                self.tabBarController?.tabBar.isHidden = true
                UserDefaults.standard.set("0", forKey: "isLogin")
                let prefs = UserDefaults.standard
                prefs.removeObject(forKey:"isLogin")
                prefs.removeObject(forKey:"logindata")
//                prefs.removeObject(forKey:"ISLanguage")
//                prefs.removeObject(forKey:"langType")

                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC

                self.navigationController?.pushViewController(vc!, animated: false)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Digo_Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)

        }
        else if arrVCList[indexPath.row] == NSLocalizedString("Digo_order", comment: "")
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TimeLineVC") as? TimeLineVC
            self.navigationController?.pushViewController(vc!, animated: false)

        }
        else if arrVCList[indexPath.row] == NSLocalizedString("Digo_Profile_Contact", comment: "")
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC
            self.navigationController?.pushViewController(vc!, animated: false)

        }

        else if arrVCList[indexPath.row] == NSLocalizedString("Digo_Profile_Refer", comment: "")
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReferFriendVC") as? ReferFriendVC
            self.navigationController?.pushViewController(vc!, animated: false)

        }

        else if arrVCList[indexPath.row] == NSLocalizedString("Digo_Profile_Change_Language", comment: "")
        {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SelectLanguageVC") as? SelectLanguageVC
            self.navigationController?.pushViewController(vc!, animated: false)

        }


    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1
        {
            return 100
        }else{
            return 44
        }
    }


}
