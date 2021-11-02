//
//  ReferFriendVC.swift
//  DIGO
//
//  Created by ADMS on 26/10/21.
//

import UIKit
import SwiftyJSON
import Toast_Swift
import MBProgressHUD
import Toaster

class ReferFriendVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtNumber:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var btnReferal:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        txtName.textAlignment = .center
        txtNumber.textAlignment = .center
        txtEmail.textAlignment = .center

        btnReferal.layer.cornerRadius = btnReferal.layer.frame.height/2.0
        btnReferal.layer.masksToBounds = true

        btnReferal.setTitle("\(NSLocalizedString("Digo_credit", comment: ""))", for: .normal)

    }
    
    @IBAction func btnClick()
    {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func btnClickRefaral()
    {
//        self.navigationController?.popViewController(animated: false)

        if validated() == true
        {
            coinsListApiCall()
        }
    }

}
extension ReferFriendVC
{
    func validated() -> Bool
    {
        var valid: Bool = true

        let Firstname = txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let MobileNumber = txtNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        if Firstname == ""
        {
           // self.view.makeToast(NSLocalizedString("Digo_error_msg3", comment: ""))
            let toast =  Toast(text: (NSLocalizedString("Digo_error_msg3", comment: "")), duration: 3.0)
            toast.show()

            valid = false
        }
        else if MobileNumber == ""
        {
           // self.view.makeToast(NSLocalizedString("Digo_error_msg4", comment: ""))
            let toast =  Toast(text: (NSLocalizedString("Digo_error_msg4", comment: "")), duration: 3.0)
            toast.show()

            valid = false
        }

        else if (MobileNumber.count < 10)
        {
            //self.view.makeToast(NSLocalizedString("Digo_error_msg4", comment: ""))
            let toast =  Toast(text: (NSLocalizedString("Digo_error_msg4", comment: "")), duration: 3.0)
            toast.show()

            valid = false
        }
        else if Email == ""
        {
          //  self.view.makeToast(NSLocalizedString("Digo_error_msg6", comment: ""))
            let toast =  Toast(text: (NSLocalizedString("Digo_error_msg6", comment: "")), duration: 3.0)
            toast.show()

            valid = false
        }
        else if !Email.isValidEmail()
        {
           // self.view.makeToast(NSLocalizedString("Digo_error_msg7", comment: ""))
            let toast =  Toast(text: (NSLocalizedString("Digo_error_msg7", comment: "")), duration: 3.0)
            toast.show()

            valid = false
        }

        return valid
    }
}
extension ReferFriendVC{

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            if textField == txtNumber
            {
                let charsLimit = 10

                let startingLength = textField.text?.count ?? 0
                let lengthToAdd = string.count
                let lengthToReplace =  range.length
                let newLength = startingLength + lengthToAdd - lengthToReplace

                return newLength <= charsLimit
            }
//           else if textField == txtPincode
//            {
//                let charsLimit = 6
//
//                let startingLength = textField.text?.count ?? 0
//                let lengthToAdd = string.count
//                let lengthToReplace =  range.length
//                let newLength = startingLength + lengthToAdd - lengthToReplace
//
//                return newLength <= charsLimit
//
//            }
           else{
            return true
           }

        }
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        //textField code
        self.view.endEditing(true)

        //textField.resignFirstResponder()  //if desired
       // performAction()
        return false
    }
}
// MARK: - ApiCalling
extension ReferFriendVC{
    func coinsListApiCall()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
      //  self.arrProductList.removeAll()

        var params = [String : Any]()

        if let result  = UserDefaults.standard.value(forKey: "isLogin"){
            if (result as! String == "1")
            {
                if let result1  = UserDefaults.standard.value(forKey: "logindata"){
                    let json = JSON(result1)

                    if let name = txtName.text, let email = txtEmail.text, let mobile = txtNumber.text
                    {
                        params = ["CustomerID":json["CustomerID"].stringValue,"Email":email,"Name":name,"Mobile":mobile,"StatusID":"1"]
                        print("GeneratePaymentRequest_Razor(",params)

                    }
                }
            }
        }
        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.Add_ReferredFriends, params: params) { (responceJson) in
            if(responceJson["status"] == "true")
            {

                self.txtName.text = ""
                self.txtNumber.text = ""
                self.txtEmail.text = ""
                MBProgressHUD.hide(for: self.view, animated: true)
              //  self.showToast(message: responceJson["Msg"].stringValue, seconds: 3.0)
//                self.view.makeToast(responceJson["Msg"].stringValue, duration: 3.0, position: .bottom)
                let toast =  Toast(text: NSLocalizedString("Digo_refferal", comment: ""), duration: 3.0)
                toast.show()
                self.navigationController?.popViewController(animated: false)
            }else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
          //  self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
            let toast =  Toast(text: errorMessage, duration: 3.0)
            toast.show()

        }
    }
}
