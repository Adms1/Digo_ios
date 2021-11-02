//
//  RegisterVC.swift
//  DIGO
//
//  Created by ADMS on 20/10/21.
//

import UIKit
import Toast_Swift
import MBProgressHUD
import Toaster

class RegisterVC: UITableViewController,UITextFieldDelegate {

    // MARK: - IBOutlat
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var txtFirstname:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var txtMobileNumber:UITextField!
    @IBOutlet weak var btnAllreadySign:UIButton!

    var myString = ""
    var myMutableString = NSMutableAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()
       // txtMobileNumber.delegate = self
        self.txtEmail.addTarget(nil, action:Selector("firstResponderAction:"), for:.editingDidEndOnExit)
        self.txtPassword.addTarget(nil, action:Selector("firstResponderAction:"), for:.editingDidEndOnExit)
        self.txtFirstname.addTarget(nil, action:Selector("firstResponderAction:"), for:.editingDidEndOnExit)
        self.txtMobileNumber.addTarget(nil, action:Selector("firstResponderAction:"), for:.editingDidEndOnExit)

        myString = NSLocalizedString("Digo_signUp_member", comment: "")
        let str = NSLocalizedString("Digo_Diff_signUp", comment: "")
        let str1 = NSLocalizedString("Digo_Diff1_signUp", comment: "")

        let attrStri = NSMutableAttributedString.init(string:myString)
        let nsRange = NSString(string: myString).range(of: str, options: String.CompareOptions.caseInsensitive)

        let nsRange1 = NSString(string: myString).range(of: str1, options: String.CompareOptions.caseInsensitive)

        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont.init(name: "Georgia", size: 18.0) as Any], range: nsRange1)

        attrStri.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0) as Any], range: nsRange)


//        myMutableString = NSMutableAttributedString(
//                   string: myString,
//            attributes: [NSAttributedString.Key.font:
//                       UIFont(name: "Georgia", size: 18.0)!])
//        btnAllreadySign.setTitleColor(.lightGray, for: .normal)
        btnAllreadySign.setAttributedTitle(attrStri, for: .normal)


        txtFirstname.addPadding(.left(10))
        txtEmail.addPadding(.left(10))
        txtPassword.addPadding(.left(10))
        txtMobileNumber.addPadding(.left(10))
        
        btnRegister.layer.cornerRadius = btnRegister.layer.frame.height/2.0
        btnRegister.layer.masksToBounds = true
    }
    @objc func firstResponderAction()
    {
        self.view.endEditing(true)
    }
    // MARK: - IBAction

    @IBAction func btnClickBack(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnClickLogin(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnClickRegister(_ sender:UIButton)
    {
        if validated() == true
        {
            checkEmailDuplicateApiCall()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height + 90
    }
}

extension RegisterVC
{
    func validated() -> Bool
    {
        var valid: Bool = true

        let Firstname = txtFirstname.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Password =  txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let MobileNumber = txtMobileNumber.text!.trimmingCharacters(in: .whitespacesAndNewlines)


        if Firstname == ""
        {
            self.view.makeToast(NSLocalizedString("Digo_error_msg3", comment: ""))
            valid = false
        }
        else if MobileNumber == ""
        {
            self.view.makeToast(NSLocalizedString("Digo_error_msg4", comment: ""))
            valid = false
        }

        else if (MobileNumber.count < 10)
        {
            self.view.makeToast(NSLocalizedString("Digo_error_msg4", comment: ""))
            valid = false
        }
        else if Password == ""
        {
            self.view.makeToast(NSLocalizedString("Digo_error_msg5", comment: ""))
            valid = false
        }
        else if Email == ""
        {
            self.view.makeToast(NSLocalizedString("Digo_error_msg6", comment: ""))
            valid = false
        }
        else if !Email.isValidEmail() 
        {
            self.view.makeToast(NSLocalizedString("Digo_error_msg7", comment: ""))
            valid = false
        }

        return valid
    }
}
extension RegisterVC{

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            if textField == txtMobileNumber
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
extension RegisterVC{
    func registerApiCall()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        guard let firstname = txtFirstname.text, let mobile = txtMobileNumber.text ,let email = txtEmail.text,let password = txtPassword.text else {
            return
        }
        var params = [String : Any]()
        params = ["FirstName":firstname,"LastName":"","Mobile":mobile,"EmailID":email,"Password":password,"AccountType":"1","IsActive":"true"]

        ApiHttpUtility.sharedUHttp.callPostHttpUtility(urlString: API.AddCustomer, params: params) { (responceJson) in
            if(responceJson["status"] == "true") {
                MBProgressHUD.hide(for: self.view, animated: true)

                print("register user status",responceJson["status"])
                let jsonArray = responceJson["data"].dictionaryObject!
                UserDefaults.standard.set(jsonArray, forKey: "logindata")
                UserDefaults.standard.set("1", forKey: "isLogin")

//                self.view.makeToast(NSLocalizedString("Digo_success_register", comment: ""), duration: 3.0, position: .bottom)
                let toast =  Toast(text: NSLocalizedString("Digo_success_register", comment: ""), duration: 3.0)
                toast.show()

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.PushTLoginViewController()


                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BaseTabBarViewController") as! BaseTabBarViewController

        //                    let rootVC = storyboard.instantiateViewController(withIdentifier: select_CV) as UIViewController


                let frontNavigationController = UINavigationController(rootViewController: rootVC)
                appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                appDelegate.window?.rootViewController = frontNavigationController
                appDelegate.window?.makeKeyAndVisible()


//                self.navigationController?.popViewController(animated: false)

            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
                print("checkEmail is duplicate or not",responceJson["status"])
//                self.view.makeToast(NSLocalizedString("Digo_mobile_exit", comment: ""), duration: 3.0, position: .bottom)
                let toast =  Toast(text: NSLocalizedString("Digo_mobile_exit", comment: ""), duration: 3.0)
                toast.show()


            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)

            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
        }
    }
    func checkEmailDuplicateApiCall()
    {
        guard let email = txtEmail.text else {
            return
        }
        var params = [String : Any]()
        params = ["EmailID":email]

        ApiHttpUtility.sharedUHttp.callApiEmailCheckPostHttpUtility(urlString: API.CheckEmailDuplicate, params: params) { [self] (responceJson) in
            if(responceJson["status"] == "true")
            {
                MBProgressHUD.hide(for: self.view, animated: true)

              //  print("checkEmail is duplicate or not",responceJson["status"])
             //   self.view.makeToast("email is already registered", duration: 3.0, position: .bottom)
                let toast =  Toast(text: NSLocalizedString("Digo_email_exit", comment: ""), duration: 3.0)
                toast.show()

            }else
            {
//                MBProgressHUD.hide(for: self.view, animated: true)
                self.registerApiCall()
            }
        } errorComplition: { (errorMessage) in
            MBProgressHUD.hide(for: self.view, animated: true)
//            self.view.makeToast(errorMessage, duration: 3.0, position: .bottom)
            let toast =  Toast(text: errorMessage, duration: 3.0)
            toast.show()

        }
    }
}
//extension String {
//   var isValidEmail: Bool {
//      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
//      return testEmail.evaluate(with: self)
//   }
////   var isValidPhone: Bool {
////      let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
////      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
////      return testPhone.evaluate(with: self)
////   }
//}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
